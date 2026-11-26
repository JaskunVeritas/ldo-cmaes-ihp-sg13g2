"""CMA-ES optimization of the LDO using ngspice simulations.

This module uses the same circuit model, specifications, netlist updater,
metrics and plots as ``ldo_bayesian_optimization.py``.  The 6 optimized
values are normalized to [0, 1], keeping CMA-ES numerically well scaled.
"""

from __future__ import annotations

import argparse
import subprocess
import warnings
from pathlib import Path
from typing import Any

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

try:
    import cma
except ModuleNotFoundError as error:
    raise ModuleNotFoundError(
        "Falta la dependencia 'cma'. Instálala con: "
        "python -m pip install cma"
    ) from error

from ldo_bayesian_optimization import (
    OPTIMIZATION_PARAMETER_NAMES,
    _full_parameter_vector,
    _get_specifications,
    _initial_model,
)
from ldo_optimization import (
    METRIC_NAMES,
    PARAMETER_NAMES,
    error_vector,
    metric_vector,
    model_with_parameters,
    parameter_vector,
    print_results,
)
from ldo_simulation import (
    run_and_measure,
    update_ldo1_schematic,
    update_spice_netlists,
)


PROJECT_ROOT = Path(__file__).resolve().parent
DEFAULT_GENERATIONS = 30
DEFAULT_CHILDREN = 10
CMA_STATE_PLOTS_DIR = PROJECT_ROOT.parent / "rendimiento de circuito"

# Linear variables can span very different magnitudes, so logarithmic
# variables are represented as log10 values before normalization.
SEARCH_BOUNDS: dict[str, tuple[float, float, str]] = {
    "Rldo1": (20e3, 100e3, "log"),
    "L1": (1.5e-6, 15e-6, "log"),
    "aspect_ratio_1": (1.0, 30.0, "linear"),
    "L3": (2e-6, 40e-6, "log"),
    "aspect_ratio_6": (0.5, 3.0, "linear"),
    "Cc_val": (0.02e-12, 0.3e-12, "log"),
}

SPECIFICATION_LIMITS = {
    "phase_margin": ("phase_margin_min", "minimum"),
    "line_regulation": ("line_regulation_max", "maximum"),
    "load_regulation": ("load_regulation_max", "maximum"),
    "psrr_10hz": ("psrr_10hz_min", "minimum"),
    "output_noise_1hz_10khz": ("output_noise_1hz_10khz_max", "maximum"),
    "output_noise_1hz_10mhz": ("output_noise_1hz_10mhz_max", "maximum"),
    "quiescent_current": ("quiescent_current_max", "maximum"),
}

PLOT_PARAMETER_LABELS = {
    "widthp": "PMOS width",
    "lengthp": "PMOS length",
    "Rldo1": "R_LDO1",
    "Rldo2": "R_LDO2",
    "L1": "M1 length",
    "L2": "M2 length",
    "L3": "M3 length",
    "L4": "M4 length",
    "L5": "M5 length",
    "L6": "M6 length",
    "L7": "M7 length",
    "L8": "M8 length",
    "W1": "M1 width",
    "W2": "M2 width",
    "W3": "M3 width",
    "W4": "M4 width",
    "W5": "M5 width",
    "W6": "M6 width",
    "W7": "M7 width",
    "W8": "M8 width",
    "aspect_ratio_1": "M1 aspect ratio",
    "aspect_ratio_6": "M6 aspect ratio",
    "Cc_val": "Compensation capacitance",
}
PLOT_METRIC_LABELS = {
    "phase_margin": "Phase margin",
    "line_regulation": "Line regulation",
    "load_regulation": "Load regulation",
    "psrr_10hz": "PSRR at 10 Hz",
    "output_noise_1hz_10khz": "Output noise (1 Hz-10 kHz)",
    "output_noise_1hz_10mhz": "Output noise (1 Hz-10 MHz)",
    "quiescent_current": "Quiescent current",
}


