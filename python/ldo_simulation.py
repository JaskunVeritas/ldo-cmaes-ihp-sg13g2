"""Run LDO testbenches and extract the metrics used by the notebooks."""

from __future__ import annotations

import re
import subprocess
from pathlib import Path
from typing import Any

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt


PROJECT_ROOT = Path(__file__).resolve().parent
DESIGNS_DIR = PROJECT_ROOT.parent / "designs" / "1iee34"
SIMULATIONS_DIR = PROJECT_ROOT.parent / "simulations" / "ngspice"
PLOTS_DIR = PROJECT_ROOT.parent / "rendimiento de circuito"
XSCHEM = PROJECT_ROOT.parent / "opt" / "xschem" / "bin" / "xschem"
NGSPICE = PROJECT_ROOT.parent / "opt" / "ngspice" / "bin" / "ngspice"
TESTBENCHES = (
    "tb_ldo_DCV",
    "tb_ldo_DCI",
    "tb_ldo_PM",
    "tb_ldo_PSRR",
    "tb_ldo_noise",
    "tb_ldo_noise_2",
)
LDO1_SCHEMATIC = DESIGNS_DIR / "LDO1.sch"


def _read_ascii_raw(path: Path) -> tuple[list[str], np.ndarray]:
    if not path.is_file():
        raise FileNotFoundError(f"Simulation output was not found: {path}")

    lines = path.read_text().splitlines()
    variables = int(next(line.split(":", 1)[1] for line in lines
                         if line.startswith("No. Variables:")))
    points = int(next(line.split(":", 1)[1] for line in lines
                      if line.startswith("No. Points:")))
    variables_start = lines.index("Variables:") + 1
    names = [
        lines[variables_start + index].split(maxsplit=2)[1]
        for index in range(variables)
    ]
    values_start = lines.index("Values:") + 1
    values: list[float] = []
    for line in lines[values_start:]:
        fields = line.split()
        if not fields:
            continue
        value = fields[1] if re.fullmatch(r"\d+", fields[0]) else fields[0]
        values.append(float(value.split(",", 1)[0]))

    expected = points * variables
    if len(values) != expected:
        raise ValueError(
            f"Expected {expected} values in {path}, found {len(values)}"
        )
    return names, np.asarray(values).reshape(points, variables)


def _run_testbench(name: str) -> None:
    netlist = SIMULATIONS_DIR / f"{name}.spice"
    if not netlist.is_file():
        raise FileNotFoundError(f"Testbench netlist was not found: {netlist}")
    if not NGSPICE.is_file():
        raise FileNotFoundError(f"ngspice executable was not found: {NGSPICE}")

    subprocess.run(
        [str(NGSPICE), "-b", "-o", f"{name}.out", netlist.name],
        cwd=SIMULATIONS_DIR,
        check=True,
        capture_output=True,
        text=True,
    )


def _replace_subcircuit_line(
    contents: str,
    element: str,
    replacement: str,
) -> str:
    pattern = rf"(?m)^{re.escape(element)}[^\n]*$"
    updated, count = re.subn(pattern, replacement, contents, count=1)
    if count != 1:
        raise ValueError(
            f"No se encontró exactamente una línea {element} en el netlist."
        )
    return updated


