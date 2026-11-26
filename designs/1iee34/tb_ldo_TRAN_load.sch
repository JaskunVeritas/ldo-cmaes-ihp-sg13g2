v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -800 60 -800 100 {lab=VDD}
N -560 60 -560 100 {lab=VSS}
N -800 -140 -800 -100 {lab=VREF}
N 220 60 220 100 {lab=VSS}
N 220 -40 220 0 {lab=VLDO}
N -800 -40 -800 0 {lab=VSS}
N 170 -40 220 -40 {lab=VLDO}
N 70 20 70 100 {lab=VSS}
N -30 20 -30 60 {lab=#net1}
N -160 60 -30 60 {lab=#net1}
N -160 -20 -160 60 {lab=#net1}
N -160 -20 -130 -20 {lab=#net1}
N -170 -60 -130 -60 {lab=VREF}
N 20 -150 20 -100 {lab=VDD}
C {vsource.sym} -800 130 0 0 {name=V1 value=1.5 savecurrent=false}
C {gnd.sym} -800 160 0 0 {name=l1 lab=GND}
C {vsource.sym} -560 130 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -560 160 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -800 80 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -800 -70 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -560 80 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 650 -100 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all i(i0)
.control
  tran 0.1u 1m
  set filetype = ascii
  write tb_ldo_TRAN_load_03.raw v(vldo)
  set appendwrite
.endc
"}
C {code_shown.sym} 660 -220 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 380 -190 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {lab_pin.sym} 220 80 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 20 -130 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 220 -40 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -800 -120 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -800 -20 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} 20 -40 0 0 {name=x1}
C {lab_pin.sym} 70 90 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -170 -60 0 0 {name=p6 sig_type=std_logic lab=VREF}
C {isource.sym} 220 30 0 0 {name=I0 value="PULSE(2u 0 5u 1u 1u 5m 10m)"}
