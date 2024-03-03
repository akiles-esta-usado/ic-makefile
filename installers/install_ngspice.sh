#!/bin/bash

# This is the installation on iic-osic-tools
# https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/images/ngspice/scripts/install.sh


# Compile options

TOOL_COMPILE_OPTS=(
    "--disable-debug"
    "--enable-openmp"
    "--with-x"
    "--with-readline=yes"
    "--enable-pss"
    "--enable-xspice"
    # --enable-cider
    "--with-fftw3=yes"
    "--enable-osdi"
    "--enable-klu"
)

set -ex
set -u

# Get data

git clone git://git.code.sf.net/p/ngspice/ngspice || true
cd ngspice
# git checkout pre-master
git pull

# Configure compilation

./autogen.sh
#FIXME 2nd run of autogen needed
./autogen.sh

# Executable

./configure ${TOOL_COMPILE_OPTS[@]} CFLAGS="-m64 -O2" LDFLAGS="-m64 -s"
make -j"$(nproc)"
sudo make install

make distclean

# Shared lib

# ./configure ${TOOL_COMPILE_OPTS[@]} CFLAGS="-m64 -O2" LDFLAGS="-m64 -s" --with-ngshared
# make -j"$(nproc)"
# make install

make distclean