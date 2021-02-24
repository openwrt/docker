#!/bin/bash

set -ex

. ./functions.sh

export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-imagebuilder}"
export DOWNLOAD_FILE="openwrt-imagebuilder.*x86_64.tar.xz"

export_variables

./docker-download.sh || exit 1
./docker-build.sh || exit 1
