v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {CACE testbench transient} -1220 -660 0 0 0.6 0.6 {}
T {Drawn by R. Timothy Edwards
November 27, 2023
Template by Aquiles Viza
Open sourced under Apache 2.0 license} -730 -670 0 0 0.4 0.4 {}
N -1090 -30 -1030 -30 {
lab=GND}
N -1140 -30 -1090 -30 {
lab=GND}
N -650 -220 -650 -190 {
lab=vss}
N -650 -350 -650 -320 {
lab=vdd}
N -1030 -120 -1030 -90 {
lab=vss}
N -1120 -120 -1120 -90 {
lab=vdd}
N -500 -270 -410 -270 {
lab=out}
C {devices/vsource.sym} -1030 -60 0 0 {name=vvss value="DC \{vvss\}" savecurrent=false}
C {devices/lab_wire.sym} -1120 -110 0 1 {name=p11 sig_type=std_logic lab=vdd}
C {devices/lab_wire.sym} -1030 -110 0 1 {name=p24 sig_type=std_logic lab=vss}
C {devices/lab_wire.sym} -420 -270 0 0 {name=p25 sig_type=std_logic lab=out}
C {devices/vsource.sym} -1120 -60 0 0 {name=vvdd value="DC \{vvdd\}" savecurrent=false}
C {devices/code_shown.sym} -1220 -280 0 0 {name=CONTROL only_toplevel=false value=".control
tran 10u 50u
wrdata \{simpath\}/\{filename\}_\{N\}.data out
quit
.endc
"}
C {devices/code_shown.sym} -1220 -550 0 0 {name=SETUP
only_toplevel=false
place=header
value="
* CACE gensim simulation file \{filename\}_\{N\}
* Generated by CACE gensim, Efabless Corporation (c) 2023

.include \{DUT_path\}

*.lib \{PDK_ROOT\}/\{PDK\}/libs.tech/combined/sky130.lib.spice \{corner\}
.lib \{PDK_ROOT\}/\{PDK\}/libs.tech/ngspice/sky130.lib.spice \{corner\}

.option TEMP=\{temperature\}
.option warn=1

.ic v(x1.SENS_IN) = 0
.ic v(x1.REF_IN) = 1.8
"}
C {devices/gnd.sym} -1030 -30 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} -650 -200 2 1 {name=p3 sig_type=std_logic lab=vss}
C {devices/lab_wire.sym} -650 -340 0 1 {name=p4 sig_type=std_logic lab=vdd}
C {cace/SDC.sym} -650 -270 0 0 {name=x1}
