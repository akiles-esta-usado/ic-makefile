#!/bin/bash

set -ex
set -u

#python3 -m pip install --upgrade --break-system-packages cace

# Installation by commit
COMMIT=188d784acc3a3761d5938e6d81bf79de008422d7
pip install --break-system-packages git+https://github.com/efabless/cace.git@$COMMIT