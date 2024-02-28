v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 360 -610 1160 -210 {flags=graph,unlocked
y1=0
y2=40
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0.2
x2=1.8
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0




digital=0
rainbow=1

rawfile=$netlist_dir/rawspice.raw
sim_type=dc

color=7
node="\\"abs(1/deriv(v(g1))); 1 g1 deriv() / abs()\\""
}
N -110 -480 -110 -440 {
lab=GND}
N -190 -510 -150 -510 {
lab=g1}
N -190 -450 -110 -450 {
lab=GND}
N -310 -460 -230 -460 {
lab=ref}
N -290 -500 -230 -500 {
lab=d1}
N -290 -590 -290 -500 {
lab=d1}
N -110 -590 -110 -540 {
lab=d1}
N -290 -590 -110 -590 {
lab=d1}
N -190 -560 -190 -510 {
lab=g1}
N -110 -670 -110 -590 {
lab=d1}
N -110 -790 -110 -730 {
lab=VDD}
N -110 -630 -40 -630 {
lab=d1}
N -110 -510 -70 -510 {
lab=GND}
N -70 -510 -70 -460 {
lab=GND}
N -110 -460 -70 -460 {
lab=GND}
N -280 -230 -280 -220 {
lab=GND}
N -220 -230 -220 -220 {
lab=GND}
N -280 -220 -220 -220 {
lab=GND}
N -250 -220 -250 -210 {
lab=GND}
N -220 -320 -220 -290 {
lab=ref}
C {devices/gnd.sym} -110 -440 0 0 {name=l1 lab=GND}
C {devices/vcvs.sym} -190 -480 0 0 {name=E1 value=1000}
C {devices/ipin.sym} -310 -460 0 0 {name=p1 lab=ref}
C {devices/iopin.sym} -190 -560 0 0 {name=p2 lab=g1}
C {devices/isource.sym} -110 -700 0 0 {name=I0 value=1m}
C {devices/vdd.sym} -110 -790 0 0 {name=l2 lab=VDD}
C {devices/iopin.sym} -40 -630 0 0 {name=p3 lab=d1}
C {devices/code_shown.sym} 70 -590 0 0 {name="dc: intrinsic gain gm"
only_toplevel=false 
value="
.control
save all

dc vds 0.2 1.8 0.01
*plot abs(1/deriv(v(g1)))

write

.endc
"}
C {sky130_fd_pr/nfet_01v8.sym} -130 -510 0 0 {name=M1
L=0.15
W=40
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
C {devices/code.sym} -350 -780 0 0 {name=SKY130_MODELS
only_toplevel=false
place=header
format="tcleval( @value )"
value="
*.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice tt
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice.tt.red tt
"}
C {devices/vdd.sym} -280 -290 0 0 {name=l5 lab=VDD}
C {devices/gnd.sym} -250 -210 0 0 {name=l6 lab=GND}
C {devices/vsource.sym} -280 -260 0 0 {name=vsup value=1.8 savecurrent=false}
C {devices/vsource.sym} -220 -260 0 0 {name=vds value=0.9 savecurrent=false}
C {devices/lab_pin.sym} -220 -320 0 0 {name=p4 sig_type=std_logic lab=ref}
C {devices/code_shown.sym} 60 -750 0 0 {name="Setup testbench"
only_toplevel=false
place=header
format="tcleval( @value )"
value="
.control
write
set appendwrite
.endc

"}
C {devices/launcher.sym} 330 -780 0 0 {name=h2
descr="Load TRAN"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath tran
"
}
C {devices/launcher.sym} 330 -880 0 0 {name=h5
descr="Load ALL 3.4.5+"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw

puts $filepath

xschem raw clear
xschem raw read $filepath tran
xschem redraw
xschem raw read $filepath dc
xschem redraw
"}
C {devices/launcher.sym} 330 -820 0 0 {name=h1
descr="Load DC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath dc
"
}
C {devices/launcher.sym} 330 -740 0 0 {name=h3
descr="Load AC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath ac
"
}
