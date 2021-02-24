#!/bin/bash

set -ex

. ./functions.sh

export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-.*-rootfs.tar.gz"
export DOCKERFILE="Dockerfile.rootfs"

export_variables

./docker-download.sh || exit 1

cp -r ./rootfs/* ./build

./docker-build.sh || exit 1
