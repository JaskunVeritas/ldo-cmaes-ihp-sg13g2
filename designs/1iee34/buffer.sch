v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 50 -110 50 -70 {lab=Vout}
N 50 -220 50 -170 {lab=VDD}
N 50 -10 50 40 {lab=VSS}
N -40 -40 10 -40 {lab=VREF}
N -40 -140 -40 -40 {lab=VREF}
N -40 -140 10 -140 {lab=VREF}
N -90 -90 -40 -90 {lab=VREF}
N -300 -30 -300 10 {lab=VDD}
N -220 -30 -220 10 {lab=VSS}
N -300 -230 -300 -190 {lab=VREF}
N -300 -130 -300 -90 {lab=VSS}
N 50 -90 130 -90 {lab=Vout}
C {sg13_lv_pmos.sym} 30 -140 0 0 {name=M1
l=0.45u
w=1.0u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} 30 -40 2 1 {name=M2
l=0.45u
w=1.0u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {vsource.sym} -300 40 0 0 {name=V1 value="dc 1.5 " savecurrent=false}
C {gnd.sym} -300 70 0 0 {name=l1 lab=GND}
C {vsource.sym} -220 40 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -220 70 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -300 -10 0 1 {name=p1 sig_type=std_logic lab=VDD}
C {vsource.sym} -300 -160 0 0 {name=V3 value=0.6 savecurrent=false}
C {lab_pin.sym} -220 -10 0 1 {name=p5 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -300 -210 0 1 {name=p2 sig_type=std_logic lab=VREF}
C {lab_pin.sym} -300 -110 0 1 {name=p3 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 50 -210 0 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 50 20 0 1 {name=p6 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -90 -90 0 0 {name=p7 sig_type=std_logic lab=VREF}
C {lab_pin.sym} 130 -90 0 1 {name=p8 sig_type=std_logic lab=Vout
}
C {code_shown.sym} 240 -350 0 0 {name=MODEL1 only_toplevel=false value="
.lib cornerMOSlv.lib mos_tt
"}
C {launcher.sym} -40 -320 0 0 {name=h2
descr=Backannotate-OP
tclcommand="xschem annotate_op"}
C {code_shown.sym} 240 -250 0 0 {name=NGSPICE only_toplevel=false value="
.param temp=27
.options savecurrents
.op
.save all
+ @n.xm1.nsg13_lv_pmos[ids]
+ @n.xm1.nsg13_lv_pmos[gm]
+ @n.xm1.nsg13_lv_pmos[gds]
+ @n.xm2.nsg13_lv_nmos[ids]
+ @n.xm2.nsg13_lv_nmos[gm]
+ @n.xm2.nsg13_lv_nmos[gds]


.control
set filetype=ascii
  set units=degress
  dc v3 0 1.5 0.01
 
  write tb_buffer_DC_03.raw v(vout)
  set appendwrite

.endc
"}
