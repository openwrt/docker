#!/bin/bash

set -ex

export TARGET="${TARGET:-x86-64}"
export BRANCH="${BRANCH:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-*.Linux-x86_64.tar.xz"

if [ "$BRANCH" == "master" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || exit 1
./docker-build.sh || exit 1
