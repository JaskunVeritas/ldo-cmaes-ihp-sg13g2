v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -370 -290 -370 -270 {lab=VLDO}
N -370 -290 -190 -290 {lab=VLDO}
N -370 -310 -370 -290 {lab=VLDO}
N -370 -190 -370 -170 {lab=VRET}
N -370 -110 -370 -70 {lab=VSS}
N -370 -440 -370 -340 {lab=VDD}
N -490 -340 -410 -340 {lab=#net1}
N -710 -190 -370 -190 {lab=VRET}
N -370 -210 -370 -190 {lab=VRET}
N -1080 -410 -1060 -410 {lab=VREF+}
N -1020 -380 -1020 -350 {lab=#net2}
N -820 -380 -820 -350 {lab=#net2}
N -920 -350 -820 -350 {lab=#net2}
N -1020 -490 -1020 -440 {lab=#net3}
N -820 -590 -820 -540 {lab=VDD}
N -1020 -590 -1020 -540 {lab=VDD}
N -1020 -590 -820 -590 {lab=VDD}
N -960 -540 -860 -540 {lab=#net3}
N -1020 -490 -960 -490 {lab=#net3}
N -1020 -510 -1020 -490 {lab=#net3}
N -960 -540 -960 -490 {lab=#net3}
N -980 -540 -960 -540 {lab=#net3}
N -820 -470 -820 -440 {lab=#net4}
N -920 -350 -920 -310 {lab=#net2}
N -1020 -350 -920 -350 {lab=#net2}
N -920 -280 -920 -230 {lab=VSS}
N -1180 -280 -1180 -230 {lab=VSS}
N -1120 -280 -960 -280 {lab=Vbias}
N -1180 -330 -1180 -310 {lab=Vbias}
N -1180 -590 -1020 -590 {lab=VDD}
N -1180 -330 -1120 -330 {lab=Vbias}
N -1120 -330 -1120 -280 {lab=Vbias}
N -1140 -280 -1120 -280 {lab=Vbias}
N -1020 -410 -820 -410 {lab=VSS}
N -1180 -230 -920 -230 {lab=VSS}
N -820 -510 -820 -470 {lab=#net4}
N -820 -470 -760 -470 {lab=#net4}
N -920 -230 -640 -230 {lab=VSS}
N -640 -250 -640 -240 {lab=VSS}
N -640 -240 -640 -230 {lab=VSS}
N -720 -280 -680 -280 {lab=Vbias}
N -760 -470 -670 -470 {lab=#net4}
N -640 -440 -640 -310 {lab=#net1}
N -540 -590 -540 -480 {lab=VDD}
N -820 -590 -540 -590 {lab=VDD}
N -640 -470 -540 -470 {lab=VDD}
N -540 -480 -540 -470 {lab=VDD}
N -640 -400 -550 -400 {lab=#net1}
N -640 -590 -640 -500 {lab=VDD}
N -640 -280 -640 -250 {lab=VSS}
N -660 -440 -660 -400 {lab=#net1}
N -660 -400 -640 -400 {lab=#net1}
N -670 -440 -660 -440 {lab=#net1}
N -780 -410 -770 -410 {lab=VREF-}
N -550 -400 -490 -400 {lab=#net1}
N -490 -400 -490 -340 {lab=#net1}
N -280 -290 -280 -260 {lab=VLDO}
N -280 -200 -280 -170 {lab=VSS}
N -1180 -590 -1180 -560 {lab=VDD}
N -1180 -500 -1180 -440 {lab=#net5}
N -1180 -550 -1180 -530 {lab=VDD}
N -1180 -380 -1180 -330 {lab=Vbias}
N -1280 -410 -1220 -410 {lab=VDD}
N -1280 -590 -1280 -410 {lab=VDD}
N -1280 -590 -1180 -590 {lab=VDD}
N -1180 -410 -1150 -410 {lab=VSS}
N -1150 -410 -1150 -360 {lab=VSS}
N -1180 -560 -1180 -550 {lab=VDD}
N -1220 -530 -1220 -510 {lab=#net5}
N -1220 -510 -1220 -480 {lab=#net5}
N -1220 -480 -1180 -480 {lab=#net5}
N -820 -440 -810 -440 {lab=#net4}
N -750 -440 -730 -440 {lab=#net4}
N -810 -440 -750 -440 {lab=#net4}
N -420 -290 -370 -290 {lab=VLDO}
N -510 -290 -480 -290 {lab=#net6}
N -510 -400 -510 -350 {lab=#net1}
C {ngspice_probe.sym} -450 -340 0 0 {name=r5}
C {ngspice_get_value.sym} -360 -380 0 0 {name=r10 node=i(@n.xmG.nsg13_lv_pmos[ids])
descr="i(mg[id])"}
C {ngspice_get_value.sym} -380 -380 0 1 {name=r11 node=@n.xmg.nsg13_lv_pmos[gm]
descr="mg[gm]"}
C {ngspice_get_value.sym} -300 -380 0 0 {name=r12 node=@n.xmG.nsg13_lv_pmos[gds]
descr="mg[gds]"}
C {sg13_lv_pmos.sym} -390 -340 0 0 {name=MG
l=0.13u
w=250u
ng=50

m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {res.sym} -370 -140 0 0 {name=R2
value=30k
footprint=1206
device=resistor
m=1}
C {res.sym} -370 -240 0 0 {name=R1
value=30k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} -370 -90 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -370 -440 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {ngspice_probe.sym} -470 -190 0 0 {name=r4}
C {sg13_lv_nmos.sym} -1040 -410 2 1 {name=M1
l=10u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -800 -410 2 0 {name=M2
l=10u
w=200u
ng=20
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -1000 -540 0 1 {name=M3
l=26u
w=13u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -840 -540 0 0 {name=M4
l=26u
w=13u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -940 -280 2 1 {name=M5
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -1160 -280 2 0 {name=M8
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -920 -410 3 1 {name=p16 sig_type=std_logic lab=VSS}
C {sg13_lv_nmos.sym} -660 -280 2 1 {name=M7
l=2u
w=4.4u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -1120 -320 0 0 {name=p17 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} -720 -280 0 0 {name=p18 sig_type=std_logic lab=Vbias}
C {sg13_lv_pmos.sym} -660 -470 0 0 {name=M6
l=1.5u
w=3.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} -700 -440 1 0 {name=C1
m=1
value=0.02p


footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -540 -590 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -640 -230 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} -640 -320 0 0 {name=r6 node=i(@n.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} -920 -310 0 0 {name=r7 node=i(@n.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} -580 -320 0 0 {name=r8 node=@n.xm7.nsg13_lv_nmos[gds]
descr="m7[gds]"}
C {ngspice_get_value.sym} -850 -310 0 0 {name=r9 node=@n.xm5.nsg13_lv_nmos[gds]
descr="m1[gds]"}
C {ngspice_get_value.sym} -620 -520 0 0 {name=r13 node=@n.xm6.nsg13_lv_pmos[gds]
descr="m6[gds]"}
C {ngspice_get_value.sym} -660 -530 0 1 {name=r14 node=@n.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
C {capa.sym} -280 -230 0 0 {name=C2
m=1
value=1u
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -280 -180 0 1 {name=p14 sig_type=std_logic lab=VSS}
C {sg13_lv_pmos.sym} -1200 -530 0 0 {name=M10
l=8u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -1200 -410 2 1 {name=M11
l=8u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -1150 -360 0 1 {name=p15 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} -1280 -330 0 0 {name=r15 node=i(@n.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
C {ipin.sym} -1080 -410 0 0 {name=p1 lab=VREF+}
C {ipin.sym} -770 -410 0 1 {name=p3 lab=VREF-}
C {opin.sym} -190 -290 0 0 {name=p5 lab=VLDO}
C {iopin.sym} -370 -70 0 0 {name=p7 lab=VSS}
C {iopin.sym} -540 -560 0 0 {name=p2 lab=VDD}
C {opin.sym} -710 -190 0 1 {name=p6 lab=VRET}
C {capa.sym} -450 -290 1 0 {name=C3
m=1
value=5n


footprint=1206
device="ceramic capacitor"}
C {res.sym} -510 -320 0 0 {name=R3
value=30k
footprint=1206
device=resistor
m=1}
