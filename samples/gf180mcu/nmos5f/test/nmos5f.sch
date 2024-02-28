v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 778.75 420 1578.75 820 {flags=graph,unlocked
y1=0.004
y2=0.014
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=3.3
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
color="5 5"
node="\\"i(vid) vs g\\"
\\"i(vid_pex) vs g\\""}
B 2 1598.75 420 2398.75 820 {flags=graph,unlocked
y1=-0.0028
y2=0.00013
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=2.50163e-08
x2=2.57542e-08
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0

color=5
node="\\"Difference between clean and pex; out out_pex -\\""

digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=dc}
B 2 780 0 1580 400 {flags=graph,unlocked
y1=-0.00012
y2=0.0017
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=3e-08
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
sim_type=tran
color="4 5"
node="i(vid_pex)
i(vid)"}
T {Template usage:

1. Each simulation should have in the title:
- Type of simulation (tran, dc, etc)
- Name of the simulation (Purpose, something like that)
2. Each simulation of set of simulations should be contained on the same control block.
3. Use Shift-S to change element processing order.
4. Graphs should use the dataset index in the same order of element processing} 970 -210 0 0 0.4 0.4 {}
T {Graph Configuration:
Each graph has 3 configurations BEFORE plotting:

1. Set rawfile
2. Signals in Graph indicates the type of simulation (dc, tran)
3. Set dataset index} 1820 -160 0 0 0.4 0.4 {}
N -40 200 -40 210 {
lab=GND}
N 40 200 40 210 {
lab=GND}
N 0 210 0 220 {
lab=GND}
N -40 100 -40 140 {
lab=vss}
N 40 100 40 140 {
lab=vdd}
N 130 100 130 140 {
lab=g}
N 10 0 20 0 {
lab=g}
N -40 210 40 210 {
lab=GND}
N 60 30 60 80 {
lab=vss}
N 60 0 80 -0 {
lab=vss}
N 130 200 130 220 {
lab=vss}
N 80 -0 80 50 {
lab=vss}
N 60 50 80 50 {
lab=vss}
N 60 -140 60 -110 {
lab=vdd}
N 60 -50 60 -30 {
lab=#net1}
C {devices/vsource.sym} 40 170 0 0 {name=vvdd value=3.3 savecurrent=false}
C {devices/gnd.sym} 0 220 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 130 170 0 0 {name=vg
value="pulse(0 3.3 50p 100p 100p 5n 10n)"
savecurrent=false}
C {devices/lab_pin.sym} 10 0 0 0 {name=p1 sig_type=std_logic lab=g}
C {devices/code_shown.sym} 380 30 0 0 {name="tran: Pulses 100n"
only_toplevel=false
spice_ignore=0
value="
.control
save g i(vid) i(vid_pex)

tran 0.01n 30n
*plot in out out_pex

write
.endc
"}
C {devices/launcher.sym} 680 -40 0 0 {name=h2
descr="Load TRAN"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath tran
"
}
C {devices/code.sym} -220 -60 0 0 {name=MODELS
only_toplevel=true
place=header
format="tcleval( @value )"
value="
.include $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/design.ngspice
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice typical
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice mimcap_statistical
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice cap_mim
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice res_typical
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice bjt_typical
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sm141064.ngspice moscap_typical
"}
C {devices/launcher.sym} 680 -140 0 0 {name=h5
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
C {devices/launcher.sym} 680 -80 0 0 {name=h1
descr="Load DC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath dc
"
}
C {devices/code_shown.sym} -60 -270 0 0 {name="PEX Simulation"
spice_ignore=0
value="
.include ../layout_pex/nmos5f_pex.spice
vid_pex vdd vdd_pex 0
.save i(vid_pex)

*     D       S   G nmos5f_pex
Xpex  vdd_pex vss g nmos5f_pex
"}
C {devices/vsource.sym} -40 170 0 0 {name=vvss value=0 savecurrent=false}
C {devices/lab_pin.sym} 40 120 2 0 {name=p4 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} -40 120 2 0 {name=p5 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 60 -140 2 0 {name=p6 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 60 80 2 0 {name=p7 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 130 120 2 0 {name=p2 sig_type=std_logic lab=g}
C {devices/code_shown.sym} 380 -120 0 0 {name="Setup testbench"
only_toplevel=false
place=header
format="tcleval( @value )"
value="
.control
write
set appendwrite
.endc

"}
C {devices/code_shown.sym} 378.75 450 0 0 {name="dc: Transfer curve"
only_toplevel=false
spice_ignore=0
value="
.control
save all

*compose voltage start=1.8 stop=3.3 step=0.5
*foreach volt $&voltage
*alterparam VGS=$volt
reset
dc vg 0 3.3 0.01
write

.endc
"}
C {devices/lab_pin.sym} 130 220 2 0 {name=p8 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 40 0 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {devices/ammeter.sym} 60 -80 0 0 {name=Vid savecurrent=true}
