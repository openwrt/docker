#!/bin/bash

set -ex

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-imagebuilder}"
export DOWNLOAD_FILE="openwrt-imagebuilder*x86_64.tar.xz"

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
        ./docker-build.sh || exit 1
    done
done
