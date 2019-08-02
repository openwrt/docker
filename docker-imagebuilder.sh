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

        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f Dockerfile ./build

        rm -rf ./build

        [ -n "$DOCKER_USER" ] && [ -n "$DOCKER_PASS" ] && ./docker-upload.sh || true
    done
done
