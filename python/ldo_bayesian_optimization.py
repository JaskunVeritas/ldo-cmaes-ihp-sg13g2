"""Bayesian optimization of the LDO design using circuit simulations.

Install the optional optimizer dependency before running this module:

    python -m pip install scikit-optimize

Each objective evaluation updates the existing SPICE testbench netlists,
runs them directly with ngspice, and converts specification violations into
a scalar penalty for the Gaussian-process optimizer.
"""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

try:
    from skopt import gp_minimize
    from skopt.space import Real
except ModuleNotFoundError as error:
    raise ModuleNotFoundError(
        "Falta la dependencia opcional 'scikit-optimize'. Instálala con: "
        "python -m pip install scikit-optimize"
    ) from error

from ldo_optimization import (
    METRIC_NAMES,
    PARAMETER_NAMES,
    error_vector,
    metric_vector,
    model_with_parameters,
    parameter_vector,
    print_results,
)
from generate_ldo1 import ldo_01_model
from ldo_simulation import (
    run_and_measure,
    update_ldo1_schematic,
    update_spice_netlists,
)


PROJECT_ROOT = Path(__file__).resolve().parent
EVOLUTION_PLOTS_DIR = PROJECT_ROOT.parent / "rendimiento de circuito"
DEFAULT_CALLS = 20
OPTIMIZATION_PARAMETER_NAMES = (
    "Rldo1",
    "L1",
    "aspect_ratio_1",
    "L3",
    "aspect_ratio_6",
    "Cc_val",
)
TRANSISTOR_GROUPS = (1, 3, 6)
FIXED_TRANSISTORS = (5, 7, 8)


def _get_specifications() -> dict[str, Any]:
    """Return the specifications used only by the Bayesian optimization."""
    return {
        "tecnologia": "130 nm CMOS",
        "Vrect_min": 1.5,
        "Iload": 50e-3,
        "Vldo": 1.2,
        "Vref": 0.6,
        "load_regulation_max": 0.15,
        "line_regulation_max": 10,
        "phase_margin_min": 60,
        "psrr_10hz_min": 60,
        "output_noise_1hz_10mhz_max": 100e-6,
        "output_noise_1hz_10khz_max": 7e-6,
        "quiescent_current_max": 50e-6,
        "startup_time_max": 100e-6,
        "output_capacitance": 1e-6,
    }


def _initial_model(specifications: dict[str, Any]) -> tuple[Any, ...]:
    """Use the initial design calculated by ``ldo_01_model``."""
    model = ldo_01_model(
        specifications["Iload"],
        specifications["Vldo"],
        specifications["Vrect_min"],
        specifications["Vref"],
    )
    output_capacitance = specifications["output_capacitance"]
    return (
        model[0],
        model[1],
        output_capacitance,
        50e3,
        50e3,
        {
            **model[5],
            "Cldo_val": output_capacitance,
        },
    )


def _search_space() -> list[Real]:
    """Return bounds for the parameters varied by the optimizer."""
    bounds = {
        "Rldo1": (20e3, 100e3),
        "L1": (1.5e-6, 15e-6),
        "aspect_ratio_1": (1.0, 30.0),
        "L3": (2e-6, 40e-6),
        "aspect_ratio_6": (0.5, 3.0),
        "Cc_val": (0.005e-12, 0.3e-12),
    }
    return [
        Real(
            bounds[name][0],
            bounds[name][1],
            prior="log-uniform",
            name=name,
        )
        for name in OPTIMIZATION_PARAMETER_NAMES
    ]


