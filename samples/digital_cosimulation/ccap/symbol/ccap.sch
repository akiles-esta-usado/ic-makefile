v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 20 -120 20 -80 {
lab=in}
N 20 -20 20 0 {
lab=tail}
N -20 -0 20 0 {
lab=tail}
N -230 -120 20 -120 {
lab=in}
C {devices/iopin.sym} -230 0 2 0 {name=p1 lab=ctl}
C {devices/iopin.sym} -230 -120 2 0 {name=p2 lab=in}
C {devices/iopin.sym} -150 -60 0 0 {name=p3 lab=vcc}
C {devices/iopin.sym} -150 60 0 0 {name=p4 lab=vss}
C {symbol/ainv.sym} -150 0 0 0 {name=xinv}
C {devices/capa.sym} 20 -50 0 0 {name=cb
m=1
value=\{c\}
footprint=1206
device="ceramic capacitor"}
C {devices/lab_pin.sym} 20 0 2 0 {name=p5 sig_type=std_logic lab=tail}
