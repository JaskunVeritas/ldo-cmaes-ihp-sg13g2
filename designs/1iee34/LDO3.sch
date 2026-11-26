v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 420 140 420 160 {lab=VLDO}
N 420 140 600 140 {lab=VLDO}
N 420 120 420 140 {lab=VLDO}
N 420 240 420 260 {lab=VRET}
N 420 320 420 360 {lab=VSS}
N 420 -10 420 90 {lab=VDD}
N 300 90 380 90 {lab=#net1}
N 80 240 420 240 {lab=VRET}
N 420 220 420 240 {lab=VRET}
N -290 20 -270 20 {lab=VREF+}
N -230 50 -230 80 {lab=#net2}
N -30 50 -30 80 {lab=#net2}
N -130 80 -30 80 {lab=#net2}
N -230 -60 -230 -10 {lab=#net3}
N -30 -160 -30 -110 {lab=VDD}
N -230 -160 -230 -110 {lab=VDD}
N -230 -160 -30 -160 {lab=VDD}
N -170 -110 -70 -110 {lab=#net3}
N -230 -60 -170 -60 {lab=#net3}
N -230 -80 -230 -60 {lab=#net3}
N -170 -110 -170 -60 {lab=#net3}
N -190 -110 -170 -110 {lab=#net3}
N -30 -40 -30 -10 {lab=#net4}
N -130 80 -130 120 {lab=#net2}
N -230 80 -130 80 {lab=#net2}
N -130 150 -130 200 {lab=VSS}
N -390 150 -390 200 {lab=VSS}
N -330 150 -170 150 {lab=Vbias}
N -390 100 -390 120 {lab=Vbias}
N -390 -160 -230 -160 {lab=VDD}
N -390 100 -330 100 {lab=Vbias}
N -330 100 -330 150 {lab=Vbias}
N -350 150 -330 150 {lab=Vbias}
N -230 20 -30 20 {lab=VSS}
N -390 200 -130 200 {lab=VSS}
N -30 -80 -30 -40 {lab=#net4}
N -30 -40 30 -40 {lab=#net4}
N -130 200 150 200 {lab=VSS}
N 150 180 150 190 {lab=VSS}
N 150 190 150 200 {lab=VSS}
N 70 150 110 150 {lab=Vbias}
N 30 -40 120 -40 {lab=#net4}
N 150 -10 150 120 {lab=#net1}
N 250 -160 250 -50 {lab=VDD}
N -30 -160 250 -160 {lab=VDD}
N 150 -40 250 -40 {lab=VDD}
N 250 -50 250 -40 {lab=VDD}
N 150 30 240 30 {lab=#net1}
N 150 -160 150 -70 {lab=VDD}
N 150 150 150 180 {lab=VSS}
N 130 -10 130 30 {lab=#net1}
N 130 30 150 30 {lab=#net1}
N 120 -10 130 -10 {lab=#net1}
N 10 20 20 20 {lab=VREF-}
N 240 30 300 30 {lab=#net1}
N 300 30 300 90 {lab=#net1}
N 510 140 510 170 {lab=VLDO}
N 510 230 510 260 {lab=VSS}
N -390 -160 -390 -130 {lab=VDD}
N -390 -70 -390 -10 {lab=#net5}
N -390 -120 -390 -100 {lab=VDD}
N -390 50 -390 100 {lab=Vbias}
N -490 20 -430 20 {lab=VDD}
N -490 -160 -490 20 {lab=VDD}
N -490 -160 -390 -160 {lab=VDD}
N -390 20 -360 20 {lab=VSS}
N -360 20 -360 70 {lab=VSS}
N -390 -130 -390 -120 {lab=VDD}
N -430 -100 -430 -80 {lab=#net5}
N -430 -80 -430 -50 {lab=#net5}
N -430 -50 -390 -50 {lab=#net5}
N -30 -10 -20 -10 {lab=#net4}
N 40 -10 60 -10 {lab=#net4}
N -20 -10 40 -10 {lab=#net4}
N 370 140 420 140 {lab=VLDO}
N 280 140 310 140 {lab=#net6}
N 280 30 280 80 {lab=#net1}
C {ngspice_probe.sym} 340 90 0 0 {name=r5}
C {ngspice_get_value.sym} 430 50 0 0 {name=r10 node=i(@n.xmG.nsg13_lv_pmos[ids])
descr="i(mg[id])"}
C {ngspice_get_value.sym} 410 50 0 1 {name=r11 node=@n.xmg.nsg13_lv_pmos[gm]
descr="mg[gm]"}
C {ngspice_get_value.sym} 490 50 0 0 {name=r12 node=@n.xmG.nsg13_lv_pmos[gds]
descr="mg[gds]"}
C {sg13_lv_pmos.sym} 400 90 0 0 {name=MG
l=0.13u
w=250u
ng=50

m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {res.sym} 420 290 0 0 {name=R2
value=30k
footprint=1206
device=resistor
m=1}
C {res.sym} 420 190 0 0 {name=R1
value=30k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 420 340 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 420 -10 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {ngspice_probe.sym} 320 240 0 0 {name=r4}
C {sg13_lv_nmos.sym} -250 20 2 1 {name=M1
l=10u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -10 20 2 0 {name=M2
l=10u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -210 -110 0 1 {name=M3
l=26u
w=13u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -50 -110 0 0 {name=M4
l=26u
w=13u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -150 150 2 1 {name=M5
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -370 150 2 0 {name=M8
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -130 20 3 1 {name=p16 sig_type=std_logic lab=VSS}
C {sg13_lv_nmos.sym} 130 150 2 1 {name=M7
l=2u
w=4.4u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -330 110 0 0 {name=p17 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} 70 150 0 0 {name=p18 sig_type=std_logic lab=Vbias}
C {sg13_lv_pmos.sym} 130 -40 0 0 {name=M6
l=1.5u
w=3.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} 90 -10 1 0 {name=C1
m=1
value=0.02p


footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 250 -160 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 150 200 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} 150 110 0 0 {name=r6 node=i(@n.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} -130 120 0 0 {name=r7 node=i(@n.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} 210 110 0 0 {name=r8 node=@n.xm7.nsg13_lv_nmos[gds]
descr="m7[gds]"}
C {ngspice_get_value.sym} -60 120 0 0 {name=r9 node=@n.xm5.nsg13_lv_nmos[gds]
descr="m1[gds]"}
C {ngspice_get_value.sym} 170 -90 0 0 {name=r13 node=@n.xm6.nsg13_lv_pmos[gds]
descr="m6[gds]"}
C {ngspice_get_value.sym} 130 -100 0 1 {name=r14 node=@n.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
C {capa.sym} 510 200 0 0 {name=C2
m=1
value=1u
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 510 250 0 1 {name=p14 sig_type=std_logic lab=VSS}
C {sg13_lv_pmos.sym} -410 -100 0 0 {name=M10
l=8u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -410 20 2 1 {name=M11
l=8u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -360 70 0 1 {name=p15 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} -490 100 0 0 {name=r15 node=i(@n.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ipin.sym} -290 20 0 0 {name=p1 lab=VREF+}
C {ipin.sym} 20 20 0 1 {name=p3 lab=VREF-}
C {opin.sym} 600 140 0 0 {name=p5 lab=VLDO}
C {iopin.sym} 420 360 0 0 {name=p7 lab=VSS}
C {iopin.sym} 250 -130 0 0 {name=p2 lab=VDD}
C {opin.sym} 80 240 0 1 {name=p6 lab=VRET}
C {capa.sym} 340 140 1 0 {name=C3
m=1
value=5n


footprint=1206
device="ceramic capacitor"}
C {res.sym} 280 110 0 0 {name=R3
value=30k
footprint=1206
device=resistor
m=1}
