v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 440 160 440 180 {lab=VLDO}
N 440 160 620 160 {lab=VLDO}
N 440 140 440 160 {lab=VLDO}
N 440 260 440 280 {lab=VRET}
N 440 340 440 380 {lab=VSS}
N 440 10 440 110 {lab=VDD}
N 320 110 400 110 {lab=#net1}
N 100 260 440 260 {lab=VRET}
N 440 240 440 260 {lab=VRET}
N -270 40 -250 40 {lab=VREF+}
N -210 70 -210 100 {lab=#net2}
N -10 70 -10 100 {lab=#net2}
N -110 100 -10 100 {lab=#net2}
N -210 -40 -210 10 {lab=#net3}
N -10 -140 -10 -90 {lab=VDD}
N -210 -140 -210 -90 {lab=VDD}
N -210 -140 -10 -140 {lab=VDD}
N -150 -90 -50 -90 {lab=#net3}
N -210 -40 -150 -40 {lab=#net3}
N -210 -60 -210 -40 {lab=#net3}
N -150 -90 -150 -40 {lab=#net3}
N -170 -90 -150 -90 {lab=#net3}
N -10 -20 -10 10 {lab=#net4}
N -110 100 -110 140 {lab=#net2}
N -210 100 -110 100 {lab=#net2}
N -110 170 -110 220 {lab=VSS}
N -370 170 -370 220 {lab=VSS}
N -310 170 -150 170 {lab=Vbias}
N -370 120 -370 140 {lab=Vbias}
N -370 -140 -210 -140 {lab=VDD}
N -370 120 -310 120 {lab=Vbias}
N -310 120 -310 170 {lab=Vbias}
N -330 170 -310 170 {lab=Vbias}
N -210 40 -10 40 {lab=VSS}
N -370 220 -110 220 {lab=VSS}
N -10 -60 -10 -20 {lab=#net4}
N -10 -20 50 -20 {lab=#net4}
N -110 220 170 220 {lab=VSS}
N 170 200 170 210 {lab=VSS}
N 170 210 170 220 {lab=VSS}
N 90 170 130 170 {lab=Vbias}
N 50 -20 140 -20 {lab=#net4}
N 170 10 170 140 {lab=#net1}
N 270 -140 270 -30 {lab=VDD}
N -10 -140 270 -140 {lab=VDD}
N 170 -20 270 -20 {lab=VDD}
N 270 -30 270 -20 {lab=VDD}
N 170 50 260 50 {lab=#net1}
N 170 -140 170 -50 {lab=VDD}
N 170 170 170 200 {lab=VSS}
N 150 10 150 50 {lab=#net1}
N 150 50 170 50 {lab=#net1}
N 140 10 150 10 {lab=#net1}
N 30 40 40 40 {lab=VREF-}
N 260 50 320 50 {lab=#net1}
N 320 50 320 110 {lab=#net1}
N 530 160 530 190 {lab=VLDO}
N -370 -140 -370 -110 {lab=VDD}
N -370 -50 -370 10 {lab=#net5}
N -370 -100 -370 -80 {lab=VDD}
N -370 70 -370 120 {lab=Vbias}
N -470 40 -410 40 {lab=VDD}
N -470 -140 -470 40 {lab=VDD}
N -470 -140 -370 -140 {lab=VDD}
N -370 40 -340 40 {lab=VSS}
N -340 40 -340 90 {lab=VSS}
N -370 -110 -370 -100 {lab=VDD}
N -410 -80 -410 -60 {lab=#net5}
N -410 -60 -410 -30 {lab=#net5}
N -410 -30 -370 -30 {lab=#net5}
N -10 10 0 10 {lab=#net4}
N 60 10 80 10 {lab=#net4}
N 0 10 60 10 {lab=#net4}
N 530 250 530 290 {lab=VSS}
C {ngspice_probe.sym} 360 110 0 0 {name=r5}
C {ngspice_get_value.sym} 450 70 0 0 {name=r10 node=i(@n.xmG.nsg13_lv_pmos[ids])
descr="i(mg[id])"}
C {ngspice_get_value.sym} 430 70 0 1 {name=r11 node=@n.xmg.nsg13_lv_pmos[gm]
descr="mg[gm]"}
C {ngspice_get_value.sym} 510 70 0 0 {name=r12 node=@n.xmG.nsg13_lv_pmos[gds]
descr="mg[gds]"}
C {sg13_lv_pmos.sym} 420 110 0 0 {name=MG
l=0.13u
w=250u
ng=50

m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {res.sym} 440 310 0 0 {name=R2
value=30k
footprint=1206
device=resistor
m=1}
C {res.sym} 440 210 0 0 {name=R1
value=30k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 530 280 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 440 10 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {ngspice_probe.sym} 340 260 0 0 {name=r4}
C {sg13_lv_nmos.sym} -230 40 2 1 {name=M1
l=0.5u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} 10 40 2 0 {name=M2
l=0.5u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -190 -90 0 1 {name=M3
l=6u
w=3u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -30 -90 0 0 {name=M4
l=6u
w=3u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -130 170 2 1 {name=M5
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -350 170 2 0 {name=M8
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -110 40 3 1 {name=p16 sig_type=std_logic lab=VSS}
C {sg13_lv_nmos.sym} 150 170 2 1 {name=M7
l=2u
w=4.4u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -310 130 0 0 {name=p17 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} 90 170 0 0 {name=p18 sig_type=std_logic lab=Vbias}
C {sg13_lv_pmos.sym} 150 -20 0 0 {name=M6
l=0.25u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} 110 10 1 0 {name=C1
m=1
value=0.02p


footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 270 -140 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 170 220 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} 170 130 0 0 {name=r6 node=i(@n.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} -110 140 0 0 {name=r7 node=i(@n.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} 230 130 0 0 {name=r8 node=@n.xm7.nsg13_lv_nmos[gds]
descr="m7[gds]"}
C {ngspice_get_value.sym} -40 140 0 0 {name=r9 node=@n.xm5.nsg13_lv_nmos[gds]
descr="m1[gds]"}
C {ngspice_get_value.sym} 190 -70 0 0 {name=r13 node=@n.xm6.nsg13_lv_pmos[gds]
descr="m6[gds]"}
C {ngspice_get_value.sym} 150 -80 0 1 {name=r14 node=@n.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
C {sg13_lv_pmos.sym} -390 -80 0 0 {name=M10
l=8u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -390 40 2 1 {name=M11
l=8u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -340 90 0 1 {name=p15 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} -470 120 0 0 {name=r15 node=i(@n.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ipin.sym} -270 40 0 0 {name=p1 lab=VREF+}
C {ipin.sym} 40 40 0 1 {name=p3 lab=VREF-}
C {opin.sym} 620 160 0 0 {name=p5 lab=VLDO}
C {iopin.sym} 440 380 0 0 {name=p7 lab=VSS}
C {iopin.sym} 270 -110 0 0 {name=p2 lab=VDD}
C {opin.sym} 100 260 0 1 {name=p6 lab=VRET}
C {capa.sym} 530 220 0 0 {name=C3
m=1
value=5u
footprint=1206
device="ceramic capacitor"}
