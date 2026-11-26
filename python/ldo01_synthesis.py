from __future__ import annotations

from pathlib import Path
from typing import Any

import numpy as np

from generate_ldo1 import generate_xschem_schematic, ldo_01_model
from ldo_optimization import (
    MAX_ITERATIONS,
    METRIC_NAMES,
    PARAMETER_NAMES,
    error_vector,
    metric_vector,
    model_with_parameters,
    next_parameters,
    parameter_vector,
    print_results,
    specifications_met,
)
from ldo_simulation import export_xschem_netlist, run_and_measure


PROJECT_ROOT = Path(__file__).resolve().parent
XSCHEM_SCHEMATIC = PROJECT_ROOT.parent / "designs" / "1iee34" / "LDO1.sch"


def _get_specifications() -> dict[str, Any]:
    return {
        "tecnologia": "130 nm CMOS",
        "Vrect_min": 1.5,
        "Iload": 50e-3,
        "Vldo": 1.2,
        "Vref": 0.6,
        "load_regulation_max": 0.15e-3,
        "line_regulation_max": 10e-3,
        "phase_margin_min": 60,
        "psrr_10hz_min": 60,
        "output_noise_1hz_10mhz_max": 100e-6,
        "output_noise_1hz_10khz_max": 7e-6,
        "quiescent_current_max": 50e-6,
        "startup_time_max": 100e-6,
        "output_capacitance": 1e-6,
    }


def _sintetizar_circuito(model_result: tuple[Any, ...]) -> None:
    print("Sintetizando archivo Xschem...")
    design = dict(model_result[5])
    design["L2"] = design["L1"]
    design["L4"] = design["L3"]
    design["W2"] = design["W1"]
    design["W4"] = design["W3"]
    model_for_schematic = (*model_result[:5], design)
    generate_xschem_schematic(model_for_schematic, XSCHEM_SCHEMATIC)
    print(f"Archivo generado: {XSCHEM_SCHEMATIC}")
    spice_netlist = export_xschem_netlist(XSCHEM_SCHEMATIC)
    print(f"Netlist SPICE generado: {spice_netlist}")


def _crear_matrices(max_iterations: int) -> tuple[np.ndarray, ...]:
    return (
        np.full((max_iterations, len(PARAMETER_NAMES)), np.nan),
        np.full((max_iterations, len(METRIC_NAMES)), np.nan),
        np.full((max_iterations, len(METRIC_NAMES)), np.nan),
    )


def _crear_modelo_inicial(especificaciones: dict[str, Any]) -> tuple[Any, ...]:
    """Create the initial model shared by synthesis and optimization."""
    modelo = ldo_01_model(
        especificaciones["Iload"],
        especificaciones["Vldo"],
        especificaciones["Vrect_min"],
        especificaciones["Vref"],
    )
    capacitancia_salida = especificaciones["output_capacitance"]
    diseno_inicial = dict(modelo[5])
    diseno_inicial.update(
        {
            "L1": 10e-6,
            "L2": 10e-6,
            "L3": 26e-6,
            "L4": 26e-6,
            "L5": 2e-6,
            "L6": 1.5e-6,
            "L7": 2e-6,
            "L8": 2e-6,
            "W1": 200e-6,
            "W2": 200e-6,
            "W3": 13e-6,
            "W4": 13e-6,
            "W5": 2.2e-6,
            "W6": 3.5e-6,
            "W7": 4.4e-6,
            "W8": 2.2e-6,
            "Cc_val": 0.02e-12,
            "Cldo_val": capacitancia_salida,
            "Rldo1": 30e3,
            "Rldo2": 30e3,
        }
    )
    return (
        modelo[0],
        modelo[1],
        capacitancia_salida,
        30e3,
        30e3,
        diseno_inicial,
    )


