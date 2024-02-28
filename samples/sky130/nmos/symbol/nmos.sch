v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -80 0 -30 0 {
lab=G}
N 10 70 10 130 {
lab=S}
N 10 0 90 0 {
lab=S}
N 90 0 90 70 {
lab=S}
N 10 70 90 70 {
lab=S}
N 10 -170 10 -40 {
lab=D}
N 10 -170 160 -170 {
lab=D}
N 10 30 10 70 {
lab=S}
N 10 -40 10 -30 {
lab=D}
C {devices/ipin.sym} -80 0 0 0 {name=p1 lab=G}
C {devices/iopin.sym} 160 -170 0 0 {name=p2 lab=D}
C {sky130_fd_pr/nfet_01v8.sym} -10 0 0 0 {name=M1
L=0.3
W=10
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
C {devices/iopin.sym} 10 130 0 0 {name=p3 lab=S}
