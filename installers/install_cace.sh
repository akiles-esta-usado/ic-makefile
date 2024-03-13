#!/bin/bash

set -ex
set -u

python3 -m pip install --upgrade --break-system-packages cace

# Installation by commit
#pip install --break-system-packages git+https://github.com/efabless/cace.git@b5f39ccd7ebbd70731b4b9c2a47ed3c066151c9e