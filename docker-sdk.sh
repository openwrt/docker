#!/bin/bash

set -ex

TARGETS="${TARGETS:-x86-64}"
BRANCHES="${BRANCHES:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-*.Linux-x86_64.tar.xz"

for TARGET in $TARGETS ; do
    for BRANCH in $BRANCHES; do
        if [ "$BRANCH" == "master" ]; then
            export DOWNLOAD_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
            BRANCH_FEEDS="$BRANCH"
        else
            export DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
            BRANCH_FEEDS="openwrt-$BRANCH"
        fi

        ./docker-download.sh || exit 1

        mkdir -p ./sdk
        tar Jxf $DOWNLOAD_FILE --strip=1 -C ./sdk
        rm -rf $DOWNLOAD_FILE

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

        [ -n "$DOCKER_USER" ] && [ -n "$DOCKER_PASS" ] && ./docker-upload.sh || true
    done
done
