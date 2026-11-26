v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -360 110 -360 150 {lab=VDD}
N -280 110 -280 150 {lab=VSS}
N -360 -90 -360 -50 {lab=VREF}
N 260 80 260 120 {lab=VSS}
N 260 -20 260 20 {lab=VLDO}
N -360 10 -360 50 {lab=VSS}
N 210 -20 260 -20 {lab=VLDO}
N 110 40 110 120 {lab=VSS}
N 10 40 10 80 {lab=#net1}
N -120 0 -120 80 {lab=#net2}
N -120 0 -90 0 {lab=#net2}
N -130 -40 -90 -40 {lab=VREF}
N 60 -130 60 -80 {lab=VDD}
N -200 80 -200 200 {lab=#net2}
N -200 80 -120 80 {lab=#net2}
N 100 160 100 200 {lab=#net1}
N 10 160 100 160 {lab=#net1}
N 10 80 10 160 {lab=#net1}
C {vsource.sym} -360 180 0 0 {name=V1 value="dc 1.5 " savecurrent=false}
C {gnd.sym} -360 210 0 0 {name=l1 lab=GND}
C {vsource.sym} -280 180 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -280 210 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -360 130 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -360 -20 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -280 130 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 320 -200 0 0 {name=NGSPICE
only_toplevel=true
value="
.param temp=27
.options savecurrents

.ac dec 80 1 10g
.save all v(X999.x) i(v.X999.Vi)

.control

  run
  alter i.X999.Ii acmag=1
  alter v.X999.Vi acmag=0
  run

  let A=ac2.i(v.X999.Vi)
  let B=ac1.i(v.X999.Vi)
  let C=ac2.v(X999.x)
  let D=ac1.v(X999.x)
  let Ttian=(2*(B*C-A*D)+D+A)/(2*(B*C-A*D)+A+D-1)

  set filetype=ascii
  write tb_ldo_PM_03.raw db(Ttian) 180*cph(Ttian)/pi

  set appendwrite
  op
  set filetype=ascii
  write tb_ldo_01_op_stb.raw
.endc
"}
C {code_shown.sym} 330 -310 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} -90 -180 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 260 50 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 260 100 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 60 -110 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 260 -20 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -360 -70 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -360 30 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} 60 -20 0 0 {name=x1}
C {lab_pin.sym} 110 110 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -130 -40 0 0 {name=p6 sig_type=std_logic lab=VREF}
C {loopgainprobe.sym} -80 200 0 0 {name=X999
}
C {ngspice_get_value.sym} 360 550 0 0 {name=r6 node=i(@n.x1.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} 80 560 0 0 {name=r7 node=i(@n.x1.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} -290 540 0 0 {name=r15 node=i(@n.x1.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ngspice_get_value.sym} 180 670 0 0 {name=r1 node=i(x1.r1)
descr="i(r1)"}
C {ngspice_get_value.sym} 290 520 0 1 {name=r14 node=@n.x1.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
