v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {It should be B (base), not G.
Just to avoid possible problems} -110 80 0 0 0.4 0.4 {}
N -40 0 -20 0 {
lab=B}
N 20 -50 20 -30 {
lab=C}
N 20 30 20 50 {
lab=E}
C {symbols/pnp_05p00x05p00.sym} 0 0 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=1}
C {devices/iopin.sym} 20 -50 0 0 {name=p1 lab=C}
C {devices/iopin.sym} 20 50 0 0 {name=p2 lab=E}
C {devices/iopin.sym} -40 0 2 0 {name=p3 lab=G}