def optimizar_circuito(
    max_iterations: int = MAX_ITERATIONS,
) -> dict[str, Any]:
    """Orquesta síntesis, simulación, actualización y resultados."""
    if not 1 <= max_iterations <= MAX_ITERATIONS:
        raise ValueError(f"max_iterations debe estar entre 1 y {MAX_ITERATIONS}")

    especificaciones = _get_specifications()
    print("=== Síntesis inicial del circuito LDO ===")
    modelo_actual = _crear_modelo_inicial(especificaciones)

    matriz_parametros, matriz_resultados, matriz_errores = _crear_matrices(
        max_iterations
    )

    # Ajusta estos valores directamente cuando tengas el Jacobiano y las
    # ganancias identificadas. Las llaves son los nombres fijos del diseño.
    jacobiano = {
        "phase_margin": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": 0.0,
            "Rldo2": 0.0,
            "L1": 0.0,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.0,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.0,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": -0.5,
        },
        "line_regulation": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": 0.0,
            "Rldo2": 0.0,
            "L1": 0.0,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.0,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.5,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
        "load_regulation": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": 0.0,
            "Rldo2": 0.0,
            "L1": 0.0,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.0,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.5,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
        "psrr_10hz": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": 0.0,
            "Rldo2": 0.0,
            "L1": 0.0,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.0,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 1.0,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
        "output_noise_1hz_10khz": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": -2.0,
            "Rldo2": -2.0,
            "L1": 0.25,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.5,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.0,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
        "output_noise_1hz_10mhz": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": -2.0,
            "Rldo2": -2.0,
            "L1": 0.25,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.5,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.0,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
        "quiescent_current": {
            "widthp": 0.0,
            "lengthp": 0.0,
            "Rldo1": 0.5,
            "Rldo2": 0.5,
            "L1": 0.0,
            "L3": 0.0,
            "L5": 0.0,
            "L6": 0.0,
            "L7": 0.0,
            "L8": 0.0,
            "W1": 0.0,
            "W3": 0.0,
            "W5": 0.0,
            "W6": 0.0,
            "W7": 0.0,
            "W8": 0.0,
            "Cc_val": 0.0,
        },
    }
    ganancias_parametros = {
        "widthp": 1.0,
        "lengthp": 1.0,
        "Rldo1": 1.0e5,
        "Rldo2": 1.0e5,
        "L1": 1.0e-3,
        "L3": 1.0,
        "L5": 1.0,
        "L6": 1.0,
        "L7": 1.0,
        "L8": 1.0,
        "W1": 0.001,
        "W3": 1.0,
        "W5": 1.0,
        "W6": 1.0e-8,
        "W7": 1.0,
        "W8": 1.0,
        "Cc_val": 0.0001,
    }
    ganancias_error = {
        "phase_margin": 1.0,
        "line_regulation": 1.0,
        "load_regulation": 1.0,
        "psrr_10hz": 1.0,
        "output_noise_1hz_10khz": 1.0,
        "output_noise_1hz_10mhz": 1.0,
        "quiescent_current": 1.0,
    }

    resultados_finales: dict[str, Any] | None = None
    iteraciones = 0
    for indice in range(max_iterations):
        iteraciones = indice + 1
        print(f"\n=== Iteración {iteraciones}/{max_iterations} ===")

        parametros_actuales = parameter_vector(modelo_actual)
        matriz_parametros[indice] = parametros_actuales

        print("1. Generando el circuito de la iteración...")
        _sintetizar_circuito(modelo_actual)

        print("2. Invocando las simulaciones...")
        resultados_finales = run_and_measure(iteraciones)
        valores_simulados = metric_vector(resultados_finales)
        matriz_resultados[indice] = valores_simulados

        print("3. Calculando el error contra las especificaciones...")
        error_actual = error_vector(valores_simulados, especificaciones)
        matriz_errores[indice] = error_actual
        print(f"Error de la iteración: {error_actual}")

        print("4. Evaluando las especificaciones...")
        if specifications_met(resultados_finales, especificaciones):
            print("Especificaciones cumplidas; se detiene la iteración.")
            break

        if iteraciones == max_iterations:
            print(f"Se alcanzó el máximo de {MAX_ITERATIONS} iteraciones.")
            break

        print("5. Actualizando los parámetros para la siguiente iteración...")
        nuevos_parametros = next_parameters(
            parametros_actuales,
            error_actual,
            jacobiano,
            ganancias_parametros,
            ganancias_error,
        )
        print(f"Nuevos parámetros: {nuevos_parametros}")
        modelo_actual = model_with_parameters(modelo_actual, nuevos_parametros)

    if resultados_finales is None:
        raise RuntimeError("No se obtuvo ningún resultado de simulación.")

    print("\n=== Resultados finales ===")
    print_results(resultados_finales)
    resultados_finales["parameter_matrix"] = matriz_parametros[:iteraciones]
    resultados_finales["results_matrix"] = matriz_resultados[:iteraciones]
    resultados_finales["error_matrix"] = matriz_errores[:iteraciones]
    resultados_finales["parameter_names"] = PARAMETER_NAMES
    resultados_finales["metric_names"] = METRIC_NAMES
    resultados_finales["iterations"] = iteraciones
    resultados_finales["specifications_met"] = specifications_met(
        resultados_finales, especificaciones
    )
    return resultados_finales


# Alias compatible con el nombre original.
optmizar_circuito = optimizar_circuito


if __name__ == "__main__":
    optimizar_circuito()
    print(f"\n=== Iteraciones {matriz_resultados} ===")
