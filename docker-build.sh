#!/bin/bash

set -ex

# Copy Dockerfile inside build context to support older Docker versions
# See https://github.com/docker/cli/pull/886
cp "$DOCKERFILE" ./build/Dockerfile
TMP_IMAGE_NAME=$(tr -dc '[:lower:]' </dev/urandom | fold -w 32 | head -n 1)
docker build \
	--build-arg CI_REGISTRY_IMAGE \
	--file "./build/Dockerfile" \
	--tag "$TMP_IMAGE_NAME" \
	./build

for IMAGE in $DOCKER_IMAGE; do
	if [ "$TYPE" = "imagebuilder" ] || [ "$TYPE" = "rootfs" ]; then
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$TARGET-$VERSION"
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$TARGET-$BRANCH"
	fi

	if [ "$TYPE" = "rootfs" ]; then
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH-$VERSION"
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH-$BRANCH"
		if [ "$VERSION" == "snapshot" ]; then
			docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH"
		fi
	fi

	if [ "$TYPE" = "sdk" ]; then
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH-$VERSION"
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$ARCH-$BRANCH"

		if [ "$VERSION" == "snapshot" ]; then
			docker tag "$IMAGE:$ARCH-$VERSION" "$IMAGE:$ARCH"
		fi
	fi

	if [ "$TARGET" == "x86-64" ] || [ "$ARCH" == "x86_64" ]; then
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$VERSION"
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$BRANCH"

		if [ "$VERSION" == "snapshot" ]; then
			docker tag "$TMP_IMAGE_NAME" \
				"$IMAGE":"$(echo "$TARGET" | tr '/' '-')"
			docker tag "$TMP_IMAGE_NAME" "$IMAGE:latest"
		fi
	fi

	for TARGET_TAG in $TARGETS; do
		TARGET_TAG=$(echo "$TARGET_TAG" | tr '/' '-')
		docker tag "$TMP_IMAGE_NAME" "$IMAGE:$TARGET_TAG-$VERSION"
	done
done

docker rmi "$TMP_IMAGE_NAME"

rm -rf ./build
