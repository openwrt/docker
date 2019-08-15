#!/bin/bash

set -ex

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f "$DOCKERFILE" ./build

if [ "$BRANCH" == "master" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$TARGET"
    if [ "$TARGET" == "x86-64" ]; then
        docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:latest"
    fi
fi

if [ "$TARGET" == "x86-64" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$BRANCH"
fi

rm -rf ./build
