v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 130 40 130 90 { lab=NDIFF}
N 130 10 160 10 { lab=VDD}
N 130 120 160 120 { lab=GND}
N 160 120 160 170 { lab=GND}
N 130 170 160 170 { lab=GND}
N 130 150 130 170 { lab=GND}
N 130 -110 160 -110 { lab=VDD}
N 160 -160 160 -110 { lab=VDD}
N 130 -160 160 -160 { lab=VDD}
N 130 -160 130 -140 { lab=VDD}
N 160 -110 160 10 { lab=VDD}
N 130 -80 130 -20 { lab=#net1}
N 370 40 370 90 { lab=PDIFF}
N 370 10 400 10 { lab=VDD}
N 370 120 400 120 { lab=GND}
N 400 120 400 170 { lab=GND}
N 370 170 400 170 { lab=GND}
N 370 150 370 170 { lab=GND}
N 370 -110 400 -110 { lab=VDD}
N 400 -160 400 -110 { lab=VDD}
N 370 -160 400 -160 { lab=VDD}
N 370 -160 370 -140 { lab=VDD}
N 400 -110 400 10 { lab=VDD}
N 370 -80 370 -20 { lab=#net2}
N 0 -110 0 120 { lab=IN}
N 60 10 90 10 { lab=CLK}
N 300 10 330 10 { lab=CLK}
N 160 -160 370 -160 { lab=VDD}
N 240 -110 240 120 { lab=NDIFF}
N 0 -110 90 -110 { lab=IN}
N -0 120 90 120 { lab=IN}
N 240 -110 330 -110 { lab=NDIFF}
N 240 120 330 120 { lab=NDIFF}
N 550 120 580 120 { lab=GND}
N 580 120 580 170 { lab=GND}
N 550 170 580 170 { lab=GND}
N 550 150 550 170 { lab=GND}
N 160 170 370 170 { lab=GND}
N 400 170 550 170 { lab=GND}
N 480 120 510 120 { lab=CLK}
N 550 10 580 10 { lab=GND}
N 550 40 550 90 { lab=#net3}
N 580 10 580 120 { lab=GND}
N 130 70 240 70 { lab=NDIFF}
N 370 70 480 70 { lab=PDIFF}
N 480 10 480 70 { lab=PDIFF}
N 480 10 510 10 { lab=PDIFF}
N 940 -80 940 -30 { lab=D}
N 940 -110 970 -110 { lab=VDD}
N 940 0 970 0 { lab=GND}
N 970 0 970 50 { lab=GND}
N 940 50 970 50 { lab=GND}
N 940 30 940 50 { lab=GND}
N 720 30 720 50 { lab=GND}
N 690 50 720 50 { lab=GND}
N 690 0 690 50 { lab=GND}
N 690 0 720 0 { lab=GND}
N 720 -80 720 -30 { lab=ND}
N 970 -160 970 -110 { lab=VDD}
N 940 -160 970 -160 { lab=VDD}
N 940 -160 940 -140 { lab=VDD}
N 690 -110 730 -110 { lab=VDD}
N 690 -160 690 -110 { lab=VDD}
N 690 -160 720 -160 { lab=VDD}
N 720 -160 720 -140 { lab=VDD}
N 720 50 940 50 { lab=GND}
N 760 -110 760 0 { lab=D}
N 900 -110 900 0 { lab=ND}
N 720 -40 900 -40 { lab=ND}
N 760 -70 940 -70 { lab=D}
N 550 -60 550 -20 { lab=ND}
N 550 -60 720 -60 { lab=ND}
N 940 -50 1110 -50 { lab=D}
N 1110 -50 1110 -20 { lab=D}
N 1110 40 1110 90 { lab=#net4}
N 400 -160 690 -160 { lab=VDD}
N 720 -160 940 -160 { lab=VDD}
N 830 50 830 170 { lab=GND}
N 1150 10 1180 10 { lab=NDIFF}
N 1080 10 1110 10 { lab=GND}
N 1080 10 1080 120 { lab=GND}
N 580 170 830 170 { lab=GND}
N 1080 120 1110 120 { lab=GND}
N 1110 150 1110 170 { lab=GND}
N 830 170 1110 170 { lab=GND}
N 1080 120 1080 170 { lab=GND}
N 1150 120 1180 120 { lab=CLK}
C {sky130_fd_pr/nfet_01v8.sym} 110 120 0 0 {name=MN_NIN
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 110 10 0 0 {name=MP_NINCLK
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 110 -110 0 0 {name=MP_NIN
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 350 120 0 0 {name=MN_NIN1
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 350 10 0 0 {name=MP_NINCLK1
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 350 -110 0 0 {name=MP_NIN1
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 0 0 0 0 {name=l1 sig_type=std_logic lab=IN}
C {devices/lab_pin.sym} 220 70 1 0 {name=l2 sig_type=std_logic lab=NDIFF}
C {devices/lab_pin.sym} 60 10 0 0 {name=l3 sig_type=std_logic lab=CLK}
C {devices/lab_pin.sym} 300 10 0 0 {name=l4 sig_type=std_logic lab=CLK}
C {sky130_fd_pr/nfet_01v8.sym} 530 120 0 0 {name=MN_NIN2
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 480 120 0 0 {name=l5 sig_type=std_logic lab=CLK}
C {sky130_fd_pr/nfet_01v8.sym} 530 10 0 0 {name=MN_POUTT
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 460 70 1 0 {name=l6 sig_type=std_logic lab=PDIFF}
C {sky130_fd_pr/nfet_01v8.sym} 1130 10 0 1 {name=MN_POUTT1
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 920 0 0 0 {name=MN_POUTT2
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 920 -110 0 0 {name=MP_NIN2
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 740 0 0 1 {name=MN_POUTT3
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 740 -110 0 1 {name=MP_NIN3
L=0.15
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 1180 10 2 0 {name=l8 sig_type=std_logic lab=NDIFF}
C {devices/lab_pin.sym} 550 -60 1 0 {name=l9 sig_type=std_logic lab=ND}
C {devices/lab_pin.sym} 1110 -50 1 0 {name=l10 sig_type=std_logic lab=D}
C {devices/ipin.sym} 430 -240 0 0 {name=p1 lab=IN}
C {devices/ipin.sym} 430 -210 0 0 {name=p2 lab=CLK}
C {devices/lab_pin.sym} 130 -160 0 0 {name=l11 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 130 170 0 0 {name=l12 sig_type=std_logic lab=GND}
C {devices/iopin.sym} 490 -240 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} 490 -210 0 0 {name=p4 lab=GND}
C {devices/opin.sym} 600 -240 0 0 {name=p5 lab=ND}
C {devices/opin.sym} 600 -210 0 0 {name=p6 lab=D}
C {sky130_fd_pr/nfet_01v8.sym} 1130 120 0 1 {name=MN_NIN3
L=0.15
W=1
nf=1 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/lab_pin.sym} 1180 120 0 1 {name=l7 sig_type=std_logic lab=CLK}
