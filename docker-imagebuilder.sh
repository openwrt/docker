#!/bin/bash

set -ex

TARGETS="${TARGETS:-x86-64}"
export BRANCH="${BRANCH:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-imagebuilder}"
export DOWNLOAD_FILE="openwrt-imagebuilder*x86_64.tar.xz"

for TARGET in $TARGETS ; do
    export TARGET
    if [ "$BRANCH" == "master" ]; then
        export DOWNLOAD_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
    else
        export DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
    fi

    ./docker-download.sh || continue
    ./docker-build.sh || exit 1
done
