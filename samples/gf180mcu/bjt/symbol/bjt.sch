v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 20 -30 110 -30 {
lab=C}
N 20 30 130 30 {
lab=E}
N 20 -110 110 -110 {
lab=C}
N 20 -50 130 -50 {
lab=E}
N 20 -190 110 -190 {
lab=C}
N 20 -130 130 -130 {
lab=E}
N 20 -270 110 -270 {
lab=C}
N 20 -210 130 -210 {
lab=E}
N 110 -270 110 -30 {
lab=C}
N 130 -210 130 30 {
lab=E}
N -20 -240 -20 -0 {
lab=B}
N 300 -30 390 -30 {
lab=C}
N 300 30 410 30 {
lab=E}
N 300 -110 390 -110 {
lab=C}
N 300 -50 410 -50 {
lab=E}
N 300 -190 390 -190 {
lab=C}
N 300 -130 410 -130 {
lab=E}
N 300 -270 390 -270 {
lab=C}
N 300 -210 410 -210 {
lab=E}
N 390 -270 390 -30 {
lab=C}
N 410 -210 410 30 {
lab=E}
N 260 -240 260 0 {
lab=B}
N 300 -350 390 -350 {
lab=C}
N 300 -290 410 -290 {
lab=E}
N 300 -430 390 -430 {
lab=C}
N 300 -370 410 -370 {
lab=E}
N 390 -430 390 -270 {
lab=C}
N 410 -370 410 -210 {
lab=E}
N 260 -400 260 -240 {
lab=B}
N 300 -400 430 -400 {
lab=S}
N 300 -320 430 -320 {
lab=S}
N 300 -240 430 -240 {
lab=S}
N 300 -160 430 -160 {
lab=S}
N 300 -80 430 -80 {
lab=S}
N 300 0 430 0 {
lab=S}
N 430 -400 430 -0 {
lab=S}
N 390 -390 430 -390 {}
N 390 -40 430 -40 {}
C {symbols/pnp_05p00x05p00.sym} 0 -80 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=1}
C {devices/iopin.sym} 0 -360 2 0 {name=p1 lab=C}
C {devices/iopin.sym} 0 -320 2 0 {name=p2 lab=E}
C {devices/iopin.sym} 0 -340 2 0 {name=p3 lab=B}
C {symbols/pnp_05p00x00p42.sym} 0 0 0 0 {name=Q2
model=pnp_05p00x00p42
spiceprefix=X
m=1}
C {symbols/pnp_10p00x00p42.sym} 0 -160 0 0 {name=Q3
model=pnp_10p00x00p42
spiceprefix=X
m=1}
C {symbols/pnp_10p00x10p00.sym} 0 -240 0 0 {name=Q4
model=pnp_10p00x10p00
spiceprefix=X
m=1}
C {symbols/npn_00p54x02p00.sym} 280 0 0 0 {name=Q5
model=npn_00p54x02p00
spiceprefix=X
m=1}
C {symbols/npn_00p54x04p00.sym} 280 -80 0 0 {name=Q6
model=npn_00p54x04p00
spiceprefix=X
m=1}
C {symbols/npn_00p54x08p00.sym} 280 -160 0 0 {name=Q7
model=npn_00p54x08p00
spiceprefix=X
m=1}
C {symbols/npn_00p54x16p00.sym} 280 -240 0 0 {name=Q8
model=npn_00p54x16p00
spiceprefix=X
m=1}
C {symbols/npn_05p00x05p00.sym} 280 -320 0 0 {name=Q9
model=npn_05p00x05p00
spiceprefix=X
m=1}
C {symbols/npn_10p00x10p00.sym} 280 -400 0 0 {name=Q10
model=npn_10p00x10p00
spiceprefix=X
m=1}
C {devices/lab_pin.sym} -20 -220 0 0 {name=p7 sig_type=std_logic lab=B}
C {devices/lab_pin.sym} 110 -260 2 0 {name=p8 sig_type=std_logic lab=C}
C {devices/lab_pin.sym} 130 -200 2 0 {name=p9 sig_type=std_logic lab=E}
C {devices/lab_pin.sym} 260 -380 0 0 {name=p4 sig_type=std_logic lab=B}
C {devices/lab_pin.sym} 390 -420 2 0 {name=p5 sig_type=std_logic lab=C}
C {devices/lab_pin.sym} 410 -360 2 0 {name=p6 sig_type=std_logic lab=E}
