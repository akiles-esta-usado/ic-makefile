#!/bin/bash

set -ex
set -u

COMMIT=d8bfd6f2a19026ad9b614424c249243b670e2ab2

volare build --pdk=sky130 $COMMIT
volare enable --pdk=sky130 $COMMIT

rm -rf $PDK_ROOT/sky130B
rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130B


volare build --pdk=gf180mcu $COMMIT
volare enable --pdk=gf180mcu $COMMIT

rm -rf $PDK_ROOT/gf180mcuA
rm -rf $PDK_ROOT/gf180mcuB
rm -rf $PDK_ROOT/gf180mcuC
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuA
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuB
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuC