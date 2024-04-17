#!/bin/bash

set -ex
set -u

#python3 -m pip install --upgrade --break-system-packages cace

# Installation by commit
COMMIT=60350f572c9a773e4e2e3e3e77d984e7c1d03d37
pip install --break-system-packages git+https://github.com/efabless/cace.git@$COMMIT