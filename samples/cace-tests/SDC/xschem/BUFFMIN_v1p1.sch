v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 35 -30 115 -30 { lab=VDD}
N 35 30 115 30 { lab=VSS}
N -25 -0 -0 -0 { lab=VIN}
N 160 -0 185 0 { lab=xxx}
N 75 -60 75 -30 { lab=VDD}
N 75 30 75 70 { lab=VSS}
C {INVMIN_v1p1.sym} -40 0 0 0 {name=X1}
C {INVMIN_v1p1.sym} 40 0 0 0 {name=X2}
C {devices/iopin.sym} 75 -50 3 0 {name=p1 lab=VDD}
C {devices/iopin.sym} 75 60 1 0 {name=p2 lab=VSS}
C {devices/ipin.sym} -25 0 0 0 {name=p3 lab=VIN}
C {devices/opin.sym} 185 0 0 0 {name=p4 lab=VOUT}