def _normalize_parameter(name: str, value: float) -> float:
    low, high, scale = SEARCH_BOUNDS[name]
    if scale == "log":
        low_value = np.log10(low)
        high_value = np.log10(high)
        return float(
            np.clip(
                (np.log10(value) - low_value)
                / (high_value - low_value),
                0.0,
                1.0,
            )
        )
    return float(np.clip((value - low) / (high - low), 0.0, 1.0))


def _denormalize_parameter(name: str, normalized: float) -> float:
    normalized = float(np.clip(normalized, 0.0, 1.0))
    low, high, scale = SEARCH_BOUNDS[name]
    if scale == "log":
        low_value = np.log10(low)
        high_value = np.log10(high)
        return float(10.0 ** (low_value + normalized * (high_value - low_value)))
    return float(low + normalized * (high - low))


def _denormalize_parameters(normalized: list[float]) -> list[float]:
    return [
        _denormalize_parameter(name, value)
        for name, value in zip(OPTIMIZATION_PARAMETER_NAMES, normalized)
    ]


def _normalized_from_full_parameters(
    parameters: dict[str, float],
) -> list[float]:
    actual = _optimized_parameter_values(parameters)
    return [
        _normalize_parameter(name, actual[name])
        for name in OPTIMIZATION_PARAMETER_NAMES
    ]


def _optimized_parameter_values(
    parameters: dict[str, float],
) -> dict[str, float]:
    actual: dict[str, float] = {}
    for name in OPTIMIZATION_PARAMETER_NAMES:
        if name.startswith("aspect_ratio_"):
            transistor = name.rsplit("_", 1)[1]
            actual[name] = (
                parameters[f"W{transistor}"]
                / parameters[f"L{transistor}"]
            )
        else:
            actual[name] = parameters[name]
    return actual


def _initial_normalized_parameters(
    initial_model: tuple[Any, ...],
) -> list[float]:
    initial_vector = parameter_vector(initial_model)
    actual: dict[str, float] = {}
    for name in OPTIMIZATION_PARAMETER_NAMES:
        if name.startswith("aspect_ratio_"):
            transistor = name.rsplit("_", 1)[1]
            actual[name] = (
                initial_vector[PARAMETER_NAMES.index(f"W{transistor}")]
                / initial_vector[PARAMETER_NAMES.index(f"L{transistor}")]
            )
        else:
            actual[name] = initial_vector[PARAMETER_NAMES.index(name)]
    return [
        _normalize_parameter(name, actual[name])
        for name in OPTIMIZATION_PARAMETER_NAMES
    ]


def _generate_cma_state_plot(
    state_history: list[dict[str, Any]],
) -> dict[str, Path]:
    if not state_history:
        return {}

    CMA_STATE_PLOTS_DIR.mkdir(parents=True, exist_ok=True)
    iterations = np.asarray(
        [entry["iteration"] for entry in state_history],
        dtype=int,
    )
    sigma_values = np.asarray(
        [entry["sigma"] for entry in state_history],
        dtype=float,
    )
    mean_values = np.asarray(
        [entry["mean"] for entry in state_history],
        dtype=float,
    )
    std_values = np.asarray(
        [entry["std"] for entry in state_history],
        dtype=float,
    )

    state_plot = CMA_STATE_PLOTS_DIR / "ldo_cmaes_state.png"
    figure, axes = plt.subplots(3, 1, figsize=(12, 14), squeeze=False)

    sigma_axis = axes.flat[0]
    sigma_axis.scatter(iterations, sigma_values, s=28)
    sigma_axis.set_title("sigma")
    sigma_axis.set_xlabel("CMA-ES Generation")
    sigma_axis.set_yscale("log")
    sigma_axis.grid(True, alpha=0.3)

    mean_axis = axes.flat[1]
    for index, name in enumerate(OPTIMIZATION_PARAMETER_NAMES):
        mean_axis.scatter(
            iterations,
            mean_values[:, index],
            s=18,
            label=PLOT_PARAMETER_LABELS[name],
        )
    mean_axis.set_title("m: normalized mean")
    mean_axis.set_xlabel("CMA-ES Generation")
    mean_axis.grid(True, alpha=0.3)
    mean_axis.legend(ncols=3, fontsize=8)

    std_axis = axes.flat[2]
    for index, name in enumerate(OPTIMIZATION_PARAMETER_NAMES):
        std_axis.scatter(
            iterations,
            std_values[:, index],
            s=18,
            label=PLOT_PARAMETER_LABELS[name],
        )
    std_axis.set_title("Normalized standard deviation")
    std_axis.set_xlabel("CMA-ES Generation")
    std_axis.set_yscale("log")
    std_axis.grid(True, alpha=0.3)
    std_axis.legend(ncols=3, fontsize=8)

    figure.tight_layout()
    figure.savefig(state_plot, dpi=150, bbox_inches="tight")
    plt.close(figure)
    return {"state": state_plot}


