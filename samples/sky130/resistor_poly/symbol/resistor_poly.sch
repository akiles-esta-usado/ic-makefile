v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -40 -0 -20 0 {
lab=B}
N -0 30 0 50 {
lab=r1}
N -0 -50 -0 -30 {
lab=r0}
C {sky130_fd_pr/res_iso_pw.sym} 0 0 0 0 {name=R1
rho=3050
W=180
L=30.5
model=res_iso_pw
spiceprefix=X
mult=1}
C {devices/iopin.sym} 0 -50 0 0 {name=p1 lab=r0}
C {devices/iopin.sym} 0 50 2 0 {name=p2 lab=r1}
C {devices/iopin.sym} -40 0 2 0 {name=p3 lab=b}
