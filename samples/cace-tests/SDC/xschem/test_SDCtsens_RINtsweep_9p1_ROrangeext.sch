v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 210 60 210 80 { lab=GND}
N 210 -50 210 0 { lab=VDD}
N 820 -70 820 -30 { lab=VDD}
N 960 90 1050 90 { lab=DOUT}
N 210 280 210 300 { lab=GND}
N 210 170 210 220 { lab=VSS}
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
C {devices/vsource.sym} 210 30 0 0 {name=V1 value=VDD}
C {devices/gnd.sym} 210 80 0 0 {name=l2 lab=GND}
C {devices/code_shown.sym} 190 -520 0 0 {name=SPICE
only_toplevel=false
spice_ignore=0
value="
.param VDD = 1.8
.ic v(SENS_IN) = 0
.ic v(REF_IN) = 1.8
.option temp = 0
.save v(DOUT)
.control
  run
*compose vin_var start=1.9p stop=2.11p step=0.02p
*compose vin_var start=8p stop=8.31p step=0.02p
*compose vin_var start=0.15p stop=0.15p step=0.02p
compose vin_var start=2.05k stop=2.05k step=0.02k
foreach val $&vin_var
  alter R_SENS $val
  tran 0.1n 20u
*  tran 0.1n 50u
end
*plot tran1.v(N2) tran2.v(N2) tran3.v(N2) tran4.v(N2) tran5.v(N2) tran6.v(N2) tran7.v(N2) tran8.v(N2) tran9.v(N2) tran10.v(N2) tran11.v(N2)
*wrdata ringosc_CINsweep_v2p1_Creal.txt tran1.v(N2) tran2.v(N2) tran3.v(N2) tran4.v(N2) tran5.v(N2) tran6.v(N2) tran7.v(N2) tran8.v(N2) tran9.v(N2) tran10.v(N2) tran11.v(N2)
*wrdata SDC_CINsweep_v5p7.txt tran1.v(DOUT) tran2.v(DOUT) tran3.v(DOUT) tran4.v(DOUT) tran5.v(DOUT) tran6.v(DOUT) tran7.v(DOUT) tran8.v(DOUT) tran9.v(DOUT) tran10.v(DOUT) tran11.v(DOUT) tran12.v(DOUT) tran13.v(DOUT) tran14.v(DOUT) tran15.v(DOUT) tran16.v(DOUT)
*wrdata SDC_RINsweep_v2p1_CLOAD.txt tran1.v(DOUT_CLOAD) tran2.v(DOUT_CLOAD) tran3.v(DOUT_CLOAD) tran4.v(DOUT_CLOAD) tran5.v(DOUT_CLOAD) tran6.v(DOUT_CLOAD) tran7.v(DOUT_CLOAD) tran8.v(DOUT_CLOAD) tran9.v(DOUT_CLOAD) tran10.v(DOUT_CLOAD) tran11.v(DOUT_CLOAD) tran12.v(DOUT_CLOAD) tran13.v(DOUT_CLOAD) tran14.v(DOUT_CLOAD) tran15.v(DOUT_CLOAD) tran16.v(DOUT_CLOAD)
*wrdata SDC_CINsweep_v5p7_CLOAD.txt tran1.v(DOUT_CLOAD)
wrdata SDC_RINsweep_v9p1_CLOAD_t0.txt tran1.v(DOUT)

plot dout
.endc"}
C {devices/lab_pin.sym} 610 70 3 0 {name=l5 sig_type=std_logic lab=SENS_IN}
C {devices/lab_pin.sym} 210 -50 0 0 {name=l6 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 820 -70 0 0 {name=l14 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 995 90 1 0 {name=l18 sig_type=std_logic lab=DOUT}
C {devices/vsource.sym} 210 250 0 0 {name=V2 value=0}
C {devices/gnd.sym} 210 300 0 0 {name=l23 lab=GND}
C {devices/lab_pin.sym} 210 170 0 0 {name=l24 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 820 250 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 620 190 3 0 {name=l9 sig_type=std_logic lab=REF_IN}
C {SDC.sym} 600 50 0 0 {name=X1}
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
C {devices/code.sym} 1140 -470 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
*.lib $::SKYWATER_MODELS/sky130.lib.spice tt
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/combined/sky130.lib.spice tt

"
spice_ignore=false}
C {devices/code_shown.sym} 1070 -110 0 0 {name=SPICE1
only_toplevel=false
spice_ignore=1
value="
.param VDD = 1.8
.ic v(SENS_IN) = 0
.ic v(REF_IN) = 1.8
.option temp = 0
.save v(DOUT)
.control
compose vin_var start=2.05k stop=2.05k step=0.02k
foreach val $&vin_var
  alter R_SENS $val
  tran 0.1n 50u
end
wrdata SDC_RINsweep_v9p1_CLOAD_t0.txt tran1.v(DOUT)

plot dout
.endc"}
