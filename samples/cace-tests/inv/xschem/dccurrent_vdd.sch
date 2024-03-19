v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {CACE testbench dccurrent_vdd} -1220 -660 0 0 0.6 0.6 {}
T {Drawn by R. Timothy Edwards
November 27, 2023
Made template by Aquiles Viza
Open sourced under Apache 2.0 license} -1180 60 0 0 0.4 0.4 {}
N -1090 -210 -1030 -210 {
lab=VSUB}
N -1140 -210 -1090 -210 {
lab=VSUB}
N -120 -140 20 -140 {
lab=VSUB}
N -360 -150 -360 -120 {
lab=vss}
N -360 -280 -360 -250 {
lab=vdd}
N -550 -220 -510 -220 {
lab=in}
N -1030 -300 -1030 -270 {
lab=vss}
N -1030 -100 -1030 -70 {
lab=in}
N -1120 -300 -1120 -270 {
lab=vdd}
N -1120 -210 -1120 -10 {
lab=VSUB}
N -1120 -10 -870 -10 {
lab=VSUB}
N -210 -200 20 -200 {
lab=out}
C {devices/lab_pin.sym} -1140 -210 0 0 {name=p1 sig_type=std_logic lab=VSUB}
C {devices/vsource.sym} -1030 -40 0 0 {name=vin value="DC 3.3" savecurrent=false}
C {devices/vsource.sym} -1030 -240 0 0 {name=vvss value="DC 0" savecurrent=false}
C {devices/lab_wire.sym} -1120 -290 0 1 {name=p11 sig_type=std_logic lab=vdd}
C {devices/lab_wire.sym} -1030 -290 0 1 {name=p24 sig_type=std_logic lab=vss}
C {devices/lab_wire.sym} 20 -200 0 0 {name=p25 sig_type=std_logic lab=out}
C {devices/res.sym} -120 -170 0 0 {name=rout
value=\{rout\}
device=resistor}
C {devices/capa.sym} -50 -170 0 0 {name=cout
value=\{cout\}}
C {devices/lab_pin.sym} 20 -140 0 1 {name=p27 sig_type=std_logic lab=VSUB}
C {devices/vsource.sym} -1120 -240 0 0 {name=vvdd value="DC 3.3" savecurrent=false}
C {devices/code_shown.sym} -460 -540 0 0 {name=CONTROL only_toplevel=false value=".control
op
set wr_singlescale
*wrdata \{simpath\}/\{filename\}_\{N\}.data -I(vvdd)
plot -I(vvdd)
quit
.endc
"}
C {devices/code_shown.sym} -1220 -550 0 0 {name=SETUP
only_toplevel=false
place=header
value="
.include /home/designer/.volare/sky130A/libs.tech/combined/sky130.lib.spice tt

.option TEMP=27
.option warn=1
"}
C {devices/res.sym} -1030 -180 0 0 {name=RSUB
value=0.01
device=resistor}
C {devices/gnd.sym} -1030 -150 0 0 {name=l1 lab=GND}
C {inv.sym} -360 -200 0 0 {name=XDUT}
C {devices/lab_wire.sym} -1030 -90 0 1 {name=p2 sig_type=std_logic lab=in}
C {devices/lab_wire.sym} -360 -130 2 1 {name=p3 sig_type=std_logic lab=vss}
C {devices/lab_wire.sym} -360 -270 0 1 {name=p4 sig_type=std_logic lab=vdd}
C {devices/lab_wire.sym} -540 -220 0 1 {name=p5 sig_type=std_logic lab=in}
