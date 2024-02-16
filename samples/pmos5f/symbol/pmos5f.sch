v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 10 0 20 -0 {
lab=D}
N 10 -50 10 -30 {
lab=S}
N -50 -0 -30 -0 {
lab=G}
N 10 30 10 50 {
lab=D}
N 20 -40 20 0 {}
N 10 -40 20 -40 {}
C {symbols/pfet_03v3.sym} -10 0 0 0 {name=M2
L=0.7u
W=5u
nf=5
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
C {devices/iopin.sym} 10 -50 3 0 {name=p1 lab=S}
C {devices/iopin.sym} 10 50 1 0 {name=p2 lab=D}
C {devices/iopin.sym} -50 0 2 0 {name=p3 lab=G}
