v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -150 -80 -80 -80 {lab=#net1}
N -340 -350 -340 -330 {lab=VI1}
N -340 -220 -340 -210 {lab=VDD}
N -270 -220 -270 -210 {lab=VSS}
N -340 -270 -340 -250 {lab=GND}
N -270 -150 -270 -130 {lab=GND}
N -340 -150 -340 -130 {lab=GND}
N -40 -320 -40 -290 {lab=VDD}
N -40 -50 -40 -30 {lab=VSS}
N 110 -100 110 -80 {lab=VSS}
N 110 -160 150 -160 {lab=VO1}
N -260 -80 -210 -80 {lab=VI1}
N -40 -80 0 -80 {lab=VSS}
N 0 -80 0 -40 {lab=VSS}
N -40 -40 0 -40 {lab=VSS}
N -40 -160 110 -160 {lab=VO1}
N -40 -160 -40 -110 {lab=VO1}
N -40 -230 -40 -160 {lab=VO1}
N 0 -180 0 -160 {lab=VO1}
N -210 -370 -210 -350 {lab=VI2}
N -210 -290 -210 -270 {lab=GND}
N -130 270 -90 270 {lab=VI2}
N -30 270 20 270 {lab=#net2}
N 60 300 60 330 {lab=VSS}
N 60 140 60 240 {lab=#net3}
N 60 270 120 270 {lab=VSS}
N 120 270 120 310 {lab=VSS}
N 60 310 120 310 {lab=VSS}
N 230 110 230 150 {lab=VO2}
N 230 140 400 140 {lab=VO2}
N 230 210 230 240 {lab=VSS}
N 400 200 400 230 {lab=VSS}
N 60 180 190 180 {lab=#net3}
N 230 10 230 50 {lab=VDD}
N 60 40 60 80 {lab=VDD}
N 230 180 320 180 {lab=VDD}
N 400 140 480 140 {lab=VO2}
C {sg13_lv_nmos.sym} -60 -80 2 1 {name=M1
l=0.13u
w=8u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {res.sym} -180 -80 3 0 {name=R1
value=50
footprint=1206
device=resistor
m=1}
C {capa.sym} 110 -130 0 0 {name=C1
m=1
value=100p
footprint=1206
device="ceramic capacitor"}
C {res.sym} -40 -260 0 0 {name=R2
value=1.2k
footprint=1206
device=resistor
m=1}
C {vsource.sym} -340 -180 0 0 {name=V1 value=1.5 savecurrent=false}
C {vsource.sym} -270 -180 0 0 {name=V2 value=0 savecurrent=false}
C {vsource.sym} -340 -300 0 0 {name=V3 value="dc 0.75 ac 1" savecurrent=false}
C {lab_pin.sym} -340 -350 0 0 {name=VI1 sig_type=std_logic lab=VI1}
C {lab_pin.sym} -340 -220 0 0 {name=VDD sig_type=std_logic lab=VDD}
C {lab_pin.sym} -270 -220 0 0 {name=VSS sig_type=std_logic lab=VSS}
C {gnd.sym} -270 -130 0 0 {name=l1 lab=GND}
C {gnd.sym} -340 -130 0 0 {name=l2 lab=GND}
C {gnd.sym} -340 -250 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -40 -320 0 0 {name=VDD1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -40 -30 0 0 {name=VSS1 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 110 -80 0 0 {name=VSS2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 150 -160 0 1 {name=VO1 sig_type=std_logic lab=VO1}
C {code.sym} 80 -390 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
"}
C {code.sym} 270 -390 0 0 {name=NGSPICE
only_toplevel=true
value="
.param temp=27
.save all 
+ @n.xm1.nsg13_lv_nmos[ids] @n.xm1.nsg13_lv_nmos[gm]
+ @n.xm2.nsg13_lv_nmos[ids] @n.xm2.nsg13_lv_nmos[gm]
+ @n.xm3.nsg13_lv_nmos[ids] @n.xm3.nsg13_lv_nmos[gm]

.control
  op
  set filetype = ascii
  write tb_nmos_amp.raw
.endc
.control
  ac dec 80 10k 10g
  set filetype = ascii
  set units=degrees
  write tb_nmos_amp.raw vdb(vo1) vp(vo1) vdb(vo2) vp(vo2)
  set appendwrite
  op
  set filetype = ascii
  write tb_nmos_amp.raw
.endc
"}
C {launcher.sym} 320 -60 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {ngspice_get_value.sym} -30 -120 0 0 {name=r3 node=i(@n.xm1.nsg13_lv_nmos[ids])
descr="i(m1[id])"}
C {ngspice_probe.sym} -120 -80 0 0 {name=r5}
C {lab_pin.sym} -260 -80 0 0 {name=VI2 sig_type=std_logic lab=VI1}
C {ngspice_probe.sym} 0 -180 0 0 {name=r4}
C {ngspice_get_value.sym} -50 -120 0 1 {name=r6 node=@n.xm1.nsg13_lv_nmos[gm]
descr="m1[gm]"}
C {res.sym} -60 270 3 0 {name=R7
value=50
footprint=1206
device=resistor
m=1}
C {vsource.sym} -210 -320 0 0 {name=V4 value="dc 0.75 ac 1" savecurrent=false}
C {lab_pin.sym} -210 -370 0 0 {name=VI3 sig_type=std_logic lab=VI2}
C {gnd.sym} -210 -270 0 0 {name=l4 lab=GND}
C {lab_pin.sym} -130 270 0 0 {name=VI4 sig_type=std_logic lab=VI2}
C {sg13_lv_nmos.sym} 40 270 2 1 {name=M2
l=0.13u
w=8u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {res.sym} 60 110 0 0 {name=R10
value=1.2k
footprint=1206
device=resistor
m=1}
C {res.sym} 230 80 0 0 {name=R11
value=2k
footprint=1206
device=resistor
m=1}
C {sg13_lv_pmos.sym} 210 180 0 0 {name=M3
l=0.13u
w=8u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} 400 170 0 0 {name=C2
m=1
value=100p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 60 330 0 0 {name=VSS3 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 230 240 0 0 {name=VSS4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 400 230 0 0 {name=VSS5 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} 50 230 0 1 {name=r12 node=@n.xm2.nsg13_lv_nmos[gm]
descr="m2[gm]"}
C {ngspice_get_value.sym} 70 230 0 0 {name=r13 node=i(@n.xm2.nsg13_lv_nmos[ids])
descr="i(m2[id])"}
C {lab_pin.sym} 60 40 0 0 {name=VDD2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 230 10 0 0 {name=VDD3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 320 180 0 1 {name=VDD4 sig_type=std_logic lab=VDD}
C {ngspice_probe.sym} 90 180 0 0 {name=r14}
C {ngspice_probe.sym} -10 270 0 0 {name=r15}
C {lab_pin.sym} 480 140 0 1 {name=VO2 sig_type=std_logic lab=VO2}
C {ngspice_get_value.sym} 210 140 0 1 {name=r16 node=i(@n.xm3.nsg13_lv_nmos[ids])
descr="i(m3[id])"}
