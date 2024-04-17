#!/bin/bash

set -ex
set -u

sudo pacman -Rcnsuv magic || true

git clone --filter=blob:none https://github.com/RTimothyEdwards/magic.git magic || true

cd magic
git pull

./configure
make database/database.h
make -j"$(nproc)"


sudo make install