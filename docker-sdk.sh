#!/bin/bash

set -ex

ARCH=$(echo "$CI_JOB_NAME" | cut -d _ -f 2-)
# shellcheck disable=SC2153
TARGET=$(echo "$TARGETS" | cut -d ' ' -f 1)
export TARGET="${TARGET:-x86-64}"
export VERSION="${VERSION:-snapshot}"
export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-*.Linux-x86_64.tar.xz"

if [ "$VERSION" == "snapshot" ]; then
	DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
else
	DOWNLOAD_PATH="releases/$VERSION/targets/$(echo "$TARGET" | tr '-' '/')"
fi
export DOWNLOAD_PATH

./docker-download.sh || exit 1

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/
docker build -t "$DOCKER_IMAGE:$ARCH-$VERSION" -f "./build/$DOCKERFILE" ./build

if [ "$VERSION" == "snapshot" ]; then
    # backwards compatibility. New setups should use snapshot instead
    docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$TARGET-master"

    docker tag "$DOCKER_IMAGE:$ARCH-$VERSION" "$DOCKER_IMAGE:$ARCH"
    if [ "$ARCH" == "x86_64" ]; then
        # backwards compatibility. New setups should use snapshot instead
        docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:master"

        docker tag "$DOCKER_IMAGE:$ARCH-$VERSION" "$DOCKER_IMAGE:latest"
    fi
fi

if [ "$ARCH" == "x86_64" ]; then
    docker tag "$DOCKER_IMAGE:$ARCH-$VERSION" "$DOCKER_IMAGE:$VERSION"
fi

for TARGET_TAG in $TARGETS; do
    TARGET_TAG=$(echo "$TARGET_TAG" | tr '/' '-')
    docker tag "$DOCKER_IMAGE:$ARCH-$VERSION" "$DOCKER_IMAGE:$TARGET_TAG-$VERSION"
done

rm -rf ./build
