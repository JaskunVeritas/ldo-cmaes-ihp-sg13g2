v {xschem version=3.4.6 file_version=1.2}
G {}
K {type=subcircuit
format="@name @pinlist @symname"
template="name=x1"
}
V {}
S {}
E {}
B 5 -152.5 -22.5 -147.5 -17.5 {name=IN dir=in}
B 5 67.5 -22.5 72.5 -17.5 {name=OUT dir=out}
N -310 20 -310 40 {lab=GND}
N -310 -90 -310 -40 {lab=VDD}
N -380 20 -380 40 {lab=GND}
N -380 -90 -380 -40 {lab=VSS}
N -210 140 -210 160 {lab=GND}
N -210 30 -210 80 {lab=IN}
N -50 50 -50 100 {lab=VSS}
N -210 -20 -210 30 {lab=IN}
N -210 -20 -150 -20 {lab=IN}
N 70 -20 130 -20 {lab=OUT}
N 130 40 130 80 {lab=VSS}
N -50 -120 -50 -80 {lab=VDD}
C {vsource.sym} -310 -10 0 0 {name=V1 value=1.2 savecurrent=false}
C {gnd.sym} -310 40 0 0 {name=l1 lab=GND}
C {capa.sym} 130 10 0 0 {name=C1
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {code_shown.sym} 270 -80 0 0 {name=NGSPICE
only_toplevel=true
value="
.param temp=27
.tran 50p 20n
.save all
"}
C {vsource.sym} -380 -10 0 0 {name=V2 value=0 savecurrent=false}
C {gnd.sym} -380 40 0 0 {name=l2 lab=GND}
C {lab_pin.sym} -50 100 0 0 {name=p1 sig_type=std_logic lab=VSS}
C {lab_pin.sym} 100 -20 1 0 {name=p2 sig_type=std_logic lab=OUT
}
C {vsource.sym} -210 110 0 0 {name=V3 value="dc 0 pulse 0 1.2 2n 100p 100p 2n 4n" savecurrent=false}
C {gnd.sym} -210 160 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -210 40 0 0 {name=p3 sig_type=std_logic lab=IN
}
C {lab_pin.sym} -380 -80 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {lab_pin.sym} -310 -80 0 0 {name=p6 sig_type=std_logic lab=VDD
}
C {lab_pin.sym} 130 80 0 0 {name=p7 sig_type=std_logic lab=VSS}
C {code_shown.sym} 270 50 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
"}
C {inv_1x.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -50 -120 0 0 {name=p5 sig_type=std_logic lab=VDD}
