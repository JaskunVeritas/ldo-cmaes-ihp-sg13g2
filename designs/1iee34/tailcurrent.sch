v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -400 160 -400 200 {lab=VDD}
N -320 160 -320 200 {lab=VSS}
N -80 90 -80 140 {lab=VSS}
N -80 40 -80 60 {lab=Vbias}
N -80 40 -20 40 {lab=Vbias}
N -20 40 -20 90 {lab=Vbias}
N -40 90 -20 90 {lab=Vbias}
N -80 -240 -80 -190 {lab=VDD}
N -150 -160 -120 -160 {lab=#net1}
N -150 -160 -150 -100 {lab=#net1}
N -150 -100 -80 -100 {lab=#net1}
N -80 -130 -80 -100 {lab=#net1}
N -80 0 -80 40 {lab=Vbias}
N -80 -100 -80 -60 {lab=#net1}
N -180 -30 -120 -30 {lab=VDD}
N -180 -200 -180 -30 {lab=VDD}
N -180 -200 -80 -200 {lab=VDD}
N -80 -180 -80 -160 {lab=VDD}
N -80 -190 -80 -180 {lab=VDD}
N -80 -30 -10 -30 {lab=VSS}
C {vsource.sym} -400 230 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -400 260 0 0 {name=l1 lab=GND}
C {vsource.sym} -320 230 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -320 260 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -400 180 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -320 180 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 1050 -10 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
+ @n.xm8.nsg13_lv_nmos[ids]
+ @n.xm8.nsg13_lv_nmos[gm]
+ @n.xm8.nsg13_lv_nmos[gds]
.control
.endc
"}
C {code_shown.sym} 1060 -120 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 240 40 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {sg13_lv_nmos.sym} -60 90 0 1 {name=M8
l=2u
w=50u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -20 50 0 0 {name=p17 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} -80 140 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {sg13_lv_pmos.sym} -100 -160 0 0 {name=M1
l=8u
w=1u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {lab_pin.sym} -80 -220 0 1 {name=p6 sig_type=std_logic lab=VDD}
C {sg13_lv_nmos.sym} -100 -30 0 0 {name=M2
l=8u
w=5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {ngspice_get_value.sym} 110 -30 0 0 {name=r7 node=i(@n.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {lab_pin.sym} -10 -30 0 1 {name=p2 sig_type=std_logic lab=VSS}
