v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -1400 -270 -1400 -230 {lab=VDD}
N -1320 -270 -1320 -230 {lab=VSS}
N -1400 -470 -1400 -430 {lab=VREF}
N -1080 -380 -1080 -340 {lab=VSS}
N -1080 -500 -1080 -460 {lab=VDD}
N -720 -270 -720 -230 {lab=VSS}
N -720 -370 -720 -330 {lab=VLDO}
N -900 -370 -900 -350 {lab=VLDO}
N -900 -370 -720 -370 {lab=VLDO}
N -900 -390 -900 -370 {lab=VLDO}
N -900 -270 -900 -250 {lab=#net1}
N -900 -190 -900 -150 {lab=VSS}
N -1160 -400 -1140 -400 {lab=VREF}
N -1240 -440 -1240 -270 {lab=#net1}
N -1240 -440 -1140 -440 {lab=#net1}
N -900 -500 -900 -420 {lab=VDD}
N -1080 -500 -900 -500 {lab=VDD}
N -1400 -370 -1400 -330 {lab=VSS}
N -1020 -420 -940 -420 {lab=#net2}
N -1240 -270 -900 -270 {lab=#net1}
N -900 -290 -900 -270 {lab=#net1}
C {vsource.sym} -1400 -200 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -1400 -170 0 0 {name=l1 lab=GND}
C {vsource.sym} -1320 -200 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -1320 -170 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -1400 -250 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -1400 -400 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -1320 -250 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {ngspice_probe.sym} -980 -420 0 0 {name=r5}
C {code_shown.sym} -580 -460 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
+ @n.xm1.nsg13_lv_pmos[ids]
+ @n.xm1.nsg13_lv_pmos[gm]
+ @n.xm1.nsg13_lv_pmos[gds]

.control
  ac dec 160 10 1g
  set filetype=ascii
  set units=degress
  let PSRR = 1/VLDO
  write tb_ldo_03.raw vdb(PSRR) vp(PSRR)
  set appendwrite
.endc
"}
C {code_shown.sym} -570 -570 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} -850 -540 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {ngspice_get_value.sym} -890 -460 0 0 {name=r10 node=i(@n.xm1.nsg13_lv_pmos[ids])
descr="i(m1[id])"}
C {ngspice_get_value.sym} -910 -460 0 1 {name=r11 node=@n.xm1.nsg13_lv_pmos[gm]
descr="m1[gm]"}
C {ngspice_get_value.sym} -830 -460 0 0 {name=r12 node=@n.xm1.nsg13_lv_pmos[gds]
descr="m1[gds]"}
C {/home/mraffo/amaru/analog/core/opamp_01.sym} -1080 -420 0 0 {name=x1}
C {sg13_lv_pmos.sym} -920 -420 0 0 {name=M1
l=0.25u
w=500u
ng=50
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {lab_pin.sym} -1080 -360 0 1 {name=p7 sig_type=std_logic lab=VSS}
C {res.sym} -900 -220 0 0 {name=R2
value=500k
footprint=1206
device=resistor
m=1}
C {res.sym} -900 -320 0 0 {name=R1
value=500k
footprint=1206
device=resistor
m=1}
C {res.sym} -720 -300 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} -720 -250 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -900 -170 0 1 {name=p10 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -1160 -400 0 0 {name=p11 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -1080 -500 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -720 -370 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -1400 -450 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {ngspice_probe.sym} -1000 -270 0 0 {name=r4}
C {lab_pin.sym} -1400 -350 0 1 {name=p3 sig_type=std_logic lab=VSS}
