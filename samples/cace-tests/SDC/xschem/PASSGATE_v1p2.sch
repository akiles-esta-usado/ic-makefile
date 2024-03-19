v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 150 -75 150 75 { lab=VIN}
N 210 -75 210 75 { lab=VOUT}
N 120 115 180 115 { lab=#net1}
N 20 -115 20 115 { lab=CTR}
N 180 -75 180 -45 { lab=VSS}
N 180 45 180 75 { lab=VDD}
N 75 145 75 170 { lab=VSS}
N 75 55 75 85 { lab=VDD}
N 100 -0 150 -0 { lab=VIN}
N 210 -0 260 -0 { lab=VOUT}
N 20 -115 180 -115 { lab=CTR}
N 20 115 40 115 { lab=CTR}
C {sky130_fd_pr/nfet_01v8.sym} 180 -95 1 0 {name=MNSW
L=0.15
W=2
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 180 95 3 0 {name=MPSW
L=0.15
W=6
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {INVMIN_v1p1.sym} 0 115 0 0 {name=X1}
C {devices/lab_pin.sym} 100 0 0 0 {name=l1 sig_type=std_logic lab=VIN}
C {devices/lab_pin.sym} 260 0 0 1 {name=l2 sig_type=std_logic lab=VOUT}
C {devices/lab_pin.sym} 180 -45 3 0 {name=l3 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 180 45 1 0 {name=l4 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 75 170 0 0 {name=l5 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 75 55 0 0 {name=l6 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 20 -115 0 0 {name=l7 sig_type=std_logic lab=CTR}
C {devices/ipin.sym} 60 -220 0 0 {name=p1 lab=VIN}
C {devices/iopin.sym} 85 -220 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} 85 -190 0 0 {name=p3 lab=VSS}
C {devices/ipin.sym} 60 -190 0 0 {name=p4 lab=CTR}
C {devices/opin.sym} 180 -220 0 0 {name=p5 lab=VOUT}
