#!/bin/bash

set -ex

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/
docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f "./build/$DOCKERFILE" ./build

if [ -n "$ARCH" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$ARCH-$BRANCH"
fi

if [ "$BRANCH" == "master" ]; then
    if [ -n "$ARCH" ]; then
        docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$ARCH"
    fi
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$TARGET"
    if [ "$TARGET" == "x86-64" ]; then
        docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:latest"
    fi
fi

if [ "$TARGET" == "x86-64" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$BRANCH"
fi

rm -rf ./build
