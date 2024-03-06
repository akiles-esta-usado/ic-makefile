#!/bin/bash

set -ex
set -u

sudo apt-get install autopoint

git clone --filter=blob:none https://github.com/d-m-bailey/cvc cvc_rv || true
cd cvc_rv

git pull
autoreconf -vif
./configure --disable-nls
#make clean
sudo make install
