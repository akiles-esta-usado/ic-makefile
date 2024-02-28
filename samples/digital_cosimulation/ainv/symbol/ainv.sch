v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 290 -20 290 -0 {
lab=out}
N 290 -10 320 -10 {
lab=out}
N 240 -50 250 -50 {
lab=in}
N 240 -50 240 30 {
lab=in}
N 240 30 250 30 {
lab=in}
N 220 -10 240 -10 {
lab=in}
N 290 -90 290 -80 {
lab=vdd}
N 290 60 290 70 {
lab=vss}
N 290 -50 300 -50 {
lab=vdd}
N 300 -80 300 -50 {
lab=vdd}
N 290 -80 300 -80 {
lab=vdd}
N 290 30 300 30 {
lab=vss}
N 300 30 300 60 {
lab=vss}
N 290 60 300 60 {
lab=vss}
C {devices/code.sym} -20 -30 0 0 {name=MODELS
only_toplevel=false
place=header
value="
.model p1 pmos
+  level=2 vto=-0.5 kp=8.5e-6 gamma=0.4 phi=0.65 lambda=0.05 xj=0.5e-6
.model n1 nmos
+  level=2 vto=0.5 kp=24e-6 gamma=0.15 phi=0.65 lambda=0.015 xj=0.5e-6
"}
C {devices/nmos4.sym} 270 30 0 0 {name=mn model=n1}
C {devices/pmos4.sym} 270 -50 0 0 {name=mp model=p1}
C {devices/iopin.sym} 290 -90 3 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 320 -10 0 0 {name=p2 lab=out}
C {devices/iopin.sym} 290 70 0 0 {name=p3 lab=vss}
C {devices/iopin.sym} 220 -10 2 0 {name=p4 lab=in}
