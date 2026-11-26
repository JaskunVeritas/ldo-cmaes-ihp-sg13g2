v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -10 -20 -10 20 {lab=OUT}
N -50 -50 -50 50 {lab=IN}
N -10 -120 -10 -80 {lab=VDD}
N -10 -50 10 -50 {lab=VDD}
N 10 -100 10 -50 {lab=VDD}
N -10 -100 10 -100 {lab=VDD}
N -80 0 -50 0 {lab=IN}
N -10 0 30 0 {lab=OUT}
N -10 80 -10 110 {lab=VSS}
N -10 50 10 50 {}
N 10 50 10 90 {}
N -10 90 10 90 {}
C {sg13_lv_pmos.sym} -30 -50 0 0 {name=M1
l=0.13u
w=2.0u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13_lv_nmos.sym} -30 50 2 1 {name=M2
l=0.13u
w=1.0u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {iopin.sym} -10 -120 0 0 {name=p1 lab=VDD}
C {iopin.sym} -10 110 0 0 {name=p2 lab=VSS}
C {ipin.sym} -80 0 0 0 {name=p3 lab=IN
}
C {opin.sym} 30 0 0 0 {name=p4 lab=OUT}
