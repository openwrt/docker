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

        mkdir -p ./rootfs-openwrt
        tar xzf $DOWNLOAD_FILE -C ./rootfs-openwrt
        rm -rf $DOWNLOAD_FILE

        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f Dockerfile.rootfs .

        rm -rf ./rootfs-openwrt

        [ -n "$DOCKER_USER" ] && [ -n "$DOCKER_PASS" ] && ./docker-upload.sh || true
    done
done
