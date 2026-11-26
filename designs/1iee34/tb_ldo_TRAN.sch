v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -880 60 -880 100 {lab=VDD}
N -640 60 -640 100 {lab=VSS}
N -880 -140 -880 -100 {lab=VREF}
N 140 60 140 100 {lab=VSS}
N 140 -40 140 0 {lab=VLDO}
N -880 -40 -880 0 {lab=VSS}
N 90 -40 140 -40 {lab=VLDO}
N -10 20 -10 100 {lab=VSS}
N -110 20 -110 60 {lab=#net1}
N -240 60 -110 60 {lab=#net1}
N -240 -20 -240 60 {lab=#net1}
N -240 -20 -210 -20 {lab=#net1}
N -250 -60 -210 -60 {lab=VREF}
N -60 -150 -60 -100 {lab=VDD}
C {vsource.sym} -880 130 0 0 {name=V1 value="PULSE(0 1.5 10u 1u 1u 5m 10m)" savecurrent=false}
C {gnd.sym} -880 160 0 0 {name=l1 lab=GND}
C {vsource.sym} -640 130 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -640 160 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -880 80 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -880 -70 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -640 80 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 570 -110 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
.control
  tran 0.1u 150u
  set filetype = ascii
  write tb_ldo_TRAN_03.raw v(vldo) v(vdd)
  set appendwrite
.endc
"}
C {code_shown.sym} 580 -220 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 300 -190 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 140 30 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 140 80 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -60 -130 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 140 -40 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -880 -120 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -880 -20 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} -60 -40 0 0 {name=x1}
C {lab_pin.sym} -10 90 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -250 -60 0 0 {name=p6 sig_type=std_logic lab=VREF}
