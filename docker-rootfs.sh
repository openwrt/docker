#!/bin/sh

set -ex

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-*-rootfs.tar.gz"

for TARGET in $TARGETS ; do
    export TARGET
    for BRANCH in $BRANCHES; do
        export BRANCH
        export DOWNLOAD_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"

        ./docker-download.sh || exit 1

        cp -r ./rootfs/* ./build

        ./docker-build.sh || exit 1
    done
done
