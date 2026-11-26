v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 490 160 490 180 {lab=VLDO}
N 490 160 670 160 {lab=VLDO}
N 490 140 490 160 {lab=VLDO}
N 490 260 490 280 {lab=VA}
N 490 340 490 380 {lab=VSS}
N 490 10 490 110 {lab=VDD}
N 370 110 450 110 {lab=#net1}
N 150 260 490 260 {lab=VA}
N 490 240 490 260 {lab=VA}
N -220 40 -200 40 {lab=VREF+}
N -160 70 -160 100 {lab=#net2}
N 40 70 40 100 {lab=#net2}
N -60 100 40 100 {lab=#net2}
N -160 -40 -160 10 {lab=#net3}
N 40 -140 40 -90 {lab=VDD}
N -160 -140 -160 -90 {lab=VDD}
N -160 -140 40 -140 {lab=VDD}
N -100 -90 0 -90 {lab=#net3}
N -160 -40 -100 -40 {lab=#net3}
N -160 -60 -160 -40 {lab=#net3}
N -100 -90 -100 -40 {lab=#net3}
N -120 -90 -100 -90 {lab=#net3}
N 40 -20 40 10 {lab=#net4}
N -60 100 -60 140 {lab=#net2}
N -160 100 -60 100 {lab=#net2}
N -60 170 -60 220 {lab=VSS}
N -320 170 -320 220 {lab=VSS}
N -260 170 -100 170 {lab=VG}
N -320 120 -320 140 {lab=VG}
N -320 -140 -160 -140 {lab=VDD}
N -320 120 -260 120 {lab=VG}
N -260 120 -260 170 {lab=VG}
N -280 170 -260 170 {lab=VG}
N -160 40 40 40 {lab=VSS}
N -320 220 -60 220 {lab=VSS}
N 40 -60 40 -20 {lab=#net4}
N 40 -20 100 -20 {lab=#net4}
N -60 220 220 220 {lab=VSS}
N 220 200 220 210 {lab=VSS}
N 220 210 220 220 {lab=VSS}
N 140 170 180 170 {lab=VG}
N 100 -20 190 -20 {lab=#net4}
N 220 10 220 140 {lab=#net1}
N 320 -140 320 -30 {lab=VDD}
N 40 -140 320 -140 {lab=VDD}
N 220 -20 320 -20 {lab=VDD}
N 320 -30 320 -20 {lab=VDD}
N 220 50 310 50 {lab=#net1}
N 220 -140 220 -50 {lab=VDD}
N 220 170 220 200 {lab=VSS}
N 40 10 110 10 {lab=#net4}
N 200 10 200 50 {lab=#net1}
N 200 50 220 50 {lab=#net1}
N 110 10 130 10 {lab=#net4}
N 190 10 200 10 {lab=#net1}
N 80 40 90 40 {lab=VREF-}
N 310 50 370 50 {lab=#net1}
N 370 50 370 110 {lab=#net1}
N 350 50 350 100 {lab=#net1}
N 350 160 380 160 {lab=#net6}
N 440 160 490 160 {lab=VLDO}
N 580 160 580 190 {lab=VLDO}
N 580 250 580 280 {lab=VSS}
N -320 -140 -320 -110 {lab=VDD}
N -320 -50 -320 10 {lab=#net5}
N -320 -100 -320 -80 {lab=VDD}
N -320 70 -320 120 {lab=VG}
N -420 40 -360 40 {lab=VDD}
N -420 -140 -420 40 {lab=VDD}
N -420 -140 -320 -140 {lab=VDD}
N -320 40 -290 40 {lab=VSS}
N -290 40 -290 90 {lab=VSS}
N -320 -110 -320 -100 {lab=VDD}
N -360 -80 -360 -60 {lab=#net5}
N -360 -60 -360 -30 {lab=#net5}
N -360 -30 -320 -30 {lab=#net5}
C {iopin.sym} -220 40 0 1 {name=p2 lab=VREF+}
C {iopin.sym} 670 160 0 0 {name=p4 lab=VLDO}
C {iopin.sym} 320 -140 0 0 {name=p1 lab=VDD}
C {iopin.sym} 90 40 0 0 {name=p3 lab=VREF-}
C {iopin.sym} 220 200 0 0 {name=p5 lab=VSS}
C {iopin.sym} 150 260 0 1 {name=p8 lab=VRET}
C {lab_pin.sym} -270 120 3 1 {name=p9 sig_type=std_logic lab=VG}
C {lab_pin.sym} 580 260 0 1 {name=p6 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 490 360 0 1 {name=p7 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 150 170 3 1 {name=p10 sig_type=std_logic lab=VG}
C {lab_pin.sym} 490 30 0 1 {name=p11 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -70 40 0 1 {name=p12 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -290 70 0 1 {name=p13 sig_type=std_logic lab=VSS}
C {capa.sym} 580 220 0 0 {name=C1
m=1
value=1000.0n
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 160 10 3 1 {name=CC
m=1
value=3.666349378452877e-05n
footprint=1206
device="ceramic capacitor"}
C {res.sym} 490 210 0 0 {name=R1
value=21.49k
footprint=1206
device=resistor
m=1}
C {res.sym} 490 310 0 0 {name=R2
value=21.49k
footprint=1206
device=resistor
m=1}
C {capa.sym} 410 160 1 0 {name=C3
m=1
value=5n
footprint=1206
device="ceramic capacitor"}
C {res.sym} 350 130 0 0 {name=R3
value=30k
footprint=1206
device=resistor
m=1}
C {sg13_lv_pmos.sym} 470 110 0 0 {name=MG
l=0.13u
w=250.0u
ng=13
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -140 -90 0 1 {name=M3
l=32.58u
w=14.74u
ng=2
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} 20 -90 0 0 {name=M4
l=32.58u
w=14.74u
ng=2
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} 200 -20 0 0 {name=M6
l=1.5u
w=3.58u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -180 40 2 1 {name=M1
l=8.55u
w=176.34u
ng=18
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} 60 40 2 0 {name=M2
l=8.55u
w=176.34u
ng=18
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -80 170 2 1 {name=M5
l=2.0u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} 200 170 2 1 {name=M7
l=2.0u
w=4.4u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -300 170 2 0 {name=M8
l=2.0u
w=2.75u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -340 -80 0 0 {name=M10
l=8u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -340 40 2 1 {name=M11
l=8u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
