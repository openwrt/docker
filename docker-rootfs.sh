#!/bin/sh

set -ex

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-*-rootfs.tar.gz"
export DOCKERFILE="Dockerfile.rootfs"

for TARGET in $TARGETS ; do
    export TARGET
    for BRANCH in $BRANCHES; do
        export BRANCH
        if [ "$BRANCH" == "master" ]; then
            export DOWNLOAD_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
        else
            export DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
        fi

        ./docker-download.sh || exit 1

        cp -r ./rootfs/* ./build

        ./docker-build.sh || exit 1
    done
done
