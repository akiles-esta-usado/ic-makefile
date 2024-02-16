#!/bin/bash

#set -ex

OLD_COMMIT=cd1748bb197f9b7af62a54507de6624e30363943
NEW_COMMIT=bdc9412b3e468c102d01b7cf6337be06ec6e9c9a

see_differences () {
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

see_differences libs.ref/gf180mcu_fd_io           LIBS_REF_IO
see_differences libs.ref/gf180mcu_fd_sc_mcu7t5v0  LIBS_REF_MCU7T5V0
see_differences libs.ref/gf180mcu_fd_ip_sram      LIBS_REF_SRAM
see_differences libs.ref/gf180mcu_fd_sc_mcu9t5v0  LIBS_REF_MCU9T5V0
see_differences libs.ref/gf180mcu_fd_pr           LIBS_REF_PR


see_differences libs.tech/klayout     LIBS_TECH_KLAYOUT
see_differences libs.tech/netgen      LIBS_TECH_NETGEN
see_differences libs.tech/openlane    LIBS_TECH_OPENLANE
see_differences libs.tech/xschem      LIBS_TECH_XSCHEM
see_differences libs.tech/magic       LIBS_TECH_MAGIC
see_differences libs.tech/ngspice     LIBS_TECH_NGSPICE
see_differences libs.tech/qflow       LIBS_TECH_QFLOW
see_differences libs.tech/xyce        LIBS_TECH_XYCE