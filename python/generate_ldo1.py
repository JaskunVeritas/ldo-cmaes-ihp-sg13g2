#!/usr/bin/python3

import sys
from contextlib import redirect_stdout
from pathlib import Path

import numpy as np

# ****************************************************************
# Functions

def ceil_sig(value, digits):
    if digits <= 0:
        raise ValueError('digits must be a positive integer')
    value_array = np.asarray(value, dtype=float)
    result = np.zeros_like(value_array)
    nonzero = value_array != 0
    if np.any(nonzero):
        values = value_array[nonzero]
        exponent = np.floor(np.log10(np.abs(values)))
        factor = 10 ** (exponent - (digits - 1))
        result[nonzero] = np.sign(values) * np.ceil(np.abs(values) / factor) * factor
    return float(result) if result.ndim == 0 else result


def ldo_01_model(Iload,Vldo,Vrect,Vref):
    # transistor parameters
    vthp = 0.5 # V
    upcox = 22.1e-6 # A/V^2
    lambdap = 0.06 # 1/V
    lambdan = 0.09 # 1/V
    cgsp_w_l130nm = 0.89*1e-15/1e-6 # F/m
    cgdp_w_l130nm = 0.13*1e-15/1e-6 # F/m
    cdbp_w = 0.28*1e-15/1e-6 # F/m
    csbp_w = 0.36*1e-15/1e-6 # F/m
    covp_w = 300/500*1e-15/1e-6 # F/m

    # LDO modeling
    L_opamp = 1.5e-6
    L_opamp2 = 2000e-9
    GBW_opamp = 80e6
    SR_opamp = 24
    ADC_opamp = 1000
    ICMR_pos = 1
    ICMR_neg = 0.5
    VDD_opamp = 1.5
    Vthp_opamp = 0.5
    Vthn_opamp = 0.4
    upcox_opamp = 22.1e-6
    uncox_opamp = 170e-6
    vtn_opamp = 0.23
    vtp_opamp = 0.24
    PM_opamp = 60

    # default values
    Rldo1 = 50e3
    Rldo2 = Rldo1 / (Vldo / Vref - 1)

    Cldo = np.array([5e-9,20e-9,80e-9,400e-9,1200e-9,5000e-9]) # F

    Rload = Vldo / Iload

    vdropout = Vrect - Vldo
    if vdropout > 0.2:
        vdropout = 0.2

    # initial values of Mp
    widthp = np.array([10e-6,20e-6,50e-6,100e-6,200e-6,250e-6]) # m
    lengthp = 0.130e-6 # m

    vgs = 0.5 # V

    gmp = np.sqrt(2*upcox*(widthp/lengthp)*Iload)
    rop = 1/(lambdap*Iload)

    cgsp = cgsp_w_l130nm*widthp
    cgdp = cgdp_w_l130nm*widthp
    cdbp = cdbp_w*widthp
    csbp = csbp_w*widthp
    covp = covp_w*widthp

    Cvg = cgsp + cgdp
    Cl_opamp = Cvg
    beta = Rldo2/(Rldo1+Rldo2)
    GBW_p2 = np.tan(np.deg2rad(-np.rad2deg(np.arctan(1 / 10)) - 90 + 180 - PM_opamp))
    Cc_Cl = 1 / GBW_p2 / 10
    CC = ceil_sig(Cc_Cl * Cl_opamp, 1)
    Id_opamp = ceil_sig(SR_opamp * CC * 1e6, 1)
    gm1 = ceil_sig(GBW_opamp * CC * 2 * np.pi, 2)
    W_L1 = ceil_sig(gm1 * gm1 / (uncox_opamp * Id_opamp), 1)
    W_L3 = Id_opamp / upcox_opamp / (VDD_opamp - ICMR_pos - Vthp_opamp + Vthn_opamp)
    Vd5 = ICMR_neg - np.sqrt(Id_opamp / uncox_opamp / W_L1) - vtn_opamp
    W_L5 = ceil_sig(2 * Id_opamp / (uncox_opamp * Vd5 * Vd5), 2)
    gm6 = 2 * gm1
    gm3 = ceil_sig(np.sqrt(upcox_opamp * W_L3 * Id_opamp), 2)
    I6 = 2*Id_opamp
    W_L7 = ceil_sig(W_L5 * I6 / Id_opamp, 4)
    W_L6 = ceil_sig(2*W_L3*W_L7/W_L5 , 2)
    Isource = 5e-6
    W_L8 = W_L5 * Isource / Id_opamp
    m1 = W_L1 * L_opamp
    m2 = m1
    m3 = W_L3 * L_opamp2
    m4 = m3
    m5 = W_L5 * L_opamp2 * 2
    m6 = W_L6 * L_opamp
    m7 = W_L7 * L_opamp2 * 2
    m8 = W_L8 * L_opamp2

    Vrect_design = 1.25
    Vldo_design = 1.2
    Iload_design = 5e-6
    Ra = 500e3
    Rb = Ra * (Vldo_design / 0.6 - 1)

    # Opamp macro-model values derived from the MATLAB design
    R1 = 1/(lambdan*Id_opamp)
    R2 = 1/(lambdap*I6)
    Gm = gm1*R1*gm6*R2
    A_DC = gm1 * R1 * R2 * gm6
    z_opamp = gm6 / CC
    p1_opamp = 1 / (gm6 * R1 * R2 * CC)
    p2_opamp = gm6 / CC
    frequency = np.logspace(0, 7, 1000)
    s = (1j * 2 * np.pi * frequency)[:, np.newaxis]
    H_opamp = A_DC * (1 - s / z_opamp) / ((1 + s / p1_opamp) * (1 + s / p2_opamp))

    Loopgain = gmp * Rload * beta * A_DC
    Vrect_min = Vldo + np.sqrt((2*Iload)/(upcox*(widthp/lengthp)))

    # Poles - Time Constants
    tc1 = Rload * Cldo
    tc2 = 1/p1_opamp
    tc3 = 1/p2_opamp
    pi_value = 3.14159

    p1 = 1/(2*pi_value*tc1)
    p2 = 1/(2*pi_value*tc2)
    p3 = 1/(2*pi_value*tc3)

    gbw = [[],[],[],[],[],[]]
    for i in range(0,6):
        gbw[i] = Loopgain*p1[i]

    widthp_val = np.interp(vdropout, np.flip(Vrect_min - Vldo), np.flip(widthp))
    p2_val = np.interp(widthp_val, widthp, p2)
    gbw_wp = p1 * np.interp(widthp_val, widthp, Loopgain)
    Cldo_val = np.interp(p2_val/10, np.flip(gbw_wp), np.flip(Cldo))
    CC_val = np.interp(widthp_val, widthp, CC)
    m1_val = np.interp(widthp_val, widthp, m1)
    m2_val = m1_val
    m3_val = np.interp(widthp_val, widthp, m3) * 2
    m4_val = m3_val
    m5_val = np.interp(widthp_val, widthp, m5)
    m6_val = np.interp(widthp_val, widthp, m6)
    m7_val = np.interp(widthp_val, widthp, m7)
    m8_val = np.interp(widthp_val, widthp, m8)
    W_L1_val = np.interp(widthp_val, widthp, W_L1)
    W_L3_val = np.interp(widthp_val, widthp, W_L3)
    W_L5_val = np.interp(widthp_val, widthp, W_L5) * 2
    W_L6_val = np.interp(widthp_val, widthp, W_L6)
    W_L7_val = np.interp(widthp_val, widthp, W_L7) * 2
    W_L8_val = np.interp(widthp_val, widthp, W_L8)
    gm1_val = np.interp(widthp_val, widthp, gm1)
    A_DC_val = np.interp(widthp_val, widthp, A_DC)
    Id_opamp_val = np.interp(widthp_val, widthp, Id_opamp)

    design = {
        # Initial transistor lengths. The optimization loop can update each
        # transistor independently after this initial assignment.
        'L1': L_opamp,
        'L2': L_opamp,
        'L3': L_opamp2,
        'L4': L_opamp2,
        'L5': L_opamp2,
        'L6': L_opamp,
        'L7': L_opamp2,
        'L8': L_opamp2,
        'W1': m1_val,
        'W2': m2_val,
        'W3': m3_val,
        'W4': m4_val,
        'W5': m5_val,
        'W6': m6_val,
        'W7': m7_val,
        'W8': m8_val,
        'W_L1': W_L1_val,
        'W_L3': W_L3_val,
        'W_L5': W_L5_val,
        'W_L6': W_L6_val,
        'W_L7': W_L7_val,
        'W_L8': W_L8_val,
        'Cc': CC_val,
        'Cc_val': CC_val,
        'gm1': gm1_val,
        'A_DC': A_DC_val,
        'Id_opamp': Id_opamp_val,
        'widthp_val': widthp_val,
        'lengthp': lengthp,
        'Cldo_val': Cldo_val,
        'Rldo1': Rldo1,
        'Rldo2': Rldo2,
    }

    return widthp_val, lengthp, Cldo_val, Rldo1, Rldo2, design