def update_spice_netlists(model_result: tuple[Any, ...]) -> None:
    """Update embedded LDO1 devices in testbench netlists without Xschem."""
    _, _, output_capacitance, rldo1, rldo2, design = model_result
    widths = {
        number: round(float(design[f"W{number}"]) * 1e6, 2)
        for number in range(1, 9)
    }
    lengths = {
        number: round(float(design[f"L{number}"]) * 1e6, 2)
        for number in range(1, 9)
    }
    nf = {
        number: int(np.floor(widths[number] / 10) + 1)
        for number in range(1, 9)
    }
    pass_width = round(float(model_result[0]) * 1e6, 2)
    pass_length = round(float(model_result[1]) * 1e6, 2)
    pass_nf = int(np.floor(pass_width / 20) + 1)

    replacements = {
        "C1": f"C1 VLDO VSS {float(output_capacitance) * 1e9:.12g}n m=1",
        "CC": f"CC net4 net1 {float(design['Cc_val']) * 1e9:.12g}n m=1",
        "R1": f"R1 VLDO VRET {float(rldo1) / 1e3:.12g}k m=1",
        "R2": f"R2 VRET VSS {float(rldo2) / 1e3:.12g}k m=1",
        "XMG": (
            "XMG VLDO net1 VDD VDD sg13_lv_pmos "
            f"w={pass_width:g}u l={pass_length:g}u ng={pass_nf} m=1 mm_ok=1"
        ),
    }
    for number in range(1, 9):
        device = "XM1" if number == 1 else f"XM{number}"
        if number == 2:
            nodes = "net2 VREF- net4 VSS"
        elif number == 1:
            nodes = "net2 VREF+ net3 VSS"
        elif number == 3:
            nodes = "net3 net3 VDD VDD"
        elif number == 4:
            nodes = "net4 net3 VDD VDD"
        elif number == 5:
            nodes = "VSS VG net2 VSS"
        elif number == 6:
            nodes = "net1 net4 VDD VDD"
        elif number == 7:
            nodes = "VSS VG net1 VSS"
        else:
            nodes = "VSS VG VG VSS"
        model = "sg13_lv_pmos" if number in (3, 4, 6) else "sg13_lv_nmos"
        replacements[device] = (
            f"{device} {nodes} {model} w={widths[number]:g}u "
            f"l={lengths[number]:g}u ng={nf[number]} m=1 mm_ok=1"
        )

    for name in TESTBENCHES:
        netlist = SIMULATIONS_DIR / f"{name}.spice"
        if not netlist.is_file():
            raise FileNotFoundError(f"Testbench netlist was not found: {netlist}")
        contents = netlist.read_text()
        for element, replacement in replacements.items():
            contents = _replace_subcircuit_line(contents, element, replacement)
        netlist.write_text(contents)


def update_ldo1_schematic(model_result: tuple[Any, ...]) -> Path:
    """Update the generated LDO1 Xschem schematic with current parameters."""
    from generate_ldo1 import generate_xschem_schematic

    design = dict(model_result[5])
    design["L2"] = design["L1"]
    design["L4"] = design["L3"]
    design["W2"] = design["W1"]
    design["W4"] = design["W3"]
    model_for_schematic = (*model_result[:5], design)
    generate_xschem_schematic(model_for_schematic, LDO1_SCHEMATIC)
    return LDO1_SCHEMATIC


def export_xschem_netlist(schematic: Path) -> Path:
    """Export an Xschem schematic and return the generated ngspice netlist."""
    schematic = Path(schematic)
    if not schematic.is_file():
        raise FileNotFoundError(f"Schematic was not found: {schematic}")
    if not XSCHEM.is_file():
        raise FileNotFoundError(f"xschem executable was not found: {XSCHEM}")

    SIMULATIONS_DIR.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [str(XSCHEM), "--netlist", "--quit", str(schematic)],
        cwd=schematic.parent,
        check=True,
        capture_output=True,
        text=True,
    )

    netlist = SIMULATIONS_DIR / f"{schematic.stem}.spice"
    if not netlist.is_file():
        raise RuntimeError(
            f"Xschem finished without creating the expected netlist: {netlist}"
        )
    return netlist


def _phase_margin() -> tuple[float, float]:
    _, data = _read_ascii_raw(SIMULATIONS_DIR / "tb_ldo_PM_03.raw")
    frequency, loopgain_db, phase_deg = data.T
    unity_frequency = float(np.interp(0, np.flip(loopgain_db), np.flip(frequency)))
    phase = float(np.interp(unity_frequency, frequency, phase_deg))
    return phase, unity_frequency


def _psrr_at_10_hz() -> float:
    _, data = _read_ascii_raw(SIMULATIONS_DIR / "tb_ldo_PSRR_03.raw")
    frequency, psrr_db, _ = data.T
    return float(np.interp(np.log10(10.0), np.log10(frequency), psrr_db))


