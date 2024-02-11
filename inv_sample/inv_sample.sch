v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 0 -20 0 20 {
lab=out}
N 0 0 30 0 {
lab=out}
N -50 -50 -40 -50 {
lab=in}
N -50 50 -40 50 {
lab=in}
N 0 -100 -0 -80 {
lab=vpp}
N 0 80 0 100 {
lab=vss}
N 0 90 10 90 {
lab=vss}
N 10 50 10 90 {
lab=vss}
N -0 50 10 50 {
lab=vss}
N 0 -50 10 -50 {
lab=vpp}
N 10 -90 10 -50 {
lab=vpp}
N 0 -90 10 -90 {
lab=vpp}
N -50 -50 -50 50 {
lab=in}
N -50 0 -50 50 {
lab=in}
N -70 0 -50 0 {
lab=in}
C {symbols/pfet_03v3.sym} -20 -50 0 0 {name=M1
L=0.28u
W=1.26u
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
C {symbols/nfet_03v3.sym} -20 50 0 0 {name=M2
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
model=nfet_03v3
spiceprefix=X
}
C {devices/iopin.sym} 0 -100 3 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 30 0 0 0 {name=p2 lab=out}
C {devices/iopin.sym} 0 100 1 0 {name=p3 lab=vss}
C {devices/iopin.sym} -70 0 2 0 {name=p4 lab=in}
