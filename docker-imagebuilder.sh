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

        mkdir -p ./imagebuilder
        tar Jxf $DOWNLOAD_FILE --strip=1 -C ./imagebuilder
        rm -rf $DOWNLOAD_FILE

        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f Dockerfile.imagebuilder .

        rm -rf ./imagebuilder

        [ -n "$DOCKER_USER" ] && [ -n "$DOCKER_PASS" ] && ./docker-upload.sh || true
    done
done
