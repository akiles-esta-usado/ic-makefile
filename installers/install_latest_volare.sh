#!/bin/bash

set -ex
set -u

COMMIT=bdc9412b3e468c102d01b7cf6337be06ec6e9c9a

rm -rf $PDK_ROOT/sky130A # Remove current installation
rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130A # Remove current installation
volare enable --pdk=sky130 $COMMIT
rm -rf $PDK_ROOT/sky130B
rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130B

# rm -rf $PDK_ROOT/gf180mcuD # Remove current installation
# rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/gf180mcuD # Remove current installation
# volare enable --pdk=gf180mcu $COMMIT
# rm -rf $PDK_ROOT/gf180mcuA
# rm -rf $PDK_ROOT/gf180mcuB
# rm -rf $PDK_ROOT/gf180mcuC
# rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuA
# rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuB
# rm -rf $PDK_ROOT/volare/gf180mcu/versions/$COMMIT/gf180mcuC



SCRIPT_DIR=$PWD

# SKY130 Modifications

klayout_conf_not_modified=`grep -F '<!--' $PDK_ROOT/sky130A/libs.tech/klayout/pymacros/sky130.lym`

if [ "$klayout_conf_not_modified" != "" ]; then
    KLAYOUT_HOME=$PDK_ROOT/sky130A/libs.tech/klayout

    # Fixing .lyt file

    sed -i 's/>sky130</>sky130A</g' $KLAYOUT_HOME/tech/sky130A.lyt
    sed -i 's/sky130.lyp/sky130A.lyp/g' $KLAYOUT_HOME/tech/sky130A.lyt
    sed -i '/<base-path>/c\ <base-path/>' $KLAYOUT_HOME/tech/sky130A.lyt
    sed -i '/<original-base-path>/c\ <original-base-path>$PDK_ROOT/$PDK/libs.tech/klayout</original-base-path>' $KLAYOUT_HOME/tech/sky130A.lyt

    # Fix lym file

    sed -i '1,16d' $KLAYOUT_HOME/pymacros/sky130.lym

    # Klayout PCELL fixing for gdsfactory==7.3.0

    sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/via_generator.py
    sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/draw_fet.py
    sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/layers_def.py
    sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/res_metal_child.py

    # Adding reduced models to speed ngspice simulations

    cd "$PDK_ROOT/sky130A/libs.tech/ngspice" || exit 1

    wget https://raw.githubusercontent.com/iic-jku/osic-multitool/main/iic-spice-model-red.py
    chmod +x iic-spice-model-red.py

    ./iic-spice-model-red.py sky130.lib.spice tt
    ./iic-spice-model-red.py sky130.lib.spice ss
    ./iic-spice-model-red.py sky130.lib.spice ff

    rm -rf iic-spice-model-red.py

    cd "$SCRIPT_DIR"

    # Adding precheck drc for klayout

    wget -O $KLAYOUT_HOME/drc/sky130A_mr.drc https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/sky130A_mr.drc
fi

# GF180MCU Modifications