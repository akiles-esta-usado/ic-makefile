#!/bin/bash
# Documentation: https://asco.sourceforge.net/doc/ASCO.pdf

set -ex
set -u

VERSION="0.4.11"

rm -rf ASCO-${VERSION}.tar.gz
rm -rf ASCO-${VERSION}
wget https://sourceforge.net/projects/asco/files/asco/${VERSION}/ASCO-${VERSION}.tar.gz || true
tar -xvf ASCO-${VERSION}.tar.gz

cd ASCO-${VERSION}

tar -zxvf Autotools.tar.gz
aclocal
automake -f -c -a
sh autogen.sh
./configure
make
