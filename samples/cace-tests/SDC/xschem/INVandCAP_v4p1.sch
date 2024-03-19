v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 20 -50 60 -50 { lab=VIN}
N 95 -135 95 -80 { lab=VDD}
N 140 -50 220 -50 { lab=VOUT}
N 95 -20 95 70 { lab=VSS}
N 180 50 180 70 { lab=VSS}
N 95 70 180 70 { lab=VSS}
N 170 -100 170 -30 { lab=CON_CV}
N 95 70 95 125 { lab=VSS}
N 190 -80 190 -30 { lab=CON_CBASE}
N 190 -80 200 -80 { lab=CON_CBASE}
N 200 -100 200 -80 { lab=CON_CBASE}
C {INV_v1p1.sym} 20 -50 0 0 {name=XINV_OSC}
C {devices/ipin.sym} 20 -50 0 0 {name=p1 lab=VIN}
C {devices/iopin.sym} 95 -130 3 0 {name=p2 lab=VDD}
C {devices/iopin.sym} 95 120 1 0 {name=p3 lab=VSS}
C {CAPOSC_v3p1.sym} 90 10 0 0 {name=XCN}
C {devices/opin.sym} 220 -50 0 0 {name=p4 lab=VOUT}
C {devices/iopin.sym} 170 -100 3 0 {name=p5 lab=CON_CV}
C {devices/iopin.sym} 200 -100 3 0 {name=p6 lab=CON_CBASE}