def _full_parameter_vector(
    values: list[float],
    initial_model: tuple[Any, ...],
) -> np.ndarray:
    """Convert lengths and aspect ratios into the circuit parameter vector."""
    variables = dict(zip(OPTIMIZATION_PARAMETER_NAMES, values))
    initial_design = initial_model[5]
    parameters = {
        "widthp": float(initial_model[0]),
        "lengthp": float(initial_model[1]),
        "Rldo1": variables["Rldo1"],
        "Rldo2": variables["Rldo1"],
        "Cc_val": variables["Cc_val"],
    }
    for group in FIXED_TRANSISTORS:
        parameters[f"L{group}"] = float(initial_design[f"L{group}"])
        parameters[f"W{group}"] = float(initial_design[f"W{group}"])
    for group in TRANSISTOR_GROUPS:
        if group == 3:
            length = variables["L3"]
            fixed_shape_ratio = (
                float(initial_design["W3"])
                / float(initial_design["L3"])
            )
            width = length * fixed_shape_ratio
        elif group == 6:
            length = float(initial_design["L6"])
            width = length * variables["aspect_ratio_6"]
        else:
            length = variables[f"L{group}"]
            width = length * variables[f"aspect_ratio_{group}"]
        parameters[f"L{group}"] = length
        parameters[f"W{group}"] = width
        if group in (1, 3):
            parameters[f"L{group + 1}"] = length
            parameters[f"W{group + 1}"] = width
    return np.asarray(
        [parameters[name] for name in PARAMETER_NAMES],
        dtype=float,
    )


def _objective(
    values: list[float],
    initial_model: tuple[Any, ...],
    specifications: dict[str, Any],
    history: list[dict[str, Any]],
) -> float:
    """Run one circuit evaluation and return its normalized violation cost."""
    full_values = _full_parameter_vector(values, initial_model)
    model = model_with_parameters(initial_model, full_values)
    evaluation_number = len(history) + 1
    print(f"\n=== Evaluación bayesiana {evaluation_number} ===")
    update_spice_netlists(model)
    update_ldo1_schematic(model)
    results = run_and_measure(evaluation_number)
    metrics = metric_vector(results)
    errors = error_vector(metrics, specifications)

    optimized_metric_names = (
        "phase_margin",
        "psrr_10hz",
        "output_noise_1hz_10khz",
        "output_noise_1hz_10mhz",
        "quiescent_current",
    )
    optimized_indices = [
        METRIC_NAMES.index(name) for name in optimized_metric_names
    ]
    limits = np.asarray(
        [
            specifications["phase_margin_min"],
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
    objective_weights = np.asarray([10.0, 8.0, 5.0, 4.0, 1.0])
    objective = float(np.sum(objective_weights * normalized_errors**2))
    phase_margin_violation = normalized_errors[0] > 0
    if phase_margin_violation:
        objective += 1000.0 * (1.0 + normalized_errors[0] ** 2)
    history.append(
        {
            "objective": objective,
            "parameters": dict(zip(PARAMETER_NAMES, full_values.tolist())),
            "metrics": dict(zip(METRIC_NAMES, metrics.tolist())),
            "errors": dict(zip(METRIC_NAMES, errors.tolist())),
            "specifications_met": bool(np.all(optimized_errors <= 0)),
            "results": results,
        }
    )
    print(f"Costo objetivo: {objective:.6e}")
    return objective


def _generate_evolution_plots(
    history: list[dict[str, Any]],
) -> dict[str, Path]:
    """Plot one point per Bayesian evaluation for parameters and metrics."""
    if not history:
        raise ValueError("No hay evaluaciones para graficar.")

    EVOLUTION_PLOTS_DIR.mkdir(parents=True, exist_ok=True)
    iterations = np.arange(1, len(history) + 1)
    parameter_values = np.asarray(
        [[entry["parameters"][name] for name in PARAMETER_NAMES]
         for entry in history],
        dtype=float,
    )
    metric_values = np.asarray(
        [[entry["metrics"][name] for name in METRIC_NAMES]
         for entry in history],
        dtype=float,
    )
    objective_values = np.asarray(
        [entry["objective"] for entry in history],
        dtype=float,
    )

    parameter_plot = EVOLUTION_PLOTS_DIR / "ldo_bayesian_parameters.png"
    figure, axes = plt.subplots(7, 3, figsize=(15, 22), squeeze=False)
    for index, name in enumerate(PARAMETER_NAMES):
        axis = axes.flat[index]
        axis.scatter(iterations, parameter_values[:, index], s=18)
        axis.set_title(name)
        axis.set_xlabel("Iteración")
        axis.grid(True, alpha=0.3)
        if np.all(parameter_values[:, index] > 0):
            axis.set_yscale("log")
    for axis in axes.flat[len(PARAMETER_NAMES):]:
        axis.set_visible(False)
    figure.suptitle("Evolución de parámetros del circuito", fontsize=16)
    figure.tight_layout()
    figure.savefig(parameter_plot, dpi=150, bbox_inches="tight")
    plt.close(figure)

    metric_plot = EVOLUTION_PLOTS_DIR / "ldo_bayesian_performance.png"
    figure, axes = plt.subplots(4, 2, figsize=(13, 16), squeeze=False)
    for index, name in enumerate(METRIC_NAMES):
        axis = axes.flat[index]
        axis.scatter(iterations, metric_values[:, index], s=18)
        axis.set_title(name)
        axis.set_xlabel("Iteración")
        axis.grid(True, alpha=0.3)
    for axis in axes.flat[len(METRIC_NAMES):]:
        axis.set_visible(False)
    figure.suptitle("Evolución del rendimiento del circuito", fontsize=16)
    figure.tight_layout()
    figure.savefig(metric_plot, dpi=150, bbox_inches="tight")
    plt.close(figure)

    objective_plot = EVOLUTION_PLOTS_DIR / "ldo_bayesian_objective.png"
    figure, axis = plt.subplots(figsize=(9, 5))
    axis.scatter(iterations, objective_values, s=18)
    axis.set_xlabel("Iteración")
    axis.set_ylabel("Costo objetivo")
    axis.set_title("Evolución del costo de optimización")
    axis.set_yscale("log")
    axis.grid(True, alpha=0.3)
    figure.tight_layout()
    figure.savefig(objective_plot, dpi=150, bbox_inches="tight")
    plt.close(figure)

    return {
        "parameters": parameter_plot,
        "performance": metric_plot,
        "objective": objective_plot,
    }


def optimizar_circuito_bayesiano(
    n_calls: int = DEFAULT_CALLS,
    random_state: int = 42,
) -> dict[str, Any]:
    """Optimize the LDO with Gaussian-process Bayesian optimization."""
    if n_calls < 2:
        raise ValueError("n_calls debe ser al menos 2.")

    specifications = _get_specifications()
    initial_model = _initial_model(specifications)
    initial_vector = parameter_vector(initial_model)
    initial_parameters = [
        (
            initial_vector[PARAMETER_NAMES.index(name)]
            if not name.startswith("aspect_ratio_")
            else initial_vector[
                PARAMETER_NAMES.index(
                    f"W{name.rsplit('_', 1)[1]}"
                )
            ]
            / initial_vector[
                PARAMETER_NAMES.index(
                    f"L{name.rsplit('_', 1)[1]}"
                )
            ]
        )
        for name in OPTIMIZATION_PARAMETER_NAMES
    ]
    history: list[dict[str, Any]] = []
    result = gp_minimize(
        lambda values: _objective(
            values, initial_model, specifications, history
        ),
        dimensions=_search_space(),
        x0=initial_parameters,
        n_calls=n_calls,
        n_initial_points=min(5, n_calls - 1),
        random_state=random_state,
        acq_func="EI",
    )
    best_evaluation = history[result.func_vals.argmin()]
    evolution_plots = _generate_evolution_plots(history)
    print("\n=== Mejor diseño encontrado ===")
    print("\nParámetros del circuito:")
    for name in PARAMETER_NAMES:
        print(f"- {name}: {best_evaluation['parameters'][name]:.12g}")
    print("\nRendimiento obtenido:")
    print_results(best_evaluation["results"])
    print(f"Costo objetivo: {result.fun:.6e}")
    print(
        "Especificaciones cumplidas: "
        f"{best_evaluation['specifications_met']}"
    )
    print("\n=== Gráficas de evolución ===")
    for name, path in evolution_plots.items():
        print(f"- {name}: {path}")
    return {
        "best_parameters": best_evaluation["parameters"],
        "best_objective": float(result.fun),
        "best_results": best_evaluation["results"],
        "history": history,
        "evolution_plots": evolution_plots,
        "optimizer_result": result,
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Optimización bayesiana del circuito LDO."
    )
    parser.add_argument(
        "--calls",
        type=int,
        default=DEFAULT_CALLS,
        help=f"Número de simulaciones (por defecto: {DEFAULT_CALLS}).",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=42,
        help="Semilla reproducible del optimizador.",
    )
    args = parser.parse_args()
    optimizar_circuito_bayesiano(args.calls, args.seed)


if __name__ == "__main__":
    main()
