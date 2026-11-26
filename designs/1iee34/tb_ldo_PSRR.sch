v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -350 10 -350 50 {lab=VDD}
N -270 10 -270 50 {lab=VSS}
N -350 -190 -350 -150 {lab=VREF}
N 240 80 240 120 {lab=VSS}
N 240 -20 240 20 {lab=VLDO}
N -350 -90 -350 -50 {lab=VSS}
N 190 -20 240 -20 {lab=VLDO}
N 90 40 90 120 {lab=VSS}
N -10 40 -10 80 {lab=#net1}
N -140 80 -10 80 {lab=#net1}
N -140 -0 -140 80 {lab=#net1}
N -140 -0 -110 0 {lab=#net1}
N -150 -40 -110 -40 {lab=VREF}
N 40 -130 40 -80 {lab=VDD}
C {vsource.sym} -350 80 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -350 110 0 0 {name=l1 lab=GND}
C {vsource.sym} -270 80 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -270 110 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -350 30 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -350 -120 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -270 30 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 320 -300 0 0 {name=NGSPICE only_toplevel=false value="
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
  op
  write tb_ldo_PSRR_OP_03.raw v(vdd) v1#branch @r3[i]
  ac dec 160 10 1g
  set units=degress
  let PSRR = 1/VLDO
  write tb_ldo_PSRR_03.raw vdb(PSRR) vp(PSRR)
  set appendwrite
.endc
"}
C {code_shown.sym} -350 -290 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} -20 -200 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 240 50 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 240 100 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 40 -110 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 240 -20 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -350 -170 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -350 -70 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} 40 -20 0 0 {name=x1}
C {lab_pin.sym} 90 110 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -150 -40 0 0 {name=p6 sig_type=std_logic lab=VREF}
C {ngspice_get_value.sym} 330 410 0 0 {name=r6 node=i(@n.x1.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} -40 400 0 0 {name=r7 node=i(@n.x1.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} -250 380 0 0 {name=r15 node=i(@n.x1.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ngspice_get_value.sym} 220 380 0 0 {name=r1 node=i(x1.r1)
descr="i(r1)"}
C {ngspice_get_value.sym} -70 250 0 0 {name=r2 node=@n.x1.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
C {ngspice_get_value.sym} 40 250 0 0 {name=r4 node=@n.x1.xm6.nsg13_lv_pmos[gds]
descr="m6[gds]"}
