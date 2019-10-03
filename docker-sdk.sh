#!/bin/bash

set -ex

export TARGET="${TARGET:-x86-64}"
export BRANCH="${BRANCH:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-*.Linux-x86_64.tar.xz"

if [ "$BRANCH" == "master" ]; then
	export DOWNLOAD_PATH="snapshots/targets/$(echo $TARGET | tr '-' '/')"
else
	export DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo $TARGET | tr '-' '/')"
fi

./docker-download.sh || continue
./docker-build.sh || exit 1
