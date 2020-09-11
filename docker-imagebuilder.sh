#!/bin/bash

set -ex

TARGET=$(echo "$CI_JOB_NAME" | cut -d _ -f 2-)
export TARGET="${TARGET:-x86-64}"
export VERSION="${VERSION:-snapshot}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-imagebuilder}"
export DOWNLOAD_FILE="openwrt-imagebuilder*x86_64.tar.xz"

if [ "$VERSION" == "snapshot" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$VERSION/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || exit 1
./docker-build.sh || exit 1
