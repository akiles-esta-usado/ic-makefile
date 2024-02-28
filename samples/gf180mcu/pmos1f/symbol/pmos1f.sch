v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 140 -160 140 -110 {
lab=S}
N 50 -80 100 -80 {
lab=G}
N 140 -50 140 -30 {
lab=D}
N 140 -30 140 -10 {
lab=D}
N 140 -80 170 -80 {
lab=B}
N 170 -80 170 -40 {
lab=B}
C {symbols/pfet_03v3.sym} 120 -80 0 0 {name=M1
L=0.28u
W=0.42u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/iopin.sym} 140 -160 0 0 {name=p1 lab=S}
C {devices/iopin.sym} 50 -80 2 0 {name=p2 lab=G}
C {devices/iopin.sym} 140 -10 0 0 {name=p3 lab=D}
C {devices/iopin.sym} 170 -40 0 0 {name=p4 lab=B}