def _generate_evolution_plots(
    history: list[dict[str, Any]],
    specifications: dict[str, Any],
) -> dict[str, Path]:
    """Save a separate scatter plot for every parameter and metric."""
    if not history:
        raise ValueError("No hay evaluaciones para graficar.")

    CMA_STATE_PLOTS_DIR.mkdir(parents=True, exist_ok=True)
    iterations = np.arange(1, len(history) + 1)
    generations = np.asarray(
        [entry["generation"] for entry in history],
        dtype=int,
    )
    successful_evaluations = [
        entry for entry in history if entry["specifications_met"]
    ]
    best_successful_evaluation = (
        min(successful_evaluations, key=lambda entry: entry["objective"])
        if successful_evaluations
        else None
    )
    plot_paths: dict[str, Path] = {}

    def mark_generation_boundaries(axis: Any) -> None:
        for index in range(1, len(history)):
            if generations[index] != generations[index - 1]:
                axis.axvline(
                    iterations[index] - 0.5,
                    color="gray",
                    linestyle=":",
                    linewidth=1,
                    alpha=0.8,
                )
        axis.set_xlabel("Evaluation")
        axis.grid(True, alpha=0.3)

    for name in PARAMETER_NAMES:
        is_optimized = name in OPTIMIZATION_PARAMETER_NAMES
        if is_optimized:
            values = np.asarray(
                [
                    _optimized_parameter_values(entry["parameters"])[name]
                    for entry in history
                ],
                dtype=float,
            )
        else:
            values = np.asarray(
                [entry["parameters"][name] for entry in history],
                dtype=float,
            )
        path = CMA_STATE_PLOTS_DIR / f"ldo_cmaes_parameter_{name}.png"
        figure, axis = plt.subplots(figsize=(9, 5))
        parameter_label = PLOT_PARAMETER_LABELS[name]
        axis.set_title(f"Parameter: {parameter_label}")
        axis.set_ylabel(parameter_label)
        mark_generation_boundaries(axis)
        if is_optimized:
            variances = np.asarray(
                [entry["parameter_variances"][name] for entry in history],
                dtype=float,
            )
            points = axis.scatter(
                iterations,
                values,
                c=variances,
                cmap="viridis",
                s=35,
            )
        else:
            axis.plot(
                iterations,
                values,
                color="tab:blue",
                linewidth=2,
                label="Fixed value",
            )
            axis.legend()
        if np.all(values > 0):
            axis.set_yscale("log")
        if is_optimized and best_successful_evaluation is not None:
            successful_value = _optimized_parameter_values(
                best_successful_evaluation["parameters"]
            )[name]
            axis.axhline(
                successful_value,
                color="red",
                linestyle="--",
                linewidth=1.5,
                label=f"Passing value: {successful_value:.6g}",
            )
            axis.legend()
        if is_optimized:
            figure.colorbar(
                points,
                ax=axis,
                label=f"Individual normalized variance of {parameter_label}",
            )
        figure.tight_layout()
        figure.savefig(path, dpi=150, bbox_inches="tight")
        plt.close(figure)
        plot_paths[f"parameter_{name}"] = path

    for name in METRIC_NAMES:
        values = np.asarray(
            [entry["metrics"][name] for entry in history],
            dtype=float,
        )
        path = CMA_STATE_PLOTS_DIR / f"ldo_cmaes_specification_{name}.png"
        figure, axis = plt.subplots(figsize=(9, 5))
        axis.scatter(iterations, values, s=35)
        metric_label = PLOT_METRIC_LABELS[name]
        axis.set_title(f"Metric: {metric_label}")
        axis.set_ylabel(metric_label)
        mark_generation_boundaries(axis)
        specification_name, direction = SPECIFICATION_LIMITS[name]
        limit = float(specifications[specification_name])
        axis.axhline(
            limit,
            color="red",
            linestyle="--",
            linewidth=1.5,
            label=f"Limit ({direction}): {limit:.6g}",
        )
        axis.legend()
        figure.tight_layout()
        figure.savefig(path, dpi=150, bbox_inches="tight")
        plt.close(figure)
        plot_paths[f"specification_{name}"] = path

    objective_values = np.asarray(
        [entry["objective"] for entry in history],
        dtype=float,
    )
    objective_path = CMA_STATE_PLOTS_DIR / "ldo_cmaes_objective.png"
    figure, axis = plt.subplots(figsize=(9, 5))
    axis.scatter(iterations, objective_values, s=35)
    axis.set_title("Objective cost")
    axis.set_ylabel("Cost")
    axis.set_yscale("log")
    mark_generation_boundaries(axis)
    figure.tight_layout()
    figure.savefig(objective_path, dpi=150, bbox_inches="tight")
    plt.close(figure)
    plot_paths["objective"] = objective_path

    return plot_paths


