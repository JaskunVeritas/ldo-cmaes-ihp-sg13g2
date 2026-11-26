v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -830 50 -830 90 {lab=VDD}
N -750 50 -750 90 {lab=VSS}
N -830 -150 -830 -110 {lab=VREF}
N 190 50 190 90 {lab=VSS}
N 190 -50 190 -10 {lab=VLDO}
N -830 -50 -830 -10 {lab=VSS}
N 140 -50 190 -50 {lab=VLDO}
N 40 10 40 90 {lab=VSS}
N -60 10 -60 50 {lab=#net1}
N -190 50 -60 50 {lab=#net1}
N -190 -30 -190 50 {lab=#net1}
N -190 -30 -160 -30 {lab=#net1}
N -200 -70 -160 -70 {lab=VREF}
N -10 -160 -10 -110 {lab=VDD}
C {vsource.sym} -830 120 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -830 150 0 0 {name=l1 lab=GND}
C {vsource.sym} -750 120 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -750 150 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -830 70 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -830 -80 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -750 70 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 620 -120 0 0 {name=NGSPICE only_toplevel=false value="
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

.control
  noise v(vldo) v1 dec 80 1 10000k 1
  print inoise_total onoise_total
  set filetype = ascii
  write ckt_noise2_all.raw noise1.all noise2.all
  setplot noise1
  write ckt_noise2_1.raw all
  write ckt_noise2.raw inoise_spectrum onoise_spectrum
  setplot noise2
  write ckt_noise2_2.raw all
.endc
"}
C {code_shown.sym} 630 -230 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 350 -200 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 190 20 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 190 70 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -10 -140 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 190 -50 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -830 -130 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -830 -30 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} -10 -50 0 0 {name=x1}
C {lab_pin.sym} 40 80 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -200 -70 0 0 {name=p6 sig_type=std_logic lab=VREF}
