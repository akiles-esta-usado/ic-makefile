v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 780 840 1580 1240 {flags=graph,unlocked
y1=0
y2=3.3
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

color="5 6 4"
node="out
out_pex
v-sweep"

digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=dc}
B 2 1600 840 2400 1240 {flags=graph,unlocked
y1=-0.0028
y2=0.00013
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

color=5
node="\\"Difference between clean and pex; out out_pex -\\""

digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=dc}
B 2 780 0 1580 400 {flags=graph,unlocked
y1=-0.011
y2=3.5
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=1e-07
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0

color="5 4"
node="\\"out\\"
\\"out_pex\\""

digital=0
rainbow=1
dataset=0
rawfile=$netlist_dir/rawspice.raw
sim_type=tran}
B 2 780 420 1580 820 {flags=graph,unlocked
y1=-0.011
y2=3.5
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=2e-08
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0

color="7 4"
node="\\"out\\"
\\"out_pex\\""

digital=0
rainbow=0
dataset=1
rawfile=$netlist_dir/rawspice.raw
sim_type=tran}
B 2 1600 420 2400 820 {flags=graph,unlocked
y1=-1.1
y2=0.74
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=2e-08
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0

color=7
node="\\"Tran difference;out out_pex -\\""

digital=0
rainbow=0
dataset=1
rawfile=$netlist_dir/rawspice.raw
sim_type=tran}
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
lab=in}
N -30 0 -20 0 {
lab=in}
N 60 50 60 60 {
lab=vss}
N 170 -0 180 0 {
lab=out}
N 60 -60 60 -50 {
lab=vdd}
N -40 210 40 210 {
lab=GND}
C {symbol/inv_sample.sym} 80 0 0 0 {name=x1}
C {devices/vsource.sym} 40 170 0 0 {name=vvdd value=3.3 savecurrent=false}
C {devices/gnd.sym} 0 220 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 130 170 0 0 {name=vin
value="pulse(0 3.3 100p 100p 1n 4n 10n)"
savecurrent=false}
C {devices/gnd.sym} 130 200 0 0 {name=l4 lab=GND}
C {devices/lab_pin.sym} 180 0 2 0 {name=p3 sig_type=std_logic lab=out}
C {devices/lab_pin.sym} -30 0 0 0 {name=p1 sig_type=std_logic lab=in}
C {devices/code_shown.sym} 380 30 0 0 {name="tran: Pulses 100n"
only_toplevel=false
spice_ignore=0
value="
.control
save in out out_pex time

tran 0.01n 100n
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
C {devices/code_shown.sym} 380 450 0 0 {name="tran: Pulses 20n"
only_toplevel=false
spice_ignore=0
value="
.control
save in out out_pex time

tran 0.01n 20n
*plot in out out_pex

write
.endc
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
C {devices/code_shown.sym} -60 -190 0 0 {name="PEX Simulation"
spice_ignore=0
value="
*.include inv_sample_pex.spice
.include ../layout_pex/inv_sample_pex.spice
Xinv_pex  vdd out_pex vss in inv_sample_pex
"}
C {devices/vsource.sym} -40 170 0 0 {name=vvss value=0 savecurrent=false}
C {devices/lab_pin.sym} 40 120 2 0 {name=p4 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} -40 120 2 0 {name=p5 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 60 -60 2 0 {name=p6 sig_type=std_logic lab=vdd}
C {devices/lab_pin.sym} 60 60 2 0 {name=p7 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 130 120 2 0 {name=p2 sig_type=std_logic lab=in}
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
C {devices/code_shown.sym} 380 870 0 0 {name="dc: Transfer curve"
only_toplevel=false
spice_ignore=0
value="
.control
save in out out_pex

dc vin 0 3.3 0.001
*plot out vs in out_pex vs in

write
.endc
"}
