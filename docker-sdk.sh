#!/bin/bash

set -e
set -x

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"

for TARGET in $TARGETS ; do
    SDK_FILE="openwrt-sdk-*.Linux-x86_64.tar.xz"
    for BRANCH in $BRANCHES; do
        if [ "$BRANCH" == "master" ]; then
            SDK_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
            BRANCH_FEEDS="$BRANCH"
        else
            SDK_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
            BRANCH_FEEDS="openwrt-$BRANCH"
        fi

        curl "https://downloads.openwrt.org/$SDK_PATH/sha256sums" -sS -o sha256sums
        curl "https://downloads.openwrt.org/$SDK_PATH/sha256sums.asc" -sS -o sha256sums.asc
        gpg --with-fingerprint --verify sha256sums.asc sha256sums
        rsync -av "downloads.openwrt.org::downloads/$SDK_PATH/$SDK_FILE" . || continue # skip uploading if no SDK is available
        grep openwrt-sdk sha256sums > sha256sums_sdk
        sha256sum -c sha256sums_sdk

        mkdir -p ./sdk
        tar Jxf $SDK_FILE --strip=1 -C ./sdk
        rm -rf $SDK_FILE

        # use GitHub instead of git.openwrt.org
        cat > ./sdk/feeds.conf <<EOF
src-git base https://github.com/openwrt/openwrt.git;$BRANCH_FEEDS
src-git packages https://github.com/openwrt/packages.git;$BRANCH_FEEDS
src-git luci https://github.com/openwrt/luci.git;$BRANCH_FEEDS
src-git routing https://github.com/openwrt-routing/packages.git;$BRANCH_FEEDS
src-git telephony https://github.com/openwrt/telephony.git;$BRANCH_FEEDS
EOF

        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f Dockerfile.sdk .

        rm -rf ./sdk

        if [ "$BRANCH" == "master" ]; then
            docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$TARGET"
            docker push "$DOCKER_IMAGE:$TARGET"
            if [ "$TARGET" == "x86-64" ]; then
                docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:latest"
                docker push "$DOCKER_IMAGE:latest"
            fi
        else
            docker push "$DOCKER_IMAGE:$TARGET-$BRANCH"
        fi
    done
done
