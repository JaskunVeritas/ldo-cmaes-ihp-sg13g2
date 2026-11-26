v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -840 60 -840 100 {lab=VDD}
N -760 60 -760 100 {lab=VSS}
N -840 -140 -840 -100 {lab=VREF}
N 180 60 180 100 {lab=VSS}
N 180 -40 180 0 {lab=VLDO}
N -840 -40 -840 0 {lab=VSS}
N 130 -40 180 -40 {lab=VLDO}
N 30 20 30 100 {lab=VSS}
N -70 20 -70 60 {lab=#net1}
N -200 60 -70 60 {lab=#net1}
N -200 -20 -200 60 {lab=#net1}
N -200 -20 -170 -20 {lab=#net1}
N -210 -60 -170 -60 {lab=VREF}
N -20 -150 -20 -100 {lab=VDD}
C {vsource.sym} -840 130 0 0 {name=V1 value="dc 1.5 ac 1" savecurrent=false}
C {gnd.sym} -840 160 0 0 {name=l1 lab=GND}
C {vsource.sym} -760 130 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -760 160 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -840 80 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -840 -70 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -760 80 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {code_shown.sym} 610 -110 0 0 {name=NGSPICE only_toplevel=false value="
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
  noise v(vldo) v1 dec 80 1 10k 1
  print inoise_total onoise_total
  set filetype = ascii
  write ckt_noise_all.raw noise1.all noise2.all
  setplot noise1
  write ckt_noise_1.raw all
  write ckt_noise.raw inoise_spectrum onoise_spectrum
  setplot noise2
  write ckt_noise_2.raw all
.endc
"}
C {code_shown.sym} 620 -220 0 0 {name=MODEL only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} 340 -190 0 0 {name=h1
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {res.sym} 180 30 0 0 {name=R3
value=240
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 180 80 0 1 {name=p9 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -20 -130 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 180 -40 0 1 {name=p12 sig_type=std_logic lab=VLDO}
C {lab_pin.sym} -840 -120 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -840 -20 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {LDO1.sym} -20 -40 0 0 {name=x1}
C {lab_pin.sym} 30 90 0 1 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -210 -60 0 0 {name=p6 sig_type=std_logic lab=VREF}