def _output_noise(raw_name: str = "ckt_noise2.raw") -> tuple[float, float]:
    names, data = _read_ascii_raw(SIMULATIONS_DIR / raw_name)
    frequency = data[:, names.index("frequency")]
    output_density = data[:, names.index("onoise_spectrum")]
    if frequency[0] > 1.0 or frequency[-1] < 10e6:
        raise ValueError(
            f"{raw_name} does not cover the required 1 Hz-10 MHz range"
        )

    def rms_between(max_frequency: float) -> float:
        mask = (frequency >= 1.0) & (frequency <= max_frequency)
        return float(np.sqrt(np.trapz(output_density[mask] ** 2,
                                      frequency[mask])))

    return rms_between(10e3), rms_between(10e6)


def _dc_regulation(raw_name: str) -> tuple[np.ndarray, np.ndarray, float]:
    names, data = _read_ascii_raw(SIMULATIONS_DIR / raw_name)
    if len(names) != 2:
        raise ValueError(f"Expected two variables in {raw_name}, found {len(names)}")
    sweep, output = data.T
    slope = float(np.polyfit(sweep, output, 1)[0])
    return sweep, output, slope


def _dc_regulations() -> tuple[float, float]:
    _, _, line_slope = _dc_regulation("tb_ldo_DCV_03.raw")
    _, _, load_slope = _dc_regulation("tb_ldo_DCI_03.raw")
    return line_slope * 1000, load_slope


def _quiescent_consumption() -> tuple[float, float]:
    """Return regulator-only current and power from the PSRR operating point."""
    names, data = _read_ascii_raw(
        SIMULATIONS_DIR / "tb_ldo_PSRR_OP_03.raw"
    )
    required_names = ("v(vdd)", "i(v1)", "i(@r3[i])")
    if data.shape[0] != 1 or any(name not in names for name in required_names):
        raise ValueError(
            "Expected one operating point with v(vdd), v1#branch, and "
            "@r3[i] "
            "in tb_ldo_PSRR_OP_03.raw"
        )
    supply_voltage = data[0, names.index("v(vdd)")]
    supply_current = data[0, names.index("i(v1)")]
    load_current = data[0, names.index("i(@r3[i])")]
    quiescent_current = abs(float(supply_current)) - abs(float(load_current))
    if quiescent_current < 0:
        raise ValueError(
            "PSRR operating point produced a negative quiescent current: "
            f"{quiescent_current:.6e} A"
        )
    quiescent_power = float(supply_voltage) * quiescent_current
    return quiescent_current, quiescent_power


def _save_figure(figure: Any, filename: str) -> Path:
    PLOTS_DIR.mkdir(parents=True, exist_ok=True)
    output = PLOTS_DIR / filename
    figure.savefig(output, dpi=150, bbox_inches="tight")
    plt.close(figure)
    return output


