v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 170 20 210 20 { lab=VIN}
N 170 20 170 130 { lab=VIN}
N 170 130 210 130 { lab=VIN}
N 250 50 250 100 { lab=VOUT}
N 250 -60 250 -10 { lab=VDD}
N 110 70 170 70 { lab=VIN}
N 250 20 280 20 { lab=VDD}
N 280 -30 280 20 { lab=VDD}
N 250 -30 280 -30 { lab=VDD}
N 250 130 280 130 { lab=VSS}
N 280 130 280 180 { lab=VSS}
N 250 180 280 180 { lab=VSS}
N 250 160 250 180 { lab=VSS}
N 250 180 250 210 { lab=VSS}
N 250 70 310 70 { lab=VOUT}
C {sky130_fd_pr/nfet_01v8.sym} 230 130 0 0 {name=M1
L=0.15
W=2
nf=2
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
C {sky130_fd_pr/pfet_01v8.sym} 230 20 0 0 {name=M2
L=0.15
W=6
nf=6
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
C {devices/ipin.sym} 110 70 0 0 {name=p1 lab=VIN}
C {devices/iopin.sym} 250 -60 3 0 {name=p2 lab=VDD}
C {devices/iopin.sym} 250 210 1 0 {name=p4 lab=VSS}
C {devices/opin.sym} 310 70 0 0 {name=p5 lab=VOUT}
