#!/bin/bash

set -ex
set -u

sudo pacman -Rcnsuv xschem || true

git clone --filter=blob:none https://github.com/StefanSchippers/xschem.git xschem || true

cd xschem
git pull

./configure
make -j"$(nproc)"

sudo make install