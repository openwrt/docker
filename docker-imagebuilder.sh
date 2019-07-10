#!/bin/bash

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-imagebuilder}"

for TARGET in $TARGETS ; do
    export IMAGEBUILDER_FILE="openwrt-imagebuilder*x86_64.tar.xz"
    for BRANCH in $BRANCHES; do
        if [ "$BRANCH" == "master" ]; then
            export IMAGEBUILDER_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
        else
            export IMAGEBUILDER_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
        fi

        curl "https://downloads.openwrt.org/$IMAGEBUILDER_PATH/sha256sums" -sS -o sha256sums
        curl "https://downloads.openwrt.org/$IMAGEBUILDER_PATH/sha256sums.asc" -sS -o sha256sums.asc
        gpg --with-fingerprint --verify sha256sums.asc sha256sums
        rsync -av "downloads.openwrt.org::downloads/$IMAGEBUILDER_PATH/$IMAGEBUILDER_FILE" . || contine # skip uploading if no IB is available
        cat sha256sums | grep openwrt-imagebuilder > sha256sums_imagebuilder
        sha256sum -c sha256sums_imagebuilder

        mkdir -p ./imagebuilder
        tar Jxf $IMAGEBUILDER_FILE --strip=1 -C ./imagebuilder
        rm -rf $IMAGEBUILDER_FILE

        docker build -t $DOCKER_IMAGE:$TARGET-$BRANCH -f Dockerfile.imagebuilder .

        rm -rf ./imagebuilder

        if [ "$BRANCH" == "master" ]; then
            docker tag $DOCKER_IMAGE:$TARGET-$BRANCH $DOCKER_IMAGE:$TARGET
            docker push $DOCKER_IMAGE:$TARGET
            if [ "$TARGET" == "x86-64" ]; then
                docker tag $DOCKER_IMAGE:$TARGET-$BRANCH $DOCKER_IMAGE:latest
                docker push $DOCKER_IMAGE:latest
            fi
        else
            docker push $DOCKER_IMAGE:$TARGET-$BRANCH
        fi
    done
done
