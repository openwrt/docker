#!/bin/bash

set -ex

TARGET=$(echo "$CI_JOB_NAME" | cut -d _ -f 2-)
export TARGET="${TARGET:-x86-64}"
export VERSION="${VERSION:-snapshot}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-rootfs}"
export DOWNLOAD_FILE="openwrt-*-rootfs.tar.gz"
export DOCKERFILE="Dockerfile.rootfs"

if [ "$VERSION" = "snapshot" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$VERSION/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || exit 1

cp -r ./rootfs/* ./build

./docker-build.sh || exit 1
