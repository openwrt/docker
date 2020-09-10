#!/bin/bash

set -ex

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/
docker build -t "$DOCKER_IMAGE:$TARGET-$VERSION" -f "./build/$DOCKERFILE" ./build

if [ -n "$ARCH" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$ARCH-$VERSION"
fi

if [ "$VERSION" == "snapshot" ]; then
    # backwards compatibility. New setups should use snapshot instead
    docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$TARGET-master"

    if [ -n "$ARCH" ]; then
        docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$ARCH"
    fi
    docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$TARGET"

    if [ "$TARGET" == "x86-64" ]; then
        # backwards compatibility. New setups should use snapshot instead
        docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:master"

        docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:latest"
    fi
fi

if [ "$TARGET" == "x86-64" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$VERSION" "$DOCKER_IMAGE:$VERSION"
fi

rm -rf ./build
