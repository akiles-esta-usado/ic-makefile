v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {# * OPTION-B [5LM]
# */ MIM Capacitor (1.5fF/um2) subcircuit model for GF's 0.18 Analog CMOS process
# .subckt cap_mim_1f5_m4m5_noshield 1 2  c_length=l c_width=w dtemp=0 par=1

# */ MIM Capacitor (1fF/um2) subcircuit model for GF's 0.18 Analog CMOS process
# .subckt cap_mim_1f0_m4m5_noshield 1 2  c_length=l c_width=w dtemp=0 par=1

# */ MIM Capacitor (2fF/um2) subcircuit model for GF's 0.18 Analog CMOS process M2-M3
# .subckt cap_mim_2f0_m4m5_noshield  1 2  c_length=l  c_width=w dtemp=0 par=1

.include $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/design.ngspice
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064_mim.ngspice cap_mim_new} -220 -430 0 0 0.4 0.4 {}
N -0 -50 -0 -30 {
lab=IN2}
N 0 30 0 50 {
lab=IN2}
C {devices/iopin.sym} 0 -50 0 0 {name=p1 lab=IN2}
C {symbols/cap_mim_2f0fF.sym} 0 0 0 0 {name=C1
W=5e-6
L=5e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {devices/iopin.sym} 0 50 0 0 {name=p2 lab=IN1}
