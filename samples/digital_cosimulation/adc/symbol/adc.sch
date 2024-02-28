v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 440 -60 440 -20 {
lab=iin}
N 440 40 440 880 {
lab=test_v}
N 360 880 440 880 {
lab=test_v}
N 360 720 440 720 {
lab=test_v}
N 360 560 440 560 {
lab=test_v}
N 360 400 440 400 {
lab=test_v}
N 360 240 440 240 {
lab=test_v}
N 360 80 440 80 {
lab=test_v}
N 260 920 260 940 {
lab=vss}
N 260 760 260 780 {
lab=vss}
N 260 600 260 620 {
lab=vss}
N 260 440 260 460 {
lab=vss}
N 260 280 260 300 {
lab=vss}
N 260 120 260 140 {
lab=vss}
N 260 20 260 40 {
lab=vref}
N 260 180 260 200 {
lab=vref}
N 260 340 260 360 {
lab=vref}
N 260 500 260 520 {
lab=vref}
N 260 660 260 680 {
lab=vref}
N 260 820 260 840 {
lab=vref}
N 440 -140 440 -120 {
lab=input}
N 380 -90 400 -90 {
lab=sample}
N 380 -70 400 -70 {
lab=vref}
N 440 880 440 960 {
lab=test_v}
N 440 1020 440 1060 {
lab=vss}
C {devices/res.sym} 440 10 0 0 {name=rin
value=1k
footprint=1206
device=resistor
m=1}
C {devices/code_shown.sym} 540 -110 0 0 {name=s1 only_toplevel=false value="
* An XSPICE ADC bridge functions as a comparator.

acomp [%vd(test_v vref)] [comp] comparator
.model comparator adc_bridge in_low=0 in_high=0

* The digital portion of the circuit is specified in compiled Verilog.
* Outputs inverted to cancel the inverter in subcircuit ccap,
* and produce the correct numerical output value.

adut [ clk comp start] [sample valid ~d5 ~d4 ~d3 ~d2 ~d1 ~d0] null dut
.model dut d_cosim simulation="../../code_models/adc.so"

xsample       input iin sample vref tgate
.subckt tgate a     b   ctl    vdd
switch        a     b   ctl    0   tg
.model tg sw vt=1.5 ron=2k
.ends
"}
C {symbol/ccap.sym} 300 80 0 0 {name=xb5 c=1p}
C {devices/lab_pin.sym} 260 20 2 0 {name=p2 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 140 0 0 {name=p3 sig_type=std_logic lab=vss}
C {symbol/ccap.sym} 300 240 0 0 {name=xb4 c=\{1p/2\}}
C {devices/lab_pin.sym} 260 300 0 0 {name=p7 sig_type=std_logic lab=vss}
C {symbol/ccap.sym} 300 400 0 0 {name=xb3 c=\{1p/4\}}
C {devices/lab_pin.sym} 260 460 0 0 {name=p11 sig_type=std_logic lab=vss}
C {symbol/ccap.sym} 300 560 0 0 {name=xb2 c=\{1p/8\}}
C {devices/lab_pin.sym} 260 620 0 0 {name=p15 sig_type=std_logic lab=vss}
C {symbol/ccap.sym} 300 720 0 0 {name=xb1 c=\{1p/16\}}
C {devices/lab_pin.sym} 260 780 0 0 {name=p19 sig_type=std_logic lab=vss}
C {symbol/ccap.sym} 300 880 0 0 {name=xb0 c=\{1p/32\}}
C {devices/lab_pin.sym} 260 940 0 0 {name=p23 sig_type=std_logic lab=vss}
C {devices/capa.sym} 440 990 0 0 {name=clast
m=1
value=\{1p/32\}
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 440 1060 2 0 {name=p26 sig_type=std_logic lab=vss}
C {devices/lab_pin.sym} 440 80 2 0 {name=p27 sig_type=std_logic lab=test_v}
C {devices/lab_pin.sym} 440 -40 2 0 {name=p28 sig_type=std_logic lab=iin}
C {devices/iopin.sym} 680 300 0 0 {name=p32 lab=vss}
C {devices/iopin.sym} 680 260 0 0 {name=p34 lab=vref}
C {devices/iopin.sym} 760 260 0 0 {name=p35 lab=start}
C {devices/iopin.sym} 760 290 0 0 {name=p36 lab=valid}
C {devices/iopin.sym} 210 80 2 0 {name=p37 lab=d5}
C {devices/iopin.sym} 210 240 2 0 {name=p38 lab=d4}
C {devices/iopin.sym} 210 400 2 0 {name=p39 lab=d3}
C {devices/iopin.sym} 210 560 2 0 {name=p40 lab=d2}
C {devices/iopin.sym} 210 720 2 0 {name=p41 lab=d1}
C {devices/iopin.sym} 760 320 0 0 {name=p42 lab=clk}
C {devices/iopin.sym} 210 880 2 0 {name=p43 lab=d0}
C {devices/iopin.sym} 440 -140 0 0 {name=p5 lab=input}
C {devices/lab_pin.sym} 380 -90 0 0 {name=p13 sig_type=std_logic lab=sample}
C {devices/lab_pin.sym} 380 -70 0 0 {name=p1 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 180 2 0 {name=p4 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 340 2 0 {name=p6 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 500 2 0 {name=p8 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 660 2 0 {name=p9 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 260 820 2 0 {name=p10 sig_type=std_logic lab=vref}
C {devices/switch_ngspice.sym} 440 -90 0 0 {name=switch
spice_ignore=1
model=tg}
