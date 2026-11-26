v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -850 60 -850 100 {lab=VDD}
N -610 60 -610 100 {lab=VSS}
N -850 -140 -850 -100 {lab=VREF}
N 170 60 170 100 {lab=VSS}
N 170 -40 170 0 {lab=VLDO}
N -850 -40 -850 0 {lab=VSS}
N 120 -40 170 -40 {lab=VLDO}
N 20 20 20 100 {lab=VSS}
N -80 20 -80 60 {lab=#net1}
N -210 60 -80 60 {lab=#net1}
N -210 -20 -210 60 {lab=#net1}
N -210 -20 -180 -20 {lab=#net1}
N -220 -60 -180 -60 {lab=VREF}
N -30 -150 -30 -100 {lab=VDD}
C {vsource.sym} -850 130 0 0 {name=V1 value="PULSE(1.5 1.8 50u 1u 1u 5m 10m)" savecurrent=false}
C {gnd.sym} -850 160 0 0 {name=l1 lab=GND}
C {vsource.sym} -610 130 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -610 160 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -850 80 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -850 -70 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -610 80 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 600 -100 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
.control
  tran 0.1u 350u
  set filetype = ascii
  write tb_ldo_TRAN_line_03.raw v(vldo) v(vdd)
  set appendwrite
.endc
"}
C {code_shown.sym} 610 -220 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 330 -190 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {lab_pin.sym} 170 80 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -30 -130 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 170 -40 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -850 -120 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -850 -20 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} -30 -40 0 0 {name=x1}
C {lab_pin.sym} 20 90 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -220 -60 0 0 {name=p6 sig_type=std_logic lab=VREF}
C {isource.sym} 170 30 0 0 {name=I0 value="5u"}
