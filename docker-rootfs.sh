#!/bin/sh

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"

for TARGET in $TARGETS ; do
    export ROOTFS_FILE="openwrt-*-rootfs.tar.gz"
    for BRANCH in $BRANCHES; do
        export ROOTFS_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"

        # download and verify checksums
        curl "https://downloads.openwrt.org/$ROOTFS_PATH/sha256sums" -sS -o sha256sums
        curl "https://downloads.openwrt.org/$ROOTFS_PATH/sha256sums.asc" -sS -o sha256sums.asc
        gpg --with-fingerprint --verify sha256sums.asc sha256sums

        # download file or skip if not available
        rsync -av "downloads.openwrt.org::downloads/$ROOTFS_PATH/$ROOTFS_FILE" . || contine

        # shrink checksum file to single desired file and verify downloaded archive
        cat sha256sums | grep generic-rootfs > sha256sums_rootfs
        sha256sum -c sha256sums_rootfs

        mkdir -p ./rootfs-openwrt
        tar xzf $ROOTFS_FILE -C ./rootfs-openwrt
        rm -rf $ROOTFS_FILE

        docker build -t $DOCKER_IMAGE:$TARGET-$BRANCH -f Dockerfile.rootfs .

        rm -rf ./rootfs-openwrt

        # snapshot don't get master attached to tag
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
