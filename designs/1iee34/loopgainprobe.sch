v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -170 -80 -120 -80 {lab=xxx}
N -140 -80 -140 -60 {lab=xxx}
N -140 0 -140 30 {lab=GND}
N -60 -80 -20 -80 {lab=a}
N -280 -80 -230 -80 {lab=b}
C {vsource.sym} -90 -80 3 0 {name=Vi value= "dc 0 ac 1" savecurrent=false}
C {isource.sym} -140 -30 2 0 {name=Ii value="dc 0 ac 0"}
C {vsource.sym} -200 -80 3 0 {name=Vnodebuffer value=0 savecurrent=false}
C {gnd.sym} -140 30 0 0 {name=l1 lab=GND}
C {iopin.sym} -20 -80 0 0 {name=p1 lab=a}
C {iopin.sym} -280 -80 0 1 {name=p2 lab=b}
C {lab_pin.sym} -150 -80 1 0 {name=p3 sig_type=std_logic lab=x}
