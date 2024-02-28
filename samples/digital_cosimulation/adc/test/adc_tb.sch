v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 1060 280 1860 680 {flags=graph,unlocked
y1=0
y2=4.7
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=0.00025
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








color="5 12 10 21 7"
node="\\"xtest.sample\\"
\\"xtest.test_v\\"
\\"start/3;start 3 /\\"
\\"i(vamm)\\"
\\"input\\""}
B 2 1060 720 1860 1120 {flags=graph,unlocked
y1=0
y2=0.01
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=0.00025
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








color=16
node=\\"valid\\"}
B 2 1060 1150 1860 1550 {flags=graph,unlocked
y1=0
y2=0.01
ypos1=0
ypos2=2
divy=5
subdivy=4
unity=1
x1=0
x2=0.00025
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








color=11
node="\\"clk/2;clk 2 /\\""}
N 720 150 720 170 {
lab=vcc}
N 800 150 800 170 {
lab=Start}
N 800 270 800 290 {
lab=input}
N 240 310 240 330 {
lab=sum}
N 240 330 560 330 {
lab=sum}
N 560 310 560 330 {
lab=sum}
N 320 310 320 330 {
lab=sum}
N 400 310 400 330 {
lab=sum}
N 480 310 480 330 {
lab=sum}
N 360 330 360 350 {
lab=sum}
N 240 230 240 250 {
lab=d1}
N 320 230 320 250 {
lab=d2}
N 400 230 400 250 {
lab=d3}
N 480 230 480 250 {
lab=d4}
N 560 230 560 250 {
lab=d5}
N 160 310 160 330 {
lab=sum}
N 160 230 160 250 {
lab=d0}
N 160 330 240 330 {
lab=sum}
N 800 390 800 410 {
lab=sum}
N 650 150 650 170 {
lab=vss}
C {devices/code_shown.sym} 40 0 0 0 {name=s1 only_toplevel=false value="
.param vcc=3.3

aclock 0 clk clock
.model clock d_osc cntl_array=[-1 1] freq_array=[1Meg 1Meg]
"}
C {devices/code_shown.sym} 1060 10 0 0 {name="tran: test"
only_toplevel=false
value="
.control
*save input xtest.test_v vamm#branch clk start xtest.sample valid
save all

tran 100n 250u

plot input xtest.test_v vamm#branch clk/2 start/3 xtest.sample/3 valid
*plot input xtest.test_v vamm#branch clk start xtest.sample valid

*plot xtest.test_v
*plot vamm#branch
*plot start/3
*plot xtest.sample/3

write
.endc
"}
C {devices/vsource.sym} 720 200 0 0 {name=vcc value=\{vcc\} savecurrent=false}
C {devices/gnd.sym} 800 230 0 0 {name=l1 lab=GND}
C {devices/vsource.sym} 800 200 0 0 {name=Vpulse 
value="PULSE 0 \{vcc\} 0.2u 10n 10n 1.3u 10u"
savecurrent=false}
C {devices/vsource.sym} 800 320 0 0 {name=Vtest value="PULSE 0 3 0 200u 200u 1u 401u" savecurrent=false}
C {devices/gnd.sym} 800 350 0 0 {name=l2 lab=GND}
C {devices/gnd.sym} 720 230 0 0 {name=l3 lab=GND}
C {devices/lab_pin.sym} 720 150 0 0 {name=p1 sig_type=std_logic lab=vcc}
C {devices/lab_pin.sym} 800 270 0 0 {name=p2 sig_type=std_logic lab=input}
C {devices/lab_pin.sym} 800 150 0 0 {name=p3 sig_type=std_logic lab=Start}
C {devices/res.sym} 240 280 0 0 {name=R1
value=32
footprint=1206
device=resistor
m=1}
C {devices/res.sym} 320 280 0 0 {name=R2
value=16
footprint=1206
device=resistor
m=1}
C {devices/res.sym} 400 280 0 0 {name=R3
value=8
footprint=1206
device=resistor
m=1}
C {devices/res.sym} 480 280 0 0 {name=R4
value=4
footprint=1206
device=resistor
m=1}
C {devices/res.sym} 560 280 0 0 {name=R5
value=2
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 360 350 0 0 {name=p4 sig_type=std_logic lab=sum}
C {devices/lab_pin.sym} 240 230 0 0 {name=p5 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} 320 230 0 0 {name=p6 sig_type=std_logic lab=d2}
C {devices/lab_pin.sym} 400 230 0 0 {name=p7 sig_type=std_logic lab=d3}
C {devices/lab_pin.sym} 480 230 0 0 {name=p8 sig_type=std_logic lab=d4}
C {devices/lab_pin.sym} 560 230 0 0 {name=p9 sig_type=std_logic lab=d5}
C {devices/res.sym} 160 280 0 0 {name=R0
value=64
footprint=1206
device=resistor
m=1}
C {devices/lab_pin.sym} 160 230 0 0 {name=p10 sig_type=std_logic lab=d0}
C {devices/vsource.sym} 800 440 0 0 {name=vamm value=0 savecurrent=true}
C {devices/gnd.sym} 800 470 0 0 {name=l4 lab=GND}
C {devices/lab_pin.sym} 800 390 0 0 {name=p11 sig_type=std_logic lab=sum}
C {symbol/adc.sym} 460 -150 0 0 {name=xtest}
C {devices/lab_pin.sym} 610 -60 2 0 {name=p12 sig_type=std_logic lab=d1}
C {devices/lab_pin.sym} 610 -80 2 0 {name=p13 sig_type=std_logic lab=d2}
C {devices/lab_pin.sym} 610 -100 2 0 {name=p14 sig_type=std_logic lab=d3}
C {devices/lab_pin.sym} 610 -220 2 0 {name=p15 sig_type=std_logic lab=d4}
C {devices/lab_pin.sym} 610 -240 2 0 {name=p16 sig_type=std_logic lab=d5}
C {devices/lab_pin.sym} 610 -40 2 0 {name=p17 sig_type=std_logic lab=d0}
C {devices/lab_pin.sym} 610 -120 2 0 {name=p18 sig_type=std_logic lab=clk}
C {devices/lab_pin.sym} 610 -160 2 0 {name=p19 sig_type=std_logic lab=valid}
C {devices/lab_pin.sym} 610 -200 2 0 {name=p20 sig_type=std_logic lab=start}
C {devices/lab_pin.sym} 610 -140 2 0 {name=p21 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 610 -260 2 0 {name=p22 sig_type=std_logic lab=input}
C {devices/lab_pin.sym} 610 -180 2 0 {name=p23 sig_type=std_logic lab=vcc}
C {devices/vsource.sym} 650 200 0 0 {name=vss value=0 savecurrent=false}
C {devices/gnd.sym} 650 230 0 0 {name=l5 lab=GND}
C {devices/lab_pin.sym} 650 150 0 0 {name=p24 sig_type=std_logic lab=vss}
C {devices/code_shown.sym} 1730 -170 0 0 {name="Setup testbench"
only_toplevel=false
place=header
format="tcleval( @value )"
value="
.control
write
set appendwrite
.endc

"}
C {devices/launcher.sym} 1980 -110 0 0 {name=h1
descr="Load TRAN"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath tran
"
}
C {devices/launcher.sym} 1980 -210 0 0 {name=h5
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
C {devices/launcher.sym} 1980 -150 0 0 {name=h3
descr="Load DC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath dc
"
}
C {devices/launcher.sym} 1980 -70 0 0 {name=h4
descr="Load AC"
tclcommand="
set filepath $\{netlist_dir\}/rawspice.raw
puts $filepath

xschem raw_clear
xschem raw_read $filepath ac
"
}
