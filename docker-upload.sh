#!/bin/bash

set -ex

if [ "$BRANCH" == "master" ]; then
    docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:$TARGET"
    docker push "$DOCKER_IMAGE:$TARGET"
    if [ "$TARGET" == "x86-64" ]; then
        docker tag "$DOCKER_IMAGE:$TARGET-$BRANCH" "$DOCKER_IMAGE:latest"
        docker push "$DOCKER_IMAGE:latest"
    fi
else
    docker push "$DOCKER_IMAGE:$TARGET-$BRANCH"
fi
