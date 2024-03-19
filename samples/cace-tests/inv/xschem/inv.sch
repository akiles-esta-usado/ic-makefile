v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 0 -20 0 20 {
lab=out}
N 0 0 50 -0 {
lab=out}
N -50 -50 -40 -50 {
lab=in}
N -50 -50 -50 50 {
lab=in}
N -50 50 -40 50 {
lab=in}
N -0 80 0 90 {
lab=vss}
N 0 -90 0 -80 {
lab=vdd}
N -60 -0 -50 0 {
lab=in}
C {sky130_fd_pr/pfet3_01v8.sym} -20 -50 0 0 {name=M1
L=0.15
W=3
body=VDD
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
C {sky130_fd_pr/nfet3_01v8.sym} -20 50 0 0 {name=M2
L=0.15
W=1
body=GND
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
C {devices/iopin.sym} 0 -90 3 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 0 90 1 0 {name=p2 lab=vss}
C {devices/ipin.sym} -60 0 0 0 {name=p3 lab=in}
C {devices/opin.sym} 50 0 0 0 {name=p4 lab=out}
