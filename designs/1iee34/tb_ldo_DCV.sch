v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -790 40 -790 80 {lab=VDD}
N -710 40 -710 80 {lab=VSS}
N -790 -160 -790 -120 {lab=VREF}
N 230 40 230 80 {lab=VSS}
N 230 -60 230 -20 {lab=VLDO}
N -790 -60 -790 -20 {lab=VSS}
N 180 -60 230 -60 {lab=VLDO}
N 80 0 80 80 {lab=VSS}
N -20 0 -20 40 {lab=#net1}
N -150 40 -20 40 {lab=#net1}
N -150 -40 -150 40 {lab=#net1}
N -150 -40 -120 -40 {lab=#net1}
N -160 -80 -120 -80 {lab=VREF}
N 30 -170 30 -120 {lab=VDD}
C {vsource.sym} -790 110 0 0 {name=V1 value="dc 1.5 ac 0" savecurrent=false}
C {gnd.sym} -790 140 0 0 {name=l1 lab=GND}
C {vsource.sym} -710 110 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -710 140 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -790 60 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -790 -90 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -710 60 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 660 -130 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
+ @n.x1.xmG.nsg13_lv_pmos[ids]
+ @n.x1.xmG.nsg13_lv_pmos[gm]
+ @n.x1.xmG.nsg13_lv_pmos[gds]
+ @n.x1.xm6.nsg13_lv_pmos[gds]
+ @n.x1.xm6.nsg13_lv_pmos[gm]
+ @n.x1.xm5.nsg13_lv_nmos[ids]
+ @n.x1.xm5.nsg13_lv_nmos[gm]
+ @n.x1.xm5.nsg13_lv_nmos[gds]
+ @n.x1.xm8.nsg13_lv_nmos[ids]
+ @n.x1.xm7.nsg13_lv_nmos[ids]
+ @n.x1.xm7.nsg13_lv_nmos[gm]
+ @n.x1.xm7.nsg13_lv_nmos[gds]
+ i(x1.r1)
+ i(x1.r2)

.control
  set filetype=ascii
  set units=degress
  dc v1 1.5 1.8 0.01
 
  write tb_ldo_DCV_03.raw v(vldo)
  set appendwrite
.endc
"}
C {code_shown.sym} 670 -240 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 390 -210 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 230 10 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 230 60 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 30 -150 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 230 -60 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -790 -140 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -790 -40 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} 30 -60 0 0 {name=x1}
C {lab_pin.sym} 80 70 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -160 -80 0 0 {name=p6 sig_type=std_logic lab=VREF}
C {ngspice_get_value.sym} 390 220 0 0 {name=r6 node=i(@n.x1.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} 110 230 0 0 {name=r7 node=i(@n.x1.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} -260 210 0 0 {name=r15 node=i(@n.x1.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ngspice_get_value.sym} 210 340 0 0 {name=r1 node=i(x1.r1)
descr="i(r1)"}
