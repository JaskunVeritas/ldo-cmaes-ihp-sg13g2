v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -190 -30 -190 -10 {lab=GND}
N -120 -30 -120 -10 {lab=GND}
N -60 -30 -60 -10 {lab=GND}
N 20 -120 30 -120 {lab=VGS}
N 30 -120 60 -120 {lab=VGS}
N 100 -90 100 -60 {lab=VSS}
N 100 -180 100 -150 {lab=VDD}
N 100 -120 100 -90 {lab=VSS}
N -200 -110 -190 -90 {lab=VDD}
N -130 -110 -120 -90 {lab=VSS}
N -70 -110 -60 -90 {lab=VGS}
C {vsource.sym} -190 -60 0 0 {name=V1 value=0.75 savecurrent=false}
C {vsource.sym} -120 -60 0 0 {name=V2 value=0 savecurrent=false}
C {vsource.sym} -60 -60 0 0 {name=V3 value=0.75
 savecurrent=false}
C {gnd.sym} -190 -10 0 0 {name=l1 lab=GND}
C {gnd.sym} -120 -10 0 0 {name=l2 lab=GND}
C {gnd.sym} -60 -10 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -200 -110 0 0 {name=p1 sig_type=std_logic lab=VDD
}
C {lab_pin.sym} -130 -110 0 0 {name=p2 sig_type=std_logic lab=VSS
}
C {lab_pin.sym} -70 -110 0 0 {name=p3 sig_type=std_logic lab=VGS

}
C {lab_pin.sym} 20 -120 0 0 {name=p4 sig_type=std_logic lab=VGS

}
C {lab_pin.sym} 100 -60 0 0 {name=p5 sig_type=std_logic lab=VSS
}
C {lab_pin.sym} 100 -180 0 0 {name=p6 sig_type=std_logic lab=VDD
}
C {code_shown.sym} -210 -300 0 0 {name=MODEL only_toplevel=false 
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
"}
C {code_shown.sym} 210 -460 0 0 {name=NGSPICE only_toplevel=true

value="
.param temp=27
.param widthn=1u
.param lengthn=0.13u
.dc v3 0 1.5 0.01
.save @n.xml.nsg13_lv_nmos[ids] v(VGS)

.control
	foreach wval 1u 2u 5u 10u
		alterparam widthn = $wval
		reset
		run
		let id_n = @n.xm1.nsg13_lv_nmos[ids]
		let gm_n = deriv(id_n)
		meas DC gm_n_value find gm_n when vgs=1.2
		set filetype = ascii
		write tb_nmos_vgs.raw id_n gm_n v(VGS)
		set appendwrite
		print gm_n_value
	end
.endc 
"}
C {sg13_lv_nmos.sym} 80 -120 2 1 {name=M1
l=lengthn
w=widthn
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
