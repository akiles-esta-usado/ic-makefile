#!/bin/bash

set -ex
set -u


SCRIPT_DIR=$PWD

# SKY130 Modifications

klayout_sky130_conf_not_modified=`grep -F '<!--' $PDK_ROOT/sky130A/libs.tech/klayout/pymacros/sky130.lym`

if [ "$klayout_sky130_conf_not_modified" != "" ]; then
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

# Criteria: Dropdown menu exists
klayout_gf180_conf_not_modified=`ls $PDK_ROOT/gf180mcuD/libs.tech/klayout/macros`

if [ "$klayout_gf180_conf_not_modified" == "" ]; then
    git clone --depth 1 https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pr.git || true
    git clone --depth 1 https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pv.git || true

    cd globalfoundries-pdk-libs-gf180mcu_fd_pr && git restore . && git pull && cd ..
    cd globalfoundries-pdk-libs-gf180mcu_fd_pv && git restore . && git pull && cd ..

    # Patch simulators
    ##################

    LIBS_TECH=$PDK_ROOT/gf180mcuD/libs.tech

    rm -rf $LIBS_TECH/ngspice
    mv globalfoundries-pdk-libs-gf180mcu_fd_pr/models/ngspice $LIBS_TECH

    rm -rf $LIBS_TECH/xyce
    mv globalfoundries-pdk-libs-gf180mcu_fd_pr/models/xyce $LIBS_TECH

    rm -rf $LIBS_TECH/xschem
    mv globalfoundries-pdk-libs-gf180mcu_fd_pr/cells/xschem $LIBS_TECH

    # Patch xschemrc
    ################

    XSCHEMRC=$LIBS_TECH/xschem/xschemrc

    # Add gf180mcuD symbols to xschem path
    ORIGINAL='append XSCHEM_LIBRARY_PATH :$env(PWD)'
    REPLACE='append XSCHEM_LIBRARY_PATH :$env(PDK_ROOT)/gf180mcuD/libs.tech/xschem'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $XSCHEMRC

    # Update 180MCU_MODELS
    ORIGINAL='set 180MCU_MODELS ${PDK_ROOT}/models/ngspice'
    REPLACE='set 180MCU_MODELS $env(PDK_ROOT)/gf180mcuD/libs.tech/ngspice'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $XSCHEMRC

    # Allow setting of symbol paths with XSCHEM_USER_LIBRARY_PATH env variable
    echo '' >> $XSCHEMRC
    echo '# open_pdks-specific' >> $XSCHEMRC
    echo 'set XSCHEM_START_WINDOW ${PDK_ROOT}/gf180mcuD/libs.tech/xschem/tests/0_top.sch' >> $XSCHEMRC
    echo 'append XSCHEM_LIBRARY_PATH :${PDK_ROOT}/gf180mcuD/libs.tech/xschem' >> $XSCHEMRC
    echo '' >> $XSCHEMRC
    echo '# allow a user-specific path add-on' >> $XSCHEMRC
    echo 'if { [info exists ::env(XSCHEM_USER_LIBRARY_PATH) ] } {' >> $XSCHEMRC
    echo '    append XSCHEM_LIBRARY_PATH :$env(XSCHEM_USER_LIBRARY_PATH)' >> $XSCHEMRC
    echo '}' >> $XSCHEMRC

    # Patch klayout
    ###############
    KLAYOUT_HOME=$PDK_ROOT/gf180mcuD/libs.tech/klayout

    # pcells
    rm -rf $KLAYOUT_HOME/pymacros
    mv globalfoundries-pdk-libs-gf180mcu_fd_pr/cells/klayout/pymacros $KLAYOUT_HOME

    rm -rf $KLAYOUT_HOME/tech/drc
    rm -rf $KLAYOUT_HOME/tech/lvs
    rm -rf $KLAYOUT_HOME/tech/gf180mcu.lym

    

    rm -rf $KLAYOUT_HOME/lvs
    mv globalfoundries-pdk-libs-gf180mcu_fd_pv/klayout/lvs $KLAYOUT_HOME

    rm -rf $KLAYOUT_HOME/drc
    mv globalfoundries-pdk-libs-gf180mcu_fd_pv/klayout/drc $KLAYOUT_HOME
    # Add precheck drc
    wget -O $KLAYOUT_HOME/drc/gf180mcuD_mr.drc https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/gf180mcuD_mr.drc

    # Add dropdown menu
    mv globalfoundries-pdk-libs-gf180mcu_fd_pr/rules/klayout/macros $KLAYOUT_HOME

    # Make D the default variant in {drc lvs}_options.yml
    FILEPATH=$KLAYOUT_HOME/macros/*_options.yml
    
    ORIGINAL='variant: C'
    REPLACE='variant: D'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    # Make D default on .lym
    FILEPATH=$KLAYOUT_HOME/macros/gf180mcu_options.lym

    ORIGINAL=';"C"'
    REPLACE=';"D"'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    ORIGINAL='], 2)'
    REPLACE='], 3)'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    # Add Gabriel Maranhao klayout colors

    wget -O $KLAYOUT_HOME/tech/gf180mcu.lyp https://raw.githubusercontent.com/ChipUSM/osic-stacks/main/stacks/chipathon-tools/scripts/gf180mcu.lyp
fi