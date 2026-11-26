from __future__ import annotations

from typing import Any

import numpy as np

MAX_ITERATIONS = 5
PARAMETER_NAMES = (
    "widthp",
    "lengthp",
    "Rldo1",
    "Rldo2",
    "L1",
    "L2",
    "L3",
    "L4",
    "L5",
    "L6",
    "L7",
    "L8",
    "W1",
    "W2",
    "W3",
    "W4",
    "W5",
    "W6",
    "W7",
    "W8",
    "Cc_val",
)
METRIC_NAMES = (
    "phase_margin",
    "line_regulation",
    "load_regulation",
    "psrr_10hz",
    "output_noise_1hz_10khz",
    "output_noise_1hz_10mhz",
    "quiescent_current",
)


def parameter_vector(model_result: tuple[Any, ...]) -> np.ndarray:
    design = model_result[5]
    return np.asarray(
        [
            model_result[0],
            model_result[1],
            model_result[3],
            model_result[4],
            design["L1"],
            design["L2"],
            design["L3"],
            design["L4"],
            design["L5"],
            design["L6"],
            design["L7"],
            design["L8"],
            design["W1"],
            design["W2"],
            design["W3"],
            design["W4"],
            design["W5"],
            design["W6"],
            design["W7"],
            design["W8"],
            design["Cc_val"],
        ],
        dtype=float,
    )


def model_with_parameters(
    model_result: tuple[Any, ...], parameters: np.ndarray
) -> tuple[Any, ...]:
    design = dict(model_result[5])
    for index, parameter_name in enumerate(PARAMETER_NAMES[4:], start=4):
        design[parameter_name] = float(parameters[index])
    return (
        parameters[0],
        parameters[1],
        model_result[2],
        parameters[2],
        parameters[3],
        design,
    )


def metric_vector(results: dict[str, Any]) -> np.ndarray:
    return np.asarray([results[name] for name in METRIC_NAMES], dtype=float)


def _specification_vector(specifications: dict[str, Any]) -> np.ndarray:
    return np.asarray(
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


def error_vector(
    simulation_values: np.ndarray, specifications: dict[str, Any]
) -> np.ndarray:
    """Return positive specification violations and zero for met limits."""
    error = simulation_values - _specification_vector(specifications)
    error[[1, 2]] = np.abs(simulation_values[[1, 2]]) - _specification_vector(
        specifications
    )[[1, 2]]
    error[[0, 3]] *= -1
    return np.maximum(error, 0.0)


def specifications_met(
    results: dict[str, Any], specifications: dict[str, Any]
) -> bool:
    return bool(np.all(error_vector(metric_vector(results), specifications) <= 0))


def next_parameters(
    parameters: np.ndarray,
    error: np.ndarray,
    jacobian: dict[str, dict[str, float]],
    parameter_gains: dict[str, float],
    error_gains: dict[str, float],
) -> np.ndarray:
    """Apply p[n+1] = p[n] + diag(lambda_p) Js.T diag(lambda_e) e."""
    jacobian_matrix = np.asarray(
        [
            [
                jacobian[metric_name].get(parameter_name, 0.0)
                for parameter_name in PARAMETER_NAMES
            ]
            for metric_name in METRIC_NAMES
        ],
        dtype=float,
    )
    parameter_gain_vector = np.asarray(
        [parameter_gains.get(name, 0.0) for name in PARAMETER_NAMES],
        dtype=float,
    )
    error_gain_vector = np.asarray(
        [error_gains[name] for name in METRIC_NAMES],
        dtype=float,
    )
    update = parameter_gain_vector * (
        jacobian_matrix.T @ (error_gain_vector * error)
    )
    updated_parameters = np.maximum(parameters + update, np.finfo(float).eps)
    for parameter_name in (
        "W1",
        "W2",
        "W3",
        "W4",
        "W5",
        "W6",
        "W7",
        "W8",
    ):
        parameter_index = PARAMETER_NAMES.index(parameter_name)
        updated_parameters[parameter_index] = min(
            updated_parameters[parameter_index],
            200e-6,
        )
    capacitor_index = PARAMETER_NAMES.index("Cc_val")
    updated_parameters[capacitor_index] = max(
        updated_parameters[capacitor_index],
        1e-15,
    )
    return updated_parameters


def print_results(results: dict[str, Any]) -> None:
    print("\nResultados:")
    print(f"Phase margin: {results['phase_margin']:.6f} grados")
    print(f"Unity-gain frequency: {results['unity_gain_frequency']:.6f} Hz")
    print(f"Line regulation: {results['line_regulation']:.6f} mV/V")
    print(f"Load regulation: {results['load_regulation']:.6f} mV/mA")
    print(f"PSRR at 10 Hz: {results['psrr_10hz']:.6f} dB")
    print(
        "Quiescent current (no load): "
        f"{results['quiescent_current'] * 1e6:.6f} uA"
    )
    print(
        "Regulator power (no load): "
        f"{results['quiescent_power'] * 1e6:.6f} uW"
    )
    print(
        "Output noise (1 Hz-10 kHz): "
        f"{results['output_noise_1hz_10khz']:.6e} V"
    )
    print(
        "Output noise (1 Hz-10 MHz): "
        f"{results['output_noise_1hz_10mhz']:.6e} V"
    )
    print("\nGráficas de rendimiento:")
    for name, path in results["plots"].items():
        print(f"- {name}: {path}")
