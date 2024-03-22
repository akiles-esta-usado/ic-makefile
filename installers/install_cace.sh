#!/bin/bash

set -ex
set -u

#python3 -m pip install --upgrade --break-system-packages cace

# Installation by commit
COMMIT=44c427a4e6f30cc8691b938f085b05ecfae1daff
pip install --break-system-packages git+https://github.com/efabless/cace.git@$COMMIT