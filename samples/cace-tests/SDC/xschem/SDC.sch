v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 820 -70 820 -30 { lab=VDD}
N 960 90 1050 90 { lab=DOUT}
N 820 210 820 250 { lab=VSS}
N 570 70 660 70 { lab=SENS_IN}
N 620 190 660 190 { lab=REF_IN}
N 550 190 620 190 { lab=REF_IN}
N 570 -20 720 -20 { lab=#net1}
N 550 270 720 270 { lab=#net2}
N 720 240 720 270 { lab=#net2}
N 570 50 570 70 { lab=SENS_IN}
N 530 20 550 20 { lab=SENS_IN}
N 530 20 530 60 { lab=SENS_IN}
N 530 60 570 60 { lab=SENS_IN}
N 570 -20 570 -10 { lab=#net1}
N 550 170 550 190 { lab=REF_IN}
N 510 140 530 140 { lab=REF_IN}
N 510 140 510 180 { lab=REF_IN}
N 510 180 550 180 { lab=REF_IN}
N 480 270 550 270 { lab=#net2}
N 390 110 390 270 { lab=#net2}
N 480 110 550 110 { lab=#net2}
N 390 270 480 270 { lab=#net2}
N 390 110 480 110 { lab=#net2}
C {devices/lab_pin.sym} 610 70 3 0 {name=l5 sig_type=std_logic lab=SENS_IN}
C {devices/lab_pin.sym} 820 -70 0 0 {name=l14 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 995 90 1 0 {name=l18 sig_type=std_logic lab=DOUT}
C {devices/lab_pin.sym} 820 250 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 620 190 3 0 {name=l9 sig_type=std_logic lab=REF_IN}
C {INTERNAL_SDC.sym} 600 50 0 0 {name=X1}
C {sky130_fd_pr/res_high_po_5p73.sym} 550 140 0 0 {name=R1
W=5.73
L=8
model=res_high_po_5p73
spiceprefix=X
mult=1}
C {sky130_fd_pr/res_iso_pw.sym} 570 20 0 0 {name=R3
rho=3050
W=180
L=30.5
model=res_iso_pw
spiceprefix=X
mult=1}
C {devices/iopin.sym} 610 -160 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} 610 -130 0 0 {name=p3 lab=VSS}
C {devices/opin.sym} 840 -160 0 0 {name=p5 lab=DOUT}
