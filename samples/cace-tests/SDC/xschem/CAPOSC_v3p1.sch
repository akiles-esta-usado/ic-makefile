v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 140 40 560 40 { lab=BOT}
N 140 -20 280 -20 { lab=TOP_V}
N 420 -20 560 -20 { lab=TOP_B}
N 350 40 350 80 { lab=BOT}
N 210 -60 210 -20 { lab=TOP_V}
N 490 -60 490 -20 { lab=TOP_B}
N 680 -20 820 -20 { lab=TOP_B}
N 560 40 820 40 { lab=BOT}
N 560 -20 680 -20 { lab=TOP_B}
N 820 -20 1090 -20 { lab=TOP_B}
N 820 40 1090 40 { lab=BOT}
N 1090 40 1360 40 { lab=BOT}
N 1090 -20 1360 -20 { lab=TOP_B}
N 1360 -20 1620 -20 { lab=TOP_B}
N 1360 40 1620 40 { lab=BOT}
C {sky130_fd_pr/cap_mim_m3_1.sym} 140 10 0 0 {name=C1_V model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 280 10 0 0 {name=C2_V model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 420 10 0 0 {name=C1_B model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 560 10 0 0 {name=C2_B model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {devices/iopin.sym} 210 -60 3 0 {name=p1 lab=TOP_V}
C {devices/iopin.sym} 490 -60 3 0 {name=p2 lab=TOP_B}
C {devices/iopin.sym} 350 80 1 0 {name=p3 lab=BOT}
C {sky130_fd_pr/cap_mim_m3_1.sym} 950 10 0 0 {name=C5_B model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 1090 10 0 0 {name=C6_B model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 680 10 0 0 {name=C3_B model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 820 10 0 0 {name=C4_B model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1220 10 0 0 {name=C7_B model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 1360 10 0 0 {name=C8_B model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1480 10 0 0 {name=C9_B model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {sky130_fd_pr/cap_mim_m3_2.sym} 1620 10 0 0 {name=C10_B model=cap_mim_m3_2 W=10 L=10 MF=1 spiceprefix=X}
