#!/bin/bash

set -ex

DOCKERFILE="${DOCKERFILE:-Dockerfile}"
# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/
TMP_IMAGE_NAME=$(tr -dc '[:lower:]' < /dev/urandom | fold -w 32 | head -n 1)
docker build -t "$TMP_IMAGE_NAME" -f "./build/$DOCKERFILE" ./build

for IMAGE in $DOCKER_IMAGE; do
	docker tag "$TMP_IMAGE_NAME" "$IMAGE:$TARGET-$VERSION"

	if [ -n "$ARCH" ]; then
	    docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$ARCH-$VERSION"
	fi

	if [ "$VERSION" == "snapshot" ]; then
	    docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$TARGET-$BRANCH"

	    if [ -n "$ARCH" ]; then
		docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$ARCH"
	    fi
	    docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$TARGET"

	    if [ "$TARGET" == "x86-64" ]; then
		docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$BRANCH"
		docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:latest"
	    fi
	fi

	if [ "$TARGET" == "x86-64" ]; then
	    docker tag "$IMAGE:$TARGET-$VERSION" "$IMAGE:$VERSION"
	fi
done

docker rmi "$TMP_IMAGE_NAME"

rm -rf ./build
