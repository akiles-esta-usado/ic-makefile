v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 530 -280 1330 120 {flags=graph,unlocked
y1=-56
y2=34
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=12
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=1
logy=0




digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=ac
color="4 7"
node="\\"vout db20()\\"
\\"Gain 0;frequency 0 *\\""}
B 2 520 180 1320 580 {flags=graph,unlocked
y1=-61
y2=60
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=1.44812
x2=0.511571
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0




digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=dc

color="7 12"
node="\\"vout deriv0()\\"
\\"ao\\""
sweep=vout}
T {Template usage:

1. Each simulation should have in the title:
- Type of simulation (tran, dc, etc)
- Name of the simulation (Purpose, something like that)
2. Each simulation of set of simulations should be contained on the same control block.
3. Use Shift-S to change element processing order.
4. Graphs should use the dataset index in the same order of element processing} 730 -550 0 0 0.4 0.4 {}
T {Graph Configuration:
Each graph has 3 configurations BEFORE plotting:

1. Set rawfile
2. Signals in Graph indicates the type of simulation (dc, tran)
3. Set dataset index} 1580 -500 0 0 0.4 0.4 {}
N -260 -620 -260 -580 {
lab=GND}
N -340 -650 -300 -650 {
lab=g1}
N -340 -590 -260 -590 {
lab=GND}
N -460 -600 -380 -600 {
lab=ref}
N -440 -640 -380 -640 {
lab=d1}
N -440 -730 -440 -640 {
lab=d1}
N -260 -730 -260 -680 {
lab=d1}
N -440 -730 -260 -730 {
lab=d1}
N -340 -700 -340 -650 {
lab=g1}
N -260 -810 -260 -730 {
lab=d1}
N -260 -930 -260 -870 {
lab=VDD}
N -260 -770 -190 -770 {
lab=d1}
N -260 -650 -220 -650 {
lab=GND}
N -220 -650 -220 -600 {
lab=GND}
N -260 -600 -220 -600 {
lab=GND}
N 190 -620 190 -580 {
lab=GND}
N 110 -650 150 -650 {
lab=g2}
N 190 -730 190 -680 {
lab=vout}
N 190 -810 190 -730 {
lab=vout}
N 190 -930 190 -870 {
lab=VDD}
N 190 -650 230 -650 {
lab=GND}
N 230 -650 230 -600 {
lab=GND}
N 190 -600 230 -600 {
lab=GND}
N -170 -420 -170 -410 {
lab=GND}
N -110 -420 -110 -410 {
lab=GND}
N -170 -410 -110 -410 {
lab=GND}
N -140 -410 -140 -400 {
lab=GND}
N -110 -510 -110 -480 {
lab=ref}
N -40 -510 -40 -480 {
lab=g2}
N -40 -420 -40 -390 {
lab=g1}
N 110 -650 110 -610 {
lab=g2}
N 190 -770 300 -770 {
lab=vout}
N 300 -770 300 -730 {
lab=vout}
C {devices/gnd.sym} -260 -580 0 0 {name=l1 lab=GND}
C {devices/vcvs.sym} -340 -620 0 0 {name=E1 value=1000}
C {devices/isource.sym} -260 -840 0 0 {name=I0 value=224u}
C {devices/vdd.sym} -260 -930 0 0 {name=l2 lab=VDD}
C {devices/iopin.sym} -190 -770 0 0 {name=p3 lab=d1}
C {devices/gnd.sym} 190 -580 0 0 {name=l3 lab=GND}
C {devices/isource.sym} 190 -840 0 0 {name=I1 value=224u}
C {devices/vdd.sym} 190 -930 0 0 {name=l4 lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} -280 -650 0 0 {name=M1
L=0.3
W=10
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
C {sky130_fd_pr/nfet_01v8.sym} 170 -650 0 0 {name=M2
L=0.3
W=10
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
C {devices/vdd.sym} -170 -480 0 0 {name=l5 lab=VDD}
C {devices/gnd.sym} -140 -400 0 0 {name=l6 lab=GND}
C {devices/vsource.sym} -170 -450 0 0 {name=vsup value=1.8 savecurrent=false}
C {devices/vsource.sym} -110 -450 0 0 {name=vds value=0.9 savecurrent=false}
C {devices/lab_pin.sym} -110 -510 0 0 {name=p4 sig_type=std_logic lab=ref}
C {devices/code.sym} -510 -910 0 0 {name=SKY130_MODELS
only_toplevel=false
place=header
format="tcleval( @value )"
value="
*.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice tt
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice.tt.red tt
"}
C {devices/vsource.sym} -40 -450 0 0 {name=vin value="dc=0 ac=1" savecurrent=false}
C {devices/lab_pin.sym} -40 -510 0 0 {name=p7 sig_type=std_logic lab=g2}
C {devices/lab_pin.sym} -40 -390 0 0 {name=p8 sig_type=std_logic lab=g1}
C {devices/code_shown.sym} 140 -250 0 0 {name="ac: vin"
only_toplevel=false
spice_ignore=0
value="
.control

ac dec 100 1 1T
* plot vdb(vout)

write

.endc"}
C {devices/lab_pin.sym} -340 -700 0 0 {name=p2 sig_type=std_logic lab=g1}
C {devices/lab_pin.sym} 110 -610 0 0 {name=p5 sig_type=std_logic lab=g2}
C {devices/code_shown.sym} 140 190 0 0 {name="dc: vin"
only_toplevel=false
spice_ignore=0
value="
.control
save all

save @m.xm2.msky130_fd_pr__nfet_01v8[gm]
save @m.xm2.msky130_fd_pr__nfet_01v8[id]
save @m.xm2.msky130_fd_pr__nfet_01v8[gds]

dc vin -0.01 0.01 0.001

let gdsn = @m.xm2.msky130_fd_pr__nfet_01v8[gds]
let gmn = @m.xm2.msky130_fd_pr__nfet_01v8[gm]
let idn = @m.xm2.msky130_fd_pr__nfet_01v8[id]
let ao = gmn / gdsn

*plot deriv(vout) vs vout ao vs vout

write

.endc"}
C {devices/lab_pin.sym} -460 -600 0 0 {name=p1 sig_type=std_logic lab=ref}
C {devices/capa.sym} 300 -700 0 0 {name=cload
m=1
value=5p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 300 -670 0 0 {name=l7 lab=GND}
C {devices/lab_pin.sym} 300 -770 2 0 {name=p9 sig_type=std_logic lab=vout}
C {devices/launcher.sym} 440 -380 0 0 {name=h2
descr="Load TRAN"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath tran
"
}
C {devices/launcher.sym} 440 -480 0 0 {name=h5
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
C {devices/launcher.sym} 440 -420 0 0 {name=h1
descr="Load DC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath dc
"
}
C {devices/code_shown.sym} 140 -450 0 0 {name="Setup testbench"
only_toplevel=false
place=header
format="tcleval( @value )"
value="
.control
write
set appendwrite
.endc

"}
C {devices/launcher.sym} 440 -340 0 0 {name=h3
descr="Load AC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath ac
"
}