def _objective(
    normalized_values: list[float],
    initial_model: tuple[Any, ...],
    specifications: dict[str, Any],
    history: list[dict[str, Any]],
) -> float:
    """Run one ngspice evaluation and return the same scalar cost."""
    values = _denormalize_parameters(normalized_values)
    full_values = _full_parameter_vector(values, initial_model)
    model = model_with_parameters(initial_model, full_values)
    evaluation_number = len(history) + 1
    print(f"\n=== Evaluación CMA-ES {evaluation_number} ===")
    print(
        "Parámetros normalizados:",
        [f"{value:.6f}" for value in normalized_values],
    )

    try:
        update_spice_netlists(model)
        update_ldo1_schematic(model)
        results = run_and_measure(evaluation_number)
        metrics = metric_vector(results)
        errors = error_vector(metrics, specifications)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as error:
        penalty = 1e12
        print(f"Error explícito en la simulación: {error}")
        print(f"Costo objetivo: {penalty:.6e}")
        history.append(
            {
                "objective": penalty,
                "parameters": dict(zip(PARAMETER_NAMES, full_values.tolist())),
                "metrics": {
                    name: np.nan
                    for name in METRIC_NAMES
                },
                "errors": {
                    name: np.inf
                    for name in METRIC_NAMES
                },
                "specifications_met": False,
                "results": {"simulation_error": str(error)},
                "simulation_failed": True,
            }
        )
        return penalty

    optimized_metric_names = METRIC_NAMES
    optimized_indices = list(range(len(METRIC_NAMES)))
    limits = np.asarray(
        [
            specifications["phase_margin_min"],
            specifications["line_regulation_max"],
            specifications["load_regulation_max"],
            specifications["psrr_10hz_min"],
            specifications["output_noise_1hz_10khz_max"],
            specifications["output_noise_1hz_10mhz_max"],
            specifications["quiescent_current_max"],
        ],
        dtype=float,
    )
    optimized_errors = errors[optimized_indices]
    normalized_errors = np.divide(
        optimized_errors,
        np.maximum(np.abs(limits), np.finfo(float).tiny),
    )
    # PSRR and especially the low-frequency noise are more important than
    # quiescent current and the broader noise band for the requested design.
    objective_weights = np.asarray([12.0, 6.0, 6.0, 12.0, 18.0, 10.0, 1.0])
    objective = float(np.sum(objective_weights * normalized_errors**2))

    normalized_phase_margin = normalized_errors[0]
    if normalized_phase_margin > 0:
        objective += 1000.0 * (1.0 + normalized_phase_margin**2)

    normalized_psrr = normalized_errors[3]
    if normalized_psrr > 0:
        objective += 1500.0 * (1.0 + normalized_psrr**2)

    for index in (1, 2):
        if normalized_errors[index] > 0:
            objective += 2000.0 * (
                1.0 + normalized_errors[index]**2
            )

    if not np.isfinite(objective):
        objective = 1e12

    history.append(
        {
            "objective": objective,
            "parameters": dict(zip(PARAMETER_NAMES, full_values.tolist())),
            "metrics": dict(zip(METRIC_NAMES, metrics.tolist())),
            "errors": dict(zip(METRIC_NAMES, errors.tolist())),
            "specifications_met": bool(np.all(errors <= 0)),
            "results": results,
            "simulation_failed": False,
        }
    )
    print(f"Costo objetivo: {objective:.6e}")
    return objective


