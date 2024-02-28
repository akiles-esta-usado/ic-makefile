v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 230 -140 230 -130 {
lab=b}
N 230 -50 230 -40 {
lab=b}
N 190 -50 230 -50 {
lab=b}
N 190 -50 190 -40 {
lab=b}
N 190 -130 230 -130 {
lab=b}
N 190 -140 190 -130 {
lab=b}
N 180 -140 200 -140 {
lab=b}
N 260 -140 280 -140 {
lab=a}
N 180 -40 200 -40 {
lab=b}
N 260 -40 280 -40 {
lab=a}
N -160 -180 230 -180 {
lab=ctl}
N -110 -180 -110 -0 {
lab=ctl}
N -110 -0 -80 -0 {
lab=ctl}
N 130 -0 230 0 {
lab=ictl}
N 180 -140 180 -40 {
lab=b}
N 280 -140 280 -40 {
lab=a}
C {symbol/ainv.sym} 0 0 0 0 {name=xinv}
C {devices/iopin.sym} 0 -60 0 0 {name=p1 lab=vdd}
C {devices/iopin.sym} -160 -180 2 0 {name=p2 lab=ctl}
C {devices/nmos4.sym} 230 -160 1 0 {name=M1 model=n1}
C {devices/pmos4.sym} 230 -20 3 0 {name=M2 model=p1}
C {devices/iopin.sym} 0 60 0 0 {name=p5 lab=vss}
C {devices/iopin.sym} 180 -100 2 0 {name=p8 lab=b}
C {devices/iopin.sym} 280 -100 0 0 {name=p10 lab=a}
C {devices/code.sym} -270 -60 0 0 {name=MODELS
only_toplevel=false
place=header
value="
.model p1 pmos
+  level=2 vto=-0.5 kp=8.5e-6 gamma=0.4 phi=0.65 lambda=0.05 xj=0.5e-6
.model n1 nmos
+  level=2 vto=0.5 kp=24e-6 gamma=0.15 phi=0.65 lambda=0.015 xj=0.5e-6
"}
