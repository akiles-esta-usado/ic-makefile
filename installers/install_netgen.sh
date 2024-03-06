#!/bin/bash

set -ex
set -u

sudo pacman -Rcnsuv netgen-lvs-git || true

git clone --filter=blob:none https://github.com/RTimothyEdwards/netgen netgen || true

cd netgen
git pull

./configure CFLAGS="-O2 -g"
make clean
make -j"$(nproc)"

sudo make install