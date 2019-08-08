#!/bin/bash

set -ex

DOCKERFILE="${DOCKERFILE:-Dockerfile}"

if [ "$BRANCH" != "master" ]; then
    if [ "$TARGET" != "x86-64" ]; then
        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f "$DOCKERFILE" ./build
    else
        docker build -t "$DOCKER_IMAGE:$BRANCH" -f "$DOCKERFILE" ./build
    fi
else
    if [ "$TARGET" != "x86-64" ]; then
        docker build -t "$DOCKER_IMAGE:$TARGET" -f "$DOCKERFILE" ./build
    else
        docker build -t "$DOCKER_IMAGE:latest" -f "$DOCKERFILE" ./build
    fi
fi

rm -rf ./build
