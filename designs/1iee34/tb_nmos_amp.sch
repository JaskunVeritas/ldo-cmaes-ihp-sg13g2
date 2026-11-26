v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 70 100 140 100 {lab=#net1}
N -120 -170 -120 -150 {lab=VI1}
N -120 -40 -120 -30 {lab=VDD}
N -50 -40 -50 -30 {lab=VSS}
N -120 -90 -120 -70 {lab=GND}
N -50 30 -50 50 {lab=GND}
N -120 30 -120 50 {lab=GND}
N 180 -140 180 -110 {lab=VDD}
N 180 130 180 150 {lab=VSS}
N 330 80 330 100 {lab=VSS}
N 330 20 370 20 {lab=VO1}
N -40 100 10 100 {lab=VI1}
N 180 100 220 100 {lab=VSS}
N 220 100 220 140 {lab=VSS}
N 180 140 220 140 {lab=VSS}
N 180 20 330 20 {lab=VO1}
N 180 20 180 70 {lab=VO1}
N 180 -50 180 20 {lab=VO1}
N 220 0 220 20 {lab=VO1}
N 10 -190 10 -170 {lab=VI2}
N 10 -110 10 -90 {lab=GND}
N 90 450 130 450 {lab=VI2}
N 190 450 240 450 {lab=#net2}
N 280 480 280 510 {lab=VSS}
N 280 320 280 420 {lab=#net3}
N 280 450 340 450 {lab=VSS}
N 340 450 340 490 {lab=VSS}
N 280 490 340 490 {lab=VSS}
N 450 290 450 330 {lab=VO2}
N 450 320 620 320 {lab=VO2}
N 450 390 450 420 {lab=VSS}
N 620 380 620 410 {lab=VSS}
N 280 360 410 360 {lab=#net3}
N 450 190 450 230 {lab=VDD}
N 280 220 280 260 {lab=VDD}
N 450 360 540 360 {lab=VDD}
N 620 320 700 320 {lab=VO2}
C {sg13_lv_nmos.sym} 160 100 2 1 {name=M1
l=0.13u
w=8u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {res.sym} 40 100 3 0 {name=R1
value=50
footprint=1206
device=resistor
m=1}
C {capa.sym} 330 50 0 0 {name=C1
m=1
value=100p
footprint=1206
device="ceramic capacitor"}
C {res.sym} 180 -80 0 0 {name=R2
value=1.2k
footprint=1206
device=resistor
m=1}
C {vsource.sym} -120 0 0 0 {name=V1 value=1.5 savecurrent=false}
C {vsource.sym} -50 0 0 0 {name=V2 value=0 savecurrent=false}
C {vsource.sym} -120 -120 0 0 {name=V3 value="dc 0.75 ac 1" savecurrent=false}
C {lab_pin.sym} -120 -170 0 0 {name=VI1 sig_type=std_logic lab=VI1}
C {lab_pin.sym} -120 -40 0 0 {name=VDD sig_type=std_logic lab=VDD}
C {lab_pin.sym} -50 -40 0 0 {name=VSS sig_type=std_logic lab=VSS}
C {gnd.sym} -50 50 0 0 {name=l1 lab=GND}
C {gnd.sym} -120 50 0 0 {name=l2 lab=GND}
C {gnd.sym} -120 -70 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 180 -140 0 0 {name=VDD1 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 180 150 0 0 {name=VSS1 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 330 100 0 0 {name=VSS2 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 370 20 0 1 {name=VO1 sig_type=std_logic lab=VO1}
C {code.sym} 300 -210 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
"}
C {code.sym} 490 -210 0 0 {name=NGSPICE
only_toplevel=true
value="
.param temp=27
.save all 
+ @n.xm1.nsg13_lv_nmos[ids] @n.xm1.nsg13_lv_nmos[gm]
+ @n.xm2.nsg13_lv_nmos[ids] @n.xm2.nsg13_lv_nmos[gm]
+ @n.xm3.nsg13_lv_pmos[ids] @n.xm3.nsg13_lv_pmos[gm]

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
C {launcher.sym} 540 140 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {ngspice_get_value.sym} 190 60 0 0 {name=r3 node=i(@n.xm1.nsg13_lv_nmos[ids])
descr="i(m1[id])"}
C {ngspice_probe.sym} 100 100 0 0 {name=r5}
C {lab_pin.sym} -40 100 0 0 {name=VI2 sig_type=std_logic lab=VI1}
C {ngspice_probe.sym} 220 0 0 0 {name=r4}
C {ngspice_get_value.sym} 170 60 0 1 {name=r6 node=@n.xm1.nsg13_lv_nmos[gm]
descr="m1[gm]"}
C {res.sym} 160 450 3 0 {name=R7
value=50
footprint=1206
device=resistor
m=1}
C {vsource.sym} 10 -140 0 0 {name=V4 value="dc 0.75 ac 1" savecurrent=false}
C {lab_pin.sym} 10 -190 0 0 {name=VI3 sig_type=std_logic lab=VI2}
C {gnd.sym} 10 -90 0 0 {name=l4 lab=GND}
C {lab_pin.sym} 90 450 0 0 {name=VI4 sig_type=std_logic lab=VI2}
C {sg13_lv_nmos.sym} 260 450 2 1 {name=M2
l=0.13u
w=8.3u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {res.sym} 280 290 0 0 {name=R10
value=1.2k
footprint=1206
device=resistor
m=1}
C {res.sym} 450 260 0 0 {name=R11
value=2k
footprint=1206
device=resistor
m=1}
C {sg13_lv_pmos.sym} 430 360 0 0 {name=M3
l=0.13u
w=14u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} 620 350 0 0 {name=C2
m=1
value=100p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 280 510 0 0 {name=VSS3 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 450 420 0 0 {name=VSS4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 620 410 0 0 {name=VSS5 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} 270 410 0 1 {name=r12 node=@n.xm2.nsg13_lv_nmos[gm]
descr="m2[gm]"}
C {ngspice_get_value.sym} 290 410 0 0 {name=r13 node=i(@n.xm2.nsg13_lv_nmos[ids])
descr="i(m2[id])"}
C {lab_pin.sym} 280 220 0 0 {name=VDD2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 450 190 0 0 {name=VDD3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 540 360 0 1 {name=VDD4 sig_type=std_logic lab=VDD}
C {ngspice_probe.sym} 310 360 0 0 {name=r14}
C {ngspice_probe.sym} 210 450 0 0 {name=r15}
C {lab_pin.sym} 700 320 0 1 {name=VO2 sig_type=std_logic lab=VO2}
C {ngspice_get_value.sym} 430 320 0 1 {name=r16 node=i(@n.xm3.nsg13_lv_pmos[ids])
descr="i(m3[id])"}
