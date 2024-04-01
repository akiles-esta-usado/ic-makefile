v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
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
C {devices/iopin.sym} 680 300 0 0 {name=p32 lab=vss}
C {devices/iopin.sym} 680 260 0 0 {name=p34 lab=vref}
C {devices/iopin.sym} 760 260 0 0 {name=p35 lab=start}
C {devices/iopin.sym} 760 290 0 0 {name=p36 lab=valid}
C {devices/iopin.sym} 760 320 0 0 {name=p42 lab=clk}
C {devices/iopin.sym} 670 220 0 0 {name=p5 lab=input}
