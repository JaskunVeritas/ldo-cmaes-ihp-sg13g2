v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -1690 0 -1690 40 {lab=VDD}
N -1610 0 -1610 40 {lab=VSS}
N -1690 -200 -1690 -160 {lab=VREF}
N -380 20 -380 60 {lab=VSS}
N -380 -80 -380 -40 {lab=VLDO}
N -560 -80 -560 -60 {lab=VLDO}
N -560 -80 -380 -80 {lab=VLDO}
N -560 -100 -560 -80 {lab=VLDO}
N -560 20 -560 40 {lab=Vret}
N -560 100 -560 140 {lab=VSS}
N -560 -230 -560 -130 {lab=VDD}
N -1690 -100 -1690 -60 {lab=VSS}
N -680 -130 -600 -130 {lab=#net1}
N -900 20 -560 20 {lab=Vret}
N -560 0 -560 20 {lab=Vret}
N -1270 -200 -1250 -200 {lab=VREF}
N -1210 -170 -1210 -140 {lab=#net2}
N -1010 -170 -1010 -140 {lab=#net2}
N -1110 -140 -1010 -140 {lab=#net2}
N -1210 -280 -1210 -230 {lab=#net3}
N -1010 -380 -1010 -330 {lab=VDD}
N -1210 -380 -1210 -330 {lab=VDD}
N -1210 -380 -1010 -380 {lab=VDD}
N -1150 -330 -1050 -330 {lab=#net3}
N -1210 -280 -1150 -280 {lab=#net3}
N -1210 -300 -1210 -280 {lab=#net3}
N -1150 -330 -1150 -280 {lab=#net3}
N -1170 -330 -1150 -330 {lab=#net3}
N -1010 -260 -1010 -230 {lab=#net4}
N -1110 -140 -1110 -100 {lab=#net2}
N -1210 -140 -1110 -140 {lab=#net2}
N -1110 -70 -1110 -20 {lab=VSS}
N -1370 -70 -1370 -20 {lab=VSS}
N -1310 -70 -1150 -70 {lab=Vbias}
N -1370 -120 -1370 -100 {lab=Vbias}
N -1370 -380 -1210 -380 {lab=VDD}
N -1370 -120 -1310 -120 {lab=Vbias}
N -1310 -120 -1310 -70 {lab=Vbias}
N -1330 -70 -1310 -70 {lab=Vbias}
N -1210 -200 -1010 -200 {lab=VSS}
N -1370 -20 -1110 -20 {lab=VSS}
N -1010 -300 -1010 -260 {lab=#net4}
N -1010 -260 -950 -260 {lab=#net4}
N -1110 -20 -830 -20 {lab=VSS}
N -830 -40 -830 -30 {lab=VSS}
N -830 -30 -830 -20 {lab=VSS}
N -910 -70 -870 -70 {lab=Vbias}
N -950 -260 -860 -260 {lab=#net4}
N -830 -230 -830 -100 {lab=#net1}
N -730 -380 -730 -270 {lab=VDD}
N -1010 -380 -730 -380 {lab=VDD}
N -830 -260 -730 -260 {lab=VDD}
N -730 -270 -730 -260 {lab=VDD}
N -830 -190 -740 -190 {lab=#net1}
N -830 -380 -830 -290 {lab=VDD}
N -830 -70 -830 -40 {lab=VSS}
N -1010 -230 -940 -230 {lab=#net4}
N -850 -230 -850 -190 {lab=#net1}
N -850 -190 -830 -190 {lab=#net1}
N -940 -230 -920 -230 {lab=#net4}
N -860 -230 -850 -230 {lab=#net1}
N -970 -200 -960 -200 {lab=Vret}
N -740 -190 -680 -190 {lab=#net1}
N -680 -190 -680 -130 {lab=#net1}
N -470 -80 -470 -50 {lab=VLDO}
N -470 10 -470 40 {lab=VSS}
N -1370 -380 -1370 -350 {lab=VDD}
N -1370 -290 -1370 -230 {lab=#net5}
N -1370 -340 -1370 -320 {lab=VDD}
N -1370 -170 -1370 -120 {lab=Vbias}
N -1470 -200 -1410 -200 {lab=VDD}
N -1470 -380 -1470 -200 {lab=VDD}
N -1470 -380 -1370 -380 {lab=VDD}
N -1370 -200 -1340 -200 {lab=VSS}
N -1340 -200 -1340 -150 {lab=VSS}
N -1370 -350 -1370 -340 {lab=VDD}
N -1410 -320 -1410 -300 {lab=#net5}
N -1410 -300 -1410 -270 {lab=#net5}
N -1410 -270 -1370 -270 {lab=#net5}
C {vsource.sym} -1690 70 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -1690 100 0 0 {name=l1 lab=GND}
C {vsource.sym} -1610 70 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -1610 100 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -1690 20 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -1690 -130 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -1610 20 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {ngspice_probe.sym} -640 -130 0 0 {name=r5}
C {code_shown.sym} -240 -170 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
+ @n.xmG.nsg13_lv_pmos[ids]
+ @n.xmG.nsg13_lv_pmos[gm]
+ @n.xmG.nsg13_lv_pmos[gds]
+ @n.xm6.nsg13_lv_pmos[gds]
+ @n.xm6.nsg13_lv_pmos[gm]
+ @n.xm5.nsg13_lv_nmos[ids]
+ @n.xm5.nsg13_lv_nmos[gm]
+ @n.xm5.nsg13_lv_nmos[gds]

+ @n.xm8.nsg13_lv_nmos[ids]

+ @n.xm7.nsg13_lv_nmos[ids]
+ @n.xm7.nsg13_lv_nmos[gm]
+ @n.xm7.nsg13_lv_nmos[gds]
.control
  ac dec 160 10 1g
  set filetype=ascii
  set units=degress
  let PSRR = 1/VLDO
  write tb_ldo_03.raw vdb(PSRR) vp(PSRR)
  set appendwrite
.endc
"}
C {code_shown.sym} -230 -280 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} -510 -250 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {ngspice_get_value.sym} -550 -170 0 0 {name=r10 node=i(@n.xmG.nsg13_lv_pmos[ids])
descr="i(mg[id])"}
C {ngspice_get_value.sym} -570 -170 0 1 {name=r11 node=@n.xmg.nsg13_lv_pmos[gm]
descr="mg[gm]"}
C {ngspice_get_value.sym} -490 -170 0 0 {name=r12 node=@n.xmG.nsg13_lv_pmos[gds]
descr="mg[gds]"}
C {sg13_lv_pmos.sym} -580 -130 0 0 {name=MG
l=0.13u
w=250u
ng=50

m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {res.sym} -560 70 0 0 {name=R2
value=500k
footprint=1206
device=resistor
m=1}
C {res.sym} -560 -30 0 0 {name=R1
value=500k
footprint=1206
device=resistor
m=1}
C {res.sym} -380 -10 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} -380 40 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -560 120 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -560 -230 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -380 -80 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -1690 -180 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {ngspice_probe.sym} -660 20 0 0 {name=r4}
C {lab_pin.sym} -1690 -80 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {sg13_lv_nmos.sym} -1230 -200 0 0 {name=M1
l=0.25u
w=5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -990 -200 0 1 {name=M2
l=0.25u
w=5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -1190 -330 0 1 {name=M3
l=2u
w=1u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_pmos.sym} -1030 -330 0 0 {name=M4
l=2u
w=1u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -1130 -70 0 0 {name=M5
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -1350 -70 0 1 {name=M8
l=2u
w=2.2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -1110 -200 3 1 {name=p16 sig_type=std_logic lab=VSS}
C {sg13_lv_nmos.sym} -850 -70 0 0 {name=M7
l=2u
w=4.4u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -1310 -110 0 0 {name=p17 sig_type=std_logic lab=Vbias}
C {lab_pin.sym} -910 -70 0 0 {name=p18 sig_type=std_logic lab=Vbias}
C {sg13_lv_pmos.sym} -850 -260 0 0 {name=M6
l=0.25u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {capa.sym} -890 -230 1 0 {name=C1
m=1
value=0.2p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -900 20 0 0 {name=p6 sig_type=std_logic lab=Vret}
C {lab_pin.sym} -960 -200 0 1 {name=p7 sig_type=std_logic lab=Vret}
C {lab_pin.sym} -730 -380 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -830 -20 0 1 {name=p11 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -1270 -200 0 0 {name=p13 sig_type=std_logic lab=VREF}
C {ngspice_get_value.sym} -830 -110 0 0 {name=r6 node=i(@n.xm7.nsg13_lv_nmos[ids])
descr="i(m7[id])"}
C {ngspice_get_value.sym} -1110 -100 0 0 {name=r7 node=i(@n.xm5.nsg13_lv_nmos[ids])
descr="i(m5[id])"}
C {ngspice_get_value.sym} -770 -110 0 0 {name=r8 node=@n.xm7.nsg13_lv_nmos[gds]
descr="m7[gds]"}
C {ngspice_get_value.sym} -1040 -100 0 0 {name=r9 node=@n.xm5.nsg13_lv_nmos[gds]
descr="m1[gds]"}
C {ngspice_get_value.sym} -810 -310 0 0 {name=r13 node=@n.xm6.nsg13_lv_pmos[gds]
descr="m6[gds]"}
C {ngspice_get_value.sym} -850 -320 0 1 {name=r14 node=@n.xm6.nsg13_lv_pmos[gm]
descr="m6[gm]"}
C {capa.sym} -470 -20 0 0 {name=C2
m=1
value=5u
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -470 30 0 1 {name=p14 sig_type=std_logic lab=VSS}
C {sg13_lv_pmos.sym} -1390 -320 0 0 {name=M10
l=8u
w=2u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -1390 -200 0 0 {name=M11
l=8u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {lab_pin.sym} -1340 -150 0 1 {name=p15 sig_type=std_logic lab=VSS}
C {ngspice_get_value.sym} -1470 -120 0 0 {name=r15 node=i(@n.xm8.nsg13_lv_nmos[ids])
descr="i(m8[id])"}