def nmos_sg13_lv_nmos(name,w_um,l_um,ng,m,position):
    libraryname = 'sg13g2_pr'
    modelname = 'sg13_lv_nmos'
    print('C {' + modelname + '.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name)
    print('l=' + str(l_um) + 'u')
    print('w=' + str(w_um) + 'u')
    print('ng=' + str(ng))
    print('m=' + str(m))
    print('model=' + modelname)
    print('spiceprefix=X')
    print('}')


def pmos_sg13_lv_pmos(name,w_um,l_um,ng,m,position):
    libraryname = 'sg13g2_pr'
    modelname = 'sg13_lv_pmos'
    print('C {' + modelname + '.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name)
    print('l=' + str(l_um) + 'u')
    print('w=' + str(w_um) + 'u')
    print('ng=' + str(ng))
    print('m=' + str(m))
    print('model=' + modelname)
    print('spiceprefix=X')
    print('}')

def iopin(name,label,position):
    pintype = 'iopin'
    print('C {' + pintype + '.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name + ' lab=' + label +'}')

def labpin(name,label,position):
    pintype = ''
    print('C {lab_pin.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name + ' sig_type=std_logic lab=' + label +'}')

def capa(name,cap_fF,position):
    print('C {capa.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name)
    print('m=1')
    print('value=' + str(cap_fF) + 'f')
    print('footprint=1206')
    print('device="ceramic capacitor"}')

def capa_nF(name,cap_nF,position):
    print('C {capa.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name)
    print('m=1')
    print('value=' + str(cap_nF) + 'n')
    print('footprint=1206')
    print('device="ceramic capacitor"}')

def res(name,res_kOhm,position):
    print('C {res.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name)
    print('value=' + str(res_kOhm) + 'k')
    print('footprint=1206')
    print('device=resistor')
    print('m=1}')

def comp(name,comp_name,position):
    print('C {' + comp_name + '.sym} ' + str(position[0]) + ' ' + str(position[1]) + ' ' + str(position[2]) + ' ' + str(position[3]) + ' {name=' + name + '}')

# ****************************************************************
def _generate_xschem_schematic(model_result):
    """Print the generated LDO schematic from an LDO model result."""
    [a,b,c,d,e,design] = model_result
    wp_um = np.round(a*1e6,2)
    lp_um = np.round(b*1e6,2)
    Cldo_nF = np.round(c*1e9,2)
    CC_nF = float(design['Cc_val'])*1e9
    Rldo1_kOhm = np.round(d/1e3,2)
    Rldo2_kOhm = np.round(e/1e3,2)

    # Device sizing for the op-amp transistors used in the schematic
    w1_val = float(design['W1'])
    w2_val = float(design['W2'])
    w3_val = float(design['W3'])
    w4_val = float(design['W4'])
    w5_val = float(design['W5'])
    w6_val = float(design['W6'])
    w7_val = float(design['W7'])
    w8_val = float(design['W8'])

    m3_w_um = np.round(w3_val * 1e6, 2)
    m3_l_um = np.round(float(design['L3']) * 1e6, 2)
    m3_nf = int(np.floor(m3_w_um/10) + 1)

    m4_w_um = np.round(w4_val * 1e6, 2)
    m4_l_um = np.round(float(design['L4']) * 1e6, 2)
    m4_nf = m3_nf

    m6_w_um = np.round(w6_val * 1e6, 2)
    m6_l_um = np.round(float(design['L6']) * 1e6, 2)
    m6_nf = int(np.floor(m6_w_um/10) + 1)

    m1_w_um = np.round(w1_val * 1e6, 2)
    m1_l_um = np.round(float(design['L1']) * 1e6, 2)
    m1_nf = int(np.floor(m1_w_um/10) + 1)

    m2_w_um = np.round(w2_val * 1e6, 2)
    m2_l_um = np.round(float(design['L2']) * 1e6, 2)
    m2_nf = m1_nf

    m5_w_um = np.round(w5_val * 1e6, 2)
    m5_l_um = np.round(float(design['L5']) * 1e6, 2)
    m5_nf = int(np.floor(m5_w_um/10) + 1)

    m7_w_um = np.round(w7_val * 1e6, 2)
    m7_l_um = np.round(float(design['L7']) * 1e6, 2)
    m7_nf = int(np.floor(m7_w_um/10) + 1)

    m8_w_um = np.round(w8_val * 1e6, 2)
    m8_l_um = np.round(float(design['L8']) * 1e6, 2)
    m8_nf = int(np.floor(m8_w_um/10) + 1)

    nf = int(np.floor(wp_um/20) + 1)

    # print schematic
    print('v {xschem version=3.4.6 file_version=1.2}')
    print('G {}')
    print('K {}')
    print('V {}')
    print('S {}')
    print('E {}')
    print('N 490 160 490 180 {lab=VLDO}')
    print('N 490 160 670 160 {lab=VLDO}')
    print('N 490 140 490 160 {lab=VLDO}')
    print('N 490 260 490 280 {lab=VA}')
    print('N 490 340 490 380 {lab=VSS}')
    print('N 490 10 490 110 {lab=VDD}')
    print('N 370 110 450 110 {lab=#net1}')
    print('N 150 260 490 260 {lab=VA}')
    print('N 490 240 490 260 {lab=VA}')
    print('N -220 40 -200 40 {lab=VREF+}')
    print('N -160 70 -160 100 {lab=#net2}')
    print('N 40 70 40 100 {lab=#net2}')
    print('N -60 100 40 100 {lab=#net2}')
    print('N -160 -40 -160 10 {lab=#net3}')
    print('N 40 -140 40 -90 {lab=VDD}')
    print('N -160 -140 -160 -90 {lab=VDD}')
    print('N -160 -140 40 -140 {lab=VDD}')
    print('N -100 -90 0 -90 {lab=#net3}')
    print('N -160 -40 -100 -40 {lab=#net3}')
    print('N -160 -60 -160 -40 {lab=#net3}')
    print('N -100 -90 -100 -40 {lab=#net3}')
    print('N -120 -90 -100 -90 {lab=#net3}')
    print('N 40 -20 40 10 {lab=#net4}')
    print('N -60 100 -60 140 {lab=#net2}')
    print('N -160 100 -60 100 {lab=#net2}')
    print('N -60 170 -60 220 {lab=VSS}')
    print('N -320 170 -320 220 {lab=VSS}')
    print('N -260 170 -100 170 {lab=VG}')
    print('N -320 120 -320 140 {lab=VG}')
    print('N -320 -140 -160 -140 {lab=VDD}')
    print('N -320 120 -260 120 {lab=VG}')
    print('N -260 120 -260 170 {lab=VG}')
    print('N -280 170 -260 170 {lab=VG}')
    print('N -160 40 40 40 {lab=VSS}')
    print('N -320 220 -60 220 {lab=VSS}')
    print('N 40 -60 40 -20 {lab=#net4}')
    print('N 40 -20 100 -20 {lab=#net4}')
    print('N -60 220 220 220 {lab=VSS}')
    print('N 220 200 220 210 {lab=VSS}')
    print('N 220 210 220 220 {lab=VSS}')
    print('N 140 170 180 170 {lab=VG}')
    print('N 100 -20 190 -20 {lab=#net4}')
    print('N 220 10 220 140 {lab=#net1}')
    print('N 320 -140 320 -30 {lab=VDD}')
    print('N 40 -140 320 -140 {lab=VDD}')
    print('N 220 -20 320 -20 {lab=VDD}')
    print('N 320 -30 320 -20 {lab=VDD}')
    print('N 220 50 310 50 {lab=#net1}')
    print('N 220 -140 220 -50 {lab=VDD}')
    print('N 220 170 220 200 {lab=VSS}')
    print('N 40 10 110 10 {lab=#net4}')
    print('N 200 10 200 50 {lab=#net1}')
    print('N 200 50 220 50 {lab=#net1}')
    print('N 110 10 130 10 {lab=#net4}')
    print('N 190 10 200 10 {lab=#net1}')
    print('N 80 40 90 40 {lab=VREF-}')
    print('N 310 50 370 50 {lab=#net1}')
    print('N 370 50 370 110 {lab=#net1}')
    print('N 350 50 350 100 {lab=#net1}')
    print('N 350 160 380 160 {lab=#net6}')
    print('N 440 160 490 160 {lab=VLDO}')
    print('N 580 160 580 190 {lab=VLDO}')
    print('N 580 250 580 280 {lab=VSS}')
    print('N -320 -140 -320 -110 {lab=VDD}')
    print('N -320 -50 -320 10 {lab=#net5}')
    print('N -320 -100 -320 -80 {lab=VDD}')
    print('N -320 70 -320 120 {lab=VG}')
    print('N -420 40 -360 40 {lab=VDD}')
    print('N -420 -140 -420 40 {lab=VDD}')
    print('N -420 -140 -320 -140 {lab=VDD}')
    print('N -320 40 -290 40 {lab=VSS}')
    print('N -290 40 -290 90 {lab=VSS}')
    print('N -320 -110 -320 -100 {lab=VDD}')
    print('N -360 -80 -360 -60 {lab=#net5}')
    print('N -360 -60 -360 -30 {lab=#net5}')
    print('N -360 -30 -320 -30 {lab=#net5}')
    iopin('p2','VREF+',[-220,40,0,1])
    iopin('p4','VLDO',[670,160,0,0])
    iopin('p1','VDD',[320,-140,0,0])
    iopin('p3','VREF-',[90,40,0,0])
    iopin('p5','VSS',[220,200,0,0])
    iopin('p8','VRET',[150,260,0,1])
    labpin('p9','VG',[-270,120,3,1])
    labpin('p6','VSS',[580,260,0,1])
    labpin('p7','VSS',[490,360,0,1])
    labpin('p10','VG',[150,170,3,1])
    labpin('p11','VDD',[490,30,0,1])
    labpin('p12','VSS',[-70,40,0,1])
    labpin('p13','VSS',[-290,70,0,1])
    capa_nF('C1',Cldo_nF,[580,220,0,0])
    capa_nF('CC',CC_nF,[160,10,3,1])
    res('R1',Rldo1_kOhm,[490,210,0,0])
    res('R2',Rldo2_kOhm,[490,310,0,0])
    capa_nF('C3',5,[410,160,1,0])
    res('R3',30,[350,130,0,0])
    # Main pass devices
    pmos_sg13_lv_pmos('MG',wp_um,lp_um,nf,1,[470,110,0,0])
    # Op-amp transistor sizing used for the branch devices
    pmos_sg13_lv_pmos('M3',m3_w_um,m3_l_um,m3_nf,1,[-140,-90,0,1])
    pmos_sg13_lv_pmos('M4',m4_w_um,m4_l_um,m4_nf,1,[20,-90,0,0])
    pmos_sg13_lv_pmos('M6',m6_w_um,m6_l_um,m6_nf,1,[200,-20,0,0])
    nmos_sg13_lv_nmos('M1',m1_w_um,m1_l_um,m1_nf,1,[-180,40,2,1])
    nmos_sg13_lv_nmos('M2',m2_w_um,m2_l_um,m2_nf,1,[60,40,2,0])
    nmos_sg13_lv_nmos('M5',m5_w_um,m5_l_um,m5_nf,1,[-80,170,2,1])
    nmos_sg13_lv_nmos('M7',m7_w_um,m7_l_um,m7_nf,1,[200,170,2,1])
    nmos_sg13_lv_nmos('M8',m8_w_um,m8_l_um,m8_nf,1,[-300,170,2,0])
    pmos_sg13_lv_pmos('M10',2,8,1,1,[-340,-80,0,0])
    nmos_sg13_lv_nmos('M11',2,8,1,1,[-340,40,2,1])
    


def generate_xschem_schematic(model_result, output_path=None):
    """Generate an Xschem schematic, optionally writing it to a file."""
    if output_path is None:
        _generate_xschem_schematic(model_result)
        return

    output = Path(output_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8") as schematic:
        with redirect_stdout(schematic):
            _generate_xschem_schematic(model_result)


if __name__ == "__main__":
    values = (80e-6, 1.5, 1.6, 0.6)
    if len(sys.argv) >= 5:
        try:
            values = tuple(float(value) for value in sys.argv[1:5])
        except ValueError as exc:
            raise ValueError("Expected numeric arguments: Iload Vldo Vrect Vref") from exc
    model_result = ldo_01_model(*values)
    generate_xschem_schematic(model_result)
