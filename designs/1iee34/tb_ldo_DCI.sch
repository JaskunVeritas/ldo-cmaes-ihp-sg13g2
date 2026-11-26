v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -880 -120 -880 -80 {lab=VDD}
N -800 -120 -800 -80 {lab=VSS}
N -880 -320 -880 -280 {lab=VREF}
N 140 -120 140 -80 {lab=VSS}
N 140 -220 140 -180 {lab=VLDO}
N -880 -220 -880 -180 {lab=VSS}
N 90 -220 140 -220 {lab=VLDO}
N -10 -160 -10 -80 {lab=VSS}
N -110 -160 -110 -120 {lab=#net1}
N -240 -120 -110 -120 {lab=#net1}
N -240 -200 -240 -120 {lab=#net1}
N -240 -200 -210 -200 {lab=#net1}
N -250 -240 -210 -240 {lab=VREF}
N -60 -330 -60 -280 {lab=VDD}
C {vsource.sym} -880 -50 0 0 {name=V1 value="dc 1.5 ac 0" savecurrent=false}
C {gnd.sym} -880 -20 0 0 {name=l3 lab=GND}
C {vsource.sym} -800 -50 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -800 -20 0 0 {name=l4 lab=GND}
C {lab_pin.sym} -880 -100 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {vsource.sym} -880 -250 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -800 -100 0 1 {name=p6 sig_type=std_logic lab=VSS}
C {code_shown.sym} 570 -290 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all

.control
  set filetype=ascii
  set units=degress
  dc i0 1m 5m 0.5u
 
  write tb_ldo_DCI_03.raw v(vldo)
  set appendwrite
.endc
"}
C {code_shown.sym} 580 -400 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 300 -370 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {lab_pin.sym} 140 -100 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -60 -310 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 140 -220 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -880 -300 0 1 {name=p7 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -880 -200 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {LDO1.sym} -60 -220 0 0 {name=x1}
C {lab_pin.sym} -10 -90 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -250 -240 0 0 {name=p13 sig_type=std_logic lab=VREF}
C {isource.sym} 140 -150 0 0 {name=I0 value=5m}