def generate_plots(simulation_id: int = 1) -> dict[str, Path]:
    """Generate PNG plots from one simulation without overwriting others."""
    plot_suffix = f"_simulacion_{simulation_id}"
    _, phase_margin_data = _read_ascii_raw(
        SIMULATIONS_DIR / "tb_ldo_PM_03.raw"
    )
    frequency, loopgain_db, phase_deg = phase_margin_data.T
    figure, axes = plt.subplots(2, 1, sharex=True, figsize=(8, 6))
    axes[0].semilogx(frequency, loopgain_db, label="tb_ldo_PM_03")
    axes[0].set_ylabel("Loopgain-Mag (dB)")
    axes[0].grid()
    axes[0].legend(loc="upper right", fontsize="small")
    axes[1].semilogx(frequency, phase_deg, label="tb_ldo_PM_03")
    axes[1].set_ylabel("Loopgain-Phase (Deg)")
    axes[1].set_xlabel("Frequency (Hz)")
    axes[1].grid()
    axes[1].legend(loc="upper right", fontsize="small")
    figure.tight_layout()
    phase_margin_plot = _save_figure(
        figure, f"ldo_phase_margin{plot_suffix}.png"
    )

    _, psrr_data = _read_ascii_raw(
        SIMULATIONS_DIR / "tb_ldo_PSRR_03.raw"
    )
    frequency, psrr_db, psrr_phase_deg = psrr_data.T
    figure, axes = plt.subplots(2, 1, sharex=True, figsize=(8, 6))
    axes[0].semilogx(frequency, -psrr_db, label="tb_ldo_PSRR_03")
    axes[0].set_ylabel("PSRR-Mag (dB)")
    axes[0].grid()
    axes[0].legend(loc="upper right", fontsize="small")
    axes[1].semilogx(
        frequency, psrr_phase_deg, label="tb_ldo_PSRR_03"
    )
    axes[1].set_ylabel("PSRR-Phase (Deg)")
    axes[1].set_xlabel("Frequency (Hz)")
    axes[1].grid()
    axes[1].legend(loc="upper right", fontsize="small")
    figure.tight_layout()
    psrr_plot = _save_figure(figure, f"ldo_psrr{plot_suffix}.png")

    names, noise_data = _read_ascii_raw(SIMULATIONS_DIR / "ckt_noise2.raw")
    frequency = noise_data[:, names.index("frequency")]
    output_density = noise_data[:, names.index("onoise_spectrum")]
    figure, axis = plt.subplots(figsize=(8, 4.5))
    axis.loglog(frequency, output_density, label="Output noise")
    axis.set_xlabel("Frequency (Hz)")
    axis.set_ylabel("Noise density (V/sqrt(Hz))")
    axis.grid()
    axis.legend(loc="upper right", fontsize="small")
    figure.tight_layout()
    noise_plot = _save_figure(
        figure, f"ldo_output_noise{plot_suffix}.png"
    )

    input_voltage, output_voltage, _ = _dc_regulation("tb_ldo_DCV_03.raw")
    figure, axis = plt.subplots(figsize=(8, 4.5))
    axis.plot(input_voltage, output_voltage * 1000, label="tb_ldo_DCV_03")
    axis.set_xlabel("Input voltage (V)")
    axis.set_ylabel("Output voltage (mV)")
    axis.grid()
    axis.legend(loc="best", fontsize="small")
    figure.tight_layout()
    line_regulation_plot = _save_figure(
        figure, f"ldo_line_regulation{plot_suffix}.png"
    )

    load_current, output_voltage, _ = _dc_regulation("tb_ldo_DCI_03.raw")
    figure, axis = plt.subplots(figsize=(8, 4.5))
    axis.plot(load_current * 1000, output_voltage * 1000, label="tb_ldo_DCI_03")
    axis.set_xlabel("Load current (mA)")
    axis.set_ylabel("Output voltage (mV)")
    axis.grid()
    axis.legend(loc="best", fontsize="small")
    figure.tight_layout()
    load_regulation_plot = _save_figure(
        figure, f"ldo_load_regulation{plot_suffix}.png"
    )

    return {
        "phase_margin": phase_margin_plot,
        "psrr": psrr_plot,
        "output_noise": noise_plot,
        "line_regulation": line_regulation_plot,
        "load_regulation": load_regulation_plot,
    }


def run_and_measure(simulation_id: int = 1) -> dict[str, Any]:
    """Run testbenches and return metrics and plots for one simulation."""
    for testbench in TESTBENCHES:
        _run_testbench(testbench)

    line_regulation, load_regulation = _dc_regulations()
    quiescent_current, quiescent_power = _quiescent_consumption()
    phase_margin, unity_frequency = _phase_margin()
    psrr_10hz = _psrr_at_10_hz()
    noise_1hz_10khz, noise_1hz_10mhz = _output_noise()
    plots = generate_plots(simulation_id)
    return {
        "phase_margin": phase_margin,
        "unity_gain_frequency": unity_frequency,
        "line_regulation": line_regulation,
        "load_regulation": load_regulation,
        "psrr_10hz": psrr_10hz,
        "output_noise_1hz_10khz": noise_1hz_10khz,
        "output_noise_1hz_10mhz": noise_1hz_10mhz,
        "quiescent_current": quiescent_current,
        "quiescent_power": quiescent_power,
        "plots": plots,
    }
