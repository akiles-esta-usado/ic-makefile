#!/bin/bash

TOOL_FLAGS=" \
    --enable-klayout \
    --enable-magic \
    --enable-netgen \
    --enable-xschem \
    --enable-irsim=no \
    --enable-openlane=no \
    --enable-qflow=no \
    --enable-xcircuit=no \
    "

SKY130_FLAGS=" \
    --disable-sky130-pdk \
    --disable-primitive-sky130 \
    --disable-io-sky130 \
    --disable-sc-hs-sky130 \
    --disable-sc-ms-sky130 \
    --disable-sc-ls-sky130 \
    --disable-sc-lp-sky130 \
    --disable-sc-hd-sky130 \
    --disable-sc-hdll-sky130 \
    --disable-sc-hvl-sky130 \
    --disable-alpha-sky130 \
    --disable-xschem-sky130 \
    --disable-klayout-sky130 \
    --disable-precheck-sky130 \
    --disable-sram-sky130 \
    --disable-sram-space-sky130 \
    --disable-reram-sky130 \
    --disable-osu-t12-sky130 \
    --disable-osu-t15-sky130 \
    --disable-osu-t18-sky130 \
    "

GF180MCU_FLAGS=" \
    --enable-gf180mcu-pdk \
    --enable-primitive-gf180mcu \
    --enable-verification-gf180mcu \
    --enable-io-gf180mcu \
    --enable-sc-7t5v0-gf180mcu \
    --disable-sc-9t5v0-gf180mcu \
    --disable-sram-gf180mcu \
    --disable-osu-sc-gf180mcu \
    "
    # --with-gf180mcu-variants=D \

set -ex
set -u

git clone https://github.com/RTimothyEdwards/open_pdks.git || true
cd open_pdks
./configure $TOOL_FLAGS $SKY130_FLAGS $GF180MCU_FLAGS
make
sudo make install

# "make clean" to remove the files in the staging area
# "make distclean" removes the staging area, all log files, and any automatically downloaded repositories in sources/
# "make veryclean" removes the staging area and all log files.
 
make distclean

# export PDK_ROOT=/usr/local/share/pdk