v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 440 270 440 290 { lab=GND}
N 440 160 440 210 { lab=VDD}
N 810 0 810 40 { lab=VDD}
N 960 90 1050 90 { lab=DOUT}
N 540 160 540 210 { lab=VSS}
N 810 140 810 180 { lab=VSS}
N 440 270 540 270 {
lab=GND}
C {devices/vsource.sym} 440 240 0 0 {name=V1 value=1.8}
C {devices/gnd.sym} 440 290 0 0 {name=l2 lab=GND}
C {devices/lab_pin.sym} 440 160 0 0 {name=l6 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 810 0 0 0 {name=l14 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 995 90 1 0 {name=l18 sig_type=std_logic lab=DOUT}
C {devices/vsource.sym} 540 240 0 0 {name=V2 value=0}
C {devices/lab_pin.sym} 540 160 0 0 {name=l24 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 810 180 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {SDC.sym} 810 90 0 0 {name=X1}
C {devices/code.sym} 420 -20 0 0 {name=TT_MODELS
only_toplevel=true
spice_ignore=0
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice.tt.red tt
*.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/combined/sky130.lib.spice tt
"}
C {devices/code_shown.sym} 1080 40 0 0 {name=Transient
only_toplevel=false
spice_ignore=0
value="
.control
tran 10u 20u
plot dout
wrdata data.txt dout
.endc"}
C {devices/code_shown.sym} 660 240 0 0 {name=OPTIONS
only_toplevel=false
spice_ignore=0
value="
.option TEMP=130
.option warn=1

.ic v(x1.SENS_IN) = 0
.ic v(x1.REF_IN) = 1.8
"}
