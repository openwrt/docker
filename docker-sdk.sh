#!/bin/bash

set -ex

ARCH=$(echo "$CI_JOB_NAME" | cut -d _ -f 2-)
# take the first supported target from TARGETS list
# shellcheck disable=SC2153
TARGET=$(echo "$TARGETS" | cut -d ' ' -f 1)
export TARGET="${TARGET:-x86-64}"
export ARCH="${ARCH:-x86_64}"
export VERSION="${VERSION:-snapshot}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-.*.Linux-x86_64.tar.xz"

if [ "$VERSION" = "snapshot" ]; then
	export BRANCH="master"
else
	export BRANCH="openwrt-${VERSION%.*}"
fi

if [ "$VERSION" == "snapshot" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$VERSION/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || exit 1

echo "Using SDK from revision $(sed -ne 's/REVISION:=//p' ./build/include/version.mk)"

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/

TMP_IMAGE_NAME=$(tr -dc '[:lower:]' < /dev/urandom | fold -w 32 | head -n 1)
docker build -t "$TMP_IMAGE_NAME" -f "./build/$DOCKERFILE" ./build

for IMAGE in $DOCKER_IMAGE; do
	docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH-$VERSION"

	if [ "$VERSION" == "snapshot" ]; then
	    docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$ARCH-$BRANCH"

	    docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$ARCH"
	    if [ "$ARCH" == "x86_64" ]; then
		docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$BRANCH"
		docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:latest"
	    fi
	fi

	if [ "$ARCH" == "x86_64" ]; then
	    docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$VERSION"
	fi

	for TARGET_TAG in $TARGETS; do
	    TARGET_TAG=$(echo "$TARGET_TAG" | tr '/' '-')
	    docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$TARGET_TAG-$VERSION"
	done
done

docker rmi "$TMP_IMAGE_NAME"

rm -rf ./build
