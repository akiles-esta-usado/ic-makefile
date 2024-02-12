#!/bin/bash

TOOLS=/opt

XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem.git"
XSCHEM_NAME="xschem"

set -ex
set -u

sudo pacman -Rcnsuv xschem || true

#rm -rf "${XSCHEM_NAME}"
git clone --filter=blob:none "${XSCHEM_REPO_URL}" "${XSCHEM_NAME}" || true

cd "${XSCHEM_NAME}"
git pull

./configure
make -j"$(nproc)"

sudo make install