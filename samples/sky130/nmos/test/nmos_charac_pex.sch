v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 580 -330 1380 70 {flags=graph,unlocked
y1=-1.8e-19
y2=0.0033
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
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





color="4 4"
node="\\"ids1;i(vids1)\\"
\\"ids2;i(vids2)\\""
}
B 2 1400 -330 2200 70 {flags=graph,unlocked
y1=-22
y2=-5.7
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0.001
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






color="4 4"
node="\\"i(vids1) ln()\\"
\\"i(vids2) ln()\\""}
B 2 580 180 1380 580 {flags=graph,unlocked
y1=-1.1e-14
y2=0.00023
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=1.8
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0




digital=0
rainbow=0

rawfile=$netlist_dir/rawspice.raw
sim_type=dc





color=4
node="\\"ids1 - ids2;i(vids1) i(vids2) -\\""
}
B 2 1420 180 2220 580 {flags=graph,unlocked
y1=-0.0043
y2=0.17
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1

x2=1.8
divx=5
subdivx=4
xlabmag=1.0
ylabmag=1.0



unitx=1
logx=0
logy=0




digital=0
rainbow=0

rawfile=$netlist_dir/rawspice.raw
sim_type=dc





color=4
node="\\"ln(ids1) - ln(ids2);i(vids1) ln() i(vids2) ln() -\\""
x1=0.001}
N -280 -130 -230 -130 {
lab=g1}
N -190 -60 -190 0 {
lab=GND}
N -190 -130 -110 -130 {
lab=GND}
N -110 -130 -110 -60 {
lab=GND}
N -190 -60 -110 -60 {
lab=GND}
N -190 -300 -190 -170 {
lab=#net1}
N -190 -100 -190 -60 {
lab=GND}
N -190 -170 -190 -160 {
lab=#net1}
N -400 -230 -400 -220 {
lab=GND}
N -340 -230 -340 -220 {
lab=GND}
N -400 -220 -340 -220 {
lab=GND}
N -370 -220 -370 -210 {
lab=GND}
N -340 -320 -340 -290 {
lab=d1}
N -400 -320 -400 -290 {
lab=g1}
C {devices/ipin.sym} -280 -130 0 0 {name=p1 lab=g1}
C {devices/iopin.sym} -190 -360 0 0 {name=p2 lab=d1}
C {devices/gnd.sym} -190 0 0 0 {name=l3 lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} -210 -130 0 0 {name=M1
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
C {devices/gnd.sym} -370 -210 0 0 {name=l6 lab=GND}
C {devices/vsource.sym} -400 -260 0 0 {name=vgs value=0.9 savecurrent=false}
C {devices/vsource.sym} -340 -260 0 0 {name=vds value=0.9 savecurrent=false}
C {devices/lab_pin.sym} -340 -320 0 0 {name=p4 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} -400 -320 0 0 {name=p3 sig_type=std_logic lab=g1}
C {devices/code.sym} -410 -490 0 0 {name=SKY130_MODELS
only_toplevel=false
place=header
format="tcleval( @value )"
value="
*.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice tt
.lib $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice/sky130.lib.spice.tt.red tt
"}
C {devices/code_shown.sym} 100 -220 0 0 {name="dc: voltage transference curve"
only_toplevel=true
spice_ignore=0
value="
.control
save @m.xm1.msky130_fd_pr__nfet_01v8[id]
dc vds 0 1.8 0.01 vgs 0.3 1.8 0.5
let id=@m.xm1.msky130_fd_pr__nfet_01v8[id]

plot id

save id

write

.endc
" }
C {devices/launcher.sym} 430 -330 0 0 {name=h2
descr="Load TRAN"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath tran
"
}
C {devices/launcher.sym} 430 -430 0 0 {name=h5
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
C {devices/launcher.sym} 430 -370 0 0 {name=h1
descr="Load DC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath dc
"
}
C {devices/launcher.sym} 430 -290 0 0 {name=h3
descr="Load AC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath ac
"
}
C {devices/code_shown.sym} 50 -450 0 0 {name="Setup testbench"
only_toplevel=false
place=header
format="tcleval( @value )"
value="
.control
write
set appendwrite
.endc

"}
C {devices/code_shown.sym} -60 60 0 0 {name="Extracted devices"
only_toplevel=false
value="
.include ../layout_pex/nmos_pex.spice
xpex g1 dpex GND nmos_pex
"
}
C {devices/ammeter.sym} -190 -330 0 0 {name=vids1 savecurrent=true}
C {devices/iopin.sym} -90 -360 0 0 {name=p5 lab=d1}
C {devices/ammeter.sym} -90 -330 0 0 {name=vids2 savecurrent=true}
C {devices/iopin.sym} -90 -300 0 0 {name=p6 lab=dpex}
