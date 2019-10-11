#!/bin/bash

set -ex

export TARGET="${TARGET:-x86-64}"
export BRANCH="${BRANCH:-master}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-*-rootfs.tar.gz"
export DOCKERFILE="Dockerfile.rootfs"

if [ "$BRANCH" = "master" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$BRANCH/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || true

cp -r ./rootfs/* ./build

./docker-build.sh || exit 1
