# HDL support on ngspice simulation

This example is the same on `ngspice/examples/xspice/verilator`, just divided into different xschem schematics.

## Run example

~~~bash
# Open ccap module schematic
$ make TOP=ccap xschem

# compile the digital control
make TOP=adc HDL=adc ngspice-compile-verilog

# Open adc testbench
make TOP=adc TEST=adc_tb xschem-tb

# Only simulate the testbench, run after compile the verilog
make TOP=adc ngspice-sim
~~~
