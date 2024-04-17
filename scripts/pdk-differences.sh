#!/bin/bash

#set -ex

OLD_COMMIT=bdc9412b3e468c102d01b7cf6337be06ec6e9c9a/
NEW_COMMIT=42cd15c469adc1d303ffca4a7d32c29a4564a737/

see_differences_gf180 () {
    OLD_PDK=$PDK_ROOT/volare/gf180mcu/versions/$OLD_COMMIT/gf180mcuD
    NEW_PDK=$PDK_ROOT/volare/gf180mcu/versions/$NEW_COMMIT/gf180mcuD
    
    # timestamp 1704896540
    MAG_TIMESTAMP_PATTERN="^timestamp.*[0-9]\+$"
    # v {xschem version=3.4.4 file_version=1.2
    XSCHEM_VERSION_PATTERN="xschem.*version=3[.][0-9].*file_version=1.2$"

    DIFF='diff -r -I $XSCHEM_VERSION_PATTERN -I $MAG_TIMESTAMP_PATTERN'
    SED='sed -e "s|$OLD_PDK/$1|OLD|" -e "s|$NEW_PDK/$1|NEW|"'

    cat > $2.md <<  EOL
# Brief sorted differences:
OLD: $OLD_PDK/$1
NEW: $NEW_PDK/$1

$(eval $DIFF -q $OLD_PDK/$1 $NEW_PDK/$1 | eval $SED | sort || true)


# Detailed differences:

$(eval $DIFF $OLD_PDK/$1 $NEW_PDK/$1 | eval $SED | grep -v "^Only in \|^Binary files " || true)
EOL
}

see_differences_sky130 () {
    OLD_PDK=$PDK_ROOT/volare/sky130/versions/$OLD_COMMIT/sky130A
    NEW_PDK=$PDK_ROOT/volare/sky130/versions/$NEW_COMMIT/sky130A
    
    # timestamp 1704896540
    MAG_TIMESTAMP_PATTERN="^timestamp.*[0-9]\+$"
    # v {xschem version=3.4.4 file_version=1.2
    XSCHEM_VERSION_PATTERN="xschem.*version=3[.][0-9].*file_version=1.2$"

    DIFF='diff -r -I $XSCHEM_VERSION_PATTERN -I $MAG_TIMESTAMP_PATTERN'
    SED='sed -e "s|$OLD_PDK/$1|OLD|" -e "s|$NEW_PDK/$1|NEW|"'

    cat > $2.md <<  EOL
# Brief sorted differences:
OLD: $OLD_PDK/$1
NEW: $NEW_PDK/$1

$(eval $DIFF -q $OLD_PDK/$1 $NEW_PDK/$1 | eval $SED | sort || true)


# Detailed differences:

$(eval $DIFF $OLD_PDK/$1 $NEW_PDK/$1 | eval $SED | grep -v "^Only in \|^Binary files " || true)
EOL
}

## SKY130 ##

sky130 () {
    see_differences_sky130 libs.ref/sky130_fd_pr/           SKY130_REF_FD_PR
    see_differences_sky130 libs.ref/sky130_fd_sc_hd/        SKY130_R-EF_SC_HD
    # see_differences_sky130 libs.ref/sky130_fd_io/           SKY130_REF_IO
    # see_differences_sky130 libs.ref/sky130_fd_sc_hvl/       SKY130_REF_SC_HVL
    # see_differences_sky130 libs.ref/sky130_ml_xx_hd/        SKY130_REF_ML_HD
    # see_differences_sky130 libs.ref/sky130_sram_macros/     SKY130_REF_SRAM

    see_differences_sky130 libs.tech/combined     SKY130_TECH_combined
    see_differences_sky130 libs.tech/magic        SKY130_TECH_magic
    see_differences_sky130 libs.tech/openlane     SKY130_TECH_openlane
    see_differences_sky130 libs.tech/xschem       SKY130_TECH_xschem
    see_differences_sky130 libs.tech/irsim        SKY130_TECH_irsim
    see_differences_sky130 libs.tech/netgen       SKY130_TECH_netgen
    see_differences_sky130 libs.tech/qflow        SKY130_TECH_qflow
    see_differences_sky130 libs.tech/klayout      SKY130_TECH_klayout
    see_differences_sky130 libs.tech/ngspice      SKY130_TECH_ngspice
    see_differences_sky130 libs.tech/xcircuit     SKY130_TECH_xcircuit
}

## GF180 ##
gf180 () {
    see_differences_gf180 libs.ref/gf180mcu_fd_io           LIBS_REF_IO
    see_differences_gf180 libs.ref/gf180mcu_fd_pr           LIBS_REF_PR
    # see_differences_gf180 libs.ref/gf180mcu_fd_sc_mcu7t5v0  LIBS_REF_MCU7T5V0
    # see_differences_gf180 libs.ref/gf180mcu_fd_ip_sram      LIBS_REF_SRAM
    # see_differences_gf180 libs.ref/gf180mcu_fd_sc_mcu9t5v0  LIBS_REF_MCU9T5V0


    see_differences_gf180 libs.tech/klayout     LIBS_TECH_KLAYOUT
    see_differences_gf180 libs.tech/netgen      LIBS_TECH_NETGEN
    see_differences_gf180 libs.tech/xschem      LIBS_TECH_XSCHEM
    see_differences_gf180 libs.tech/magic       LIBS_TECH_MAGIC
    see_differences_gf180 libs.tech/ngspice     LIBS_TECH_NGSPICE
    see_differences_gf180 libs.tech/qflow       LIBS_TECH_QFLOW
    # see_differences_gf180 libs.tech/openlane    LIBS_TECH_OPENLANE
    # see_differences_gf180 libs.tech/xyce        LIBS_TECH_XYCE

}

gf180