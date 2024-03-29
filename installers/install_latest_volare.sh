#!/bin/bash

set -ex
set -u

COMMIT=bdc9412b3e468c102d01b7cf6337be06ec6e9c9a

rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130*
volare enable --pdk=sky130 $COMMIT
rm -rf $PDK_ROOT/sky130B
rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130B

rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/gf180mcu*
volare enable --pdk=gf180mcu $COMMIT
rm -rf $PDK_ROOT/gf180mcuA
rm -rf $PDK_ROOT/gf180mcuB
rm -rf $PDK_ROOT/gf180mcuC
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuA
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuB
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuC
