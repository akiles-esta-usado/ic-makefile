v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 0 30 0 40 {
lab=xxx}
N 0 -40 0 -30 {
lab=c0}
C {sky130_fd_pr/cap_mim_m3_2.sym} 0 0 0 0 {name=C1 model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {devices/iopin.sym} 0 -40 0 0 {name=p1 lab=c0}
C {devices/iopin.sym} 0 40 0 0 {name=p2 lab=c1}
