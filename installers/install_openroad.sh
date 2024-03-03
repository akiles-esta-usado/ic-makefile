#!/bin/bash

set -ex
set -u

git clone --recursive --filter=blob:none https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts || true
cd OpenROAD-flow-scripts
sudo ./setup.sh

./build_openroad.sh --local

source ./env.sh
yosys -help
openroad -help
cd flow
make

make gui_final