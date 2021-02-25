#!/bin/bash

set -ex

. ./functions.sh

export DOCKER_IMAGE="${DOCKER_IMAGE:-openwrt-sdk}"
export DOWNLOAD_FILE="openwrt-sdk-.*.Linux-x86_64.tar.xz"

# take the first supported target from TARGETS list
# shellcheck disable=SC2153,SC2034
TARGET=$(echo "$TARGETS" | cut -d ' ' -f 1)
export TARGET

export_variables

export ARCH="${ARCH:-$JOB}"

./docker-download.sh || exit 1

echo "Using SDK from revision $(sed -ne 's/REVISION:=//p' ./build/include/version.mk)"

./docker-build.sh || exit 1