def optimizar_circuito_cmaes(
    generations: int = DEFAULT_GENERATIONS,
    children: int = DEFAULT_CHILDREN,
    random_state: int = 42,
    sigma0: float = 0.20,
) -> dict[str, Any]:
    """Optimize the LDO with CMA-ES in normalized [0, 1] coordinates."""
    if generations < 1:
        raise ValueError("generations debe ser al menos 1.")
    if children < 2:
        raise ValueError("children debe ser al menos 2.")
    if not 0.01 <= sigma0 <= 0.50:
        raise ValueError("sigma0 debe estar entre 0.01 y 0.50.")

    specifications = _get_specifications()
    initial_model = _initial_model(specifications)
    initial_parameters = _initial_normalized_parameters(initial_model)
    history: list[dict[str, Any]] = []
    state_history: list[dict[str, Any]] = []

    with warnings.catch_warnings():
        warnings.filterwarnings(
            "ignore",
            message=r"Sampling standard deviation i=.*",
            category=UserWarning,
        )
        es = cma.CMAEvolutionStrategy(
            initial_parameters,
            sigma0,
            options={
                "bounds": [
                    [0.0] * len(initial_parameters),
                    [1.0] * len(initial_parameters),
                ],
                "popsize": children,
                "seed": random_state,
                "verb_disp": 1,
            },
        )

    max_fevals = generations * children
    specifications_satisfied = False
    while len(history) < max_fevals and not specifications_satisfied:
        generation = int(es.countiter) + 1
        parameter_variances = np.square(np.asarray(es.stds, dtype=float))
        candidates = es.ask()
        objective_values = []
        evaluated_candidates = []
        for candidate in candidates:
            objective_values.append(
                _objective(
                    candidate.tolist(),
                    initial_model,
                    specifications,
                    history,
                )
            )
            history[-1]["generation"] = generation
            history[-1]["parameter_variances"] = dict(
                zip(
                    OPTIMIZATION_PARAMETER_NAMES,
                    parameter_variances.tolist(),
                )
            )
            evaluated_candidates.append(candidate)
            if history[-1]["specifications_met"]:
                specifications_satisfied = True
                print(
                    "Especificaciones cumplidas; se detienen "
                    "las simulaciones."
                )
                break
            if len(history) >= max_fevals:
                break
        if specifications_satisfied:
            break
        es.tell(evaluated_candidates, objective_values)
        mean_normalized = np.asarray(es.mean, dtype=float)
        std_normalized = np.asarray(es.stds, dtype=float)
        state_history.append(
            {
                "iteration": int(es.countiter),
                "sigma": float(es.sigma),
                "mean": mean_normalized.copy(),
                "std": std_normalized.copy(),
            }
        )
        print(
            f"\n=== Estado CMA-ES generación {es.countiter} "
            f"(evaluaciones acumuladas {len(history)}, "
            f"{children} hijos por generación) ==="
        )
        print(f"sigma: {es.sigma:.12g}")
        print("m (media normalizada):")
        for name, value in zip(
            OPTIMIZATION_PARAMETER_NAMES,
            mean_normalized,
        ):
            print(f"- {name}: {value:.12g}")
        print("desviación estándar normalizada:")
        for name, value in zip(
            OPTIMIZATION_PARAMETER_NAMES,
            std_normalized,
        ):
            print(f"- {name}: {value:.12g}")

    valid_history = [
        entry
        for entry in history
        if not entry["simulation_failed"]
        and np.isfinite(entry["objective"])
    ]
    if not valid_history:
        raise RuntimeError(
            "CMA-ES terminó sin ninguna simulación válida."
        )

    best_evaluation = min(valid_history, key=lambda entry: entry["objective"])
    best_normalized = _normalized_from_full_parameters(
        best_evaluation["parameters"]
    )

    if not specifications_satisfied:
        print("\n=== Verificación final del mejor candidato ===")
        verification_number = len(history) + 1
        verification_model = model_with_parameters(
            initial_model,
            np.asarray(
                [
                    best_evaluation["parameters"][name]
                    for name in PARAMETER_NAMES
                ],
                dtype=float,
            ),
        )
        update_spice_netlists(verification_model)
        update_ldo1_schematic(verification_model)
        verification_results = run_and_measure(verification_number)
        verification_metrics = metric_vector(verification_results)
        verification_errors = error_vector(
            verification_metrics,
            specifications,
        )
        verification_specifications_met = bool(
            np.all(verification_errors <= 0)
        )

        best_evaluation["results"] = verification_results
        best_evaluation["metrics"] = dict(
            zip(METRIC_NAMES, verification_metrics.tolist())
        )
        best_evaluation["errors"] = dict(
            zip(METRIC_NAMES, verification_errors.tolist())
        )
        best_evaluation["specifications_met"] = (
            verification_specifications_met
        )
        best_evaluation["verification_results"] = verification_results

        print(
            f"Candidato re-simulado con ID {verification_number}: "
            f"{verification_specifications_met}"
        )

    evolution_plots = _generate_evolution_plots(history, specifications)
    evolution_plots.update(_generate_cma_state_plot(state_history))

    print("\n=== Mejor diseño encontrado con CMA-ES ===")
    print("\nParámetros normalizados:")
    for name, value in zip(
        OPTIMIZATION_PARAMETER_NAMES,
        best_normalized,
    ):
        print(f"- {name}: {value:.12g}")

    print("\nParámetros físicos:")
    for name in PARAMETER_NAMES:
        print(f"- {name}: {best_evaluation['parameters'][name]:.12g}")

    print("\nRendimiento obtenido:")
    if "simulation_error" not in best_evaluation["results"]:
        print_results(best_evaluation["results"])
    print(f"Costo objetivo: {best_evaluation['objective']:.6e}")
    print(
        "Especificaciones cumplidas: "
        f"{best_evaluation['specifications_met']}"
    )
    print("\n=== Gráficas de evolución ===")
    for name, path in evolution_plots.items():
        print(f"- {name}: {path}")

    return {
        "best_parameters": best_evaluation["parameters"],
        "best_normalized_parameters": [
            float(value) for value in best_normalized
        ],
        "best_objective": float(best_evaluation["objective"]),
        "best_results": best_evaluation["results"],
        "history": history,
        "evolution_plots": evolution_plots,
        "optimizer_result": es,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Optimización CMA-ES del circuito LDO."
    )
    parser.add_argument(
        "--generations",
        type=int,
        default=DEFAULT_GENERATIONS,
        help=f"Número de generaciones (por defecto: {DEFAULT_GENERATIONS}).",
    )
    parser.add_argument(
        "--children",
        type=int,
        default=DEFAULT_CHILDREN,
        help=f"Hijos por generación (por defecto: {DEFAULT_CHILDREN}).",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=42,
        help="Semilla reproducible del optimizador.",
    )
    parser.add_argument(
        "--sigma",
        type=float,
        default=0.20,
        help="Desviación inicial normalizada (por defecto: 0.20).",
    )
    args = parser.parse_args()
    optimizar_circuito_cmaes(
        generations=args.generations,
        children=args.children,
        random_state=args.seed,
        sigma0=args.sigma,
    )


if __name__ == "__main__":
    main()
