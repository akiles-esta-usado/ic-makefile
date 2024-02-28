#!/bin/bash

TOOLS=/opt

CVC_RV_REPO_URL="https://github.com/d-m-bailey/cvc"
CVC_RV_REPO_COMMIT="v1.1.5"
CVC_RV_NAME="cvc_rv"
SDL_VIDEO_X11_VISUALID=

set -ex
set -u

REPO_COMMIT_SHORT=$(echo "$CVC_RV_REPO_COMMIT" | cut -c 1-7)

# rm -rf "${CVC_RV_NAME}"
# git clone --filter=blob:none "${CVC_RV_REPO_URL}" "${CVC_RV_NAME}"
cd "${CVC_RV_NAME}"
# git checkout "${CVC_RV_REPO_COMMIT}"
# autoreconf -vif
# ./configure --disable-nls --prefix="${TOOLS}/${CVC_RV_NAME}/${REPO_COMMIT_SHORT}"
make -j"$(nproc)"
#sudo make install


cd cvc-1.1.5



# wget https://github.com/d-m-bailey/cvc/archive/refs/tags/v1.1.5.zip