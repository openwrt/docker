#!/bin/bash

set -ex

if [ "$BRANCH" != "master" ]; then
    if [ "$TARGET" != "x86-64" ]; then
        docker build -t "$DOCKER_IMAGE:$TARGET-$BRANCH" -f Dockerfile ./build
    else
        docker build -t "$DOCKER_IMAGE:$BRANCH" -f Dockerfile ./build
    fi
else
    if [ "$TARGET" != "x86-64" ]; then
        docker build -t "$DOCKER_IMAGE:$TARGET" -f Dockerfile ./build
    else
        docker build -t "$DOCKER_IMAGE:latest" -f Dockerfile ./build
    fi
fi

rm -rf ./build
