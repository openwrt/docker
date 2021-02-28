#!/bin/sh

set -ex

export_variables() {
	JOB=$(echo "$CI_JOB_NAME" | cut -d _ -f 2-)
	export JOB
	TARGET="${TARGET:-$JOB}"
	export TARGET
	TYPE=$(echo "$CI_JOB_NAME" | cut -d _ -f 1 | cut -d - -f 2)
	export TYPE
	export VERSION="${VERSION:-snapshot}"
	export DOCKERFILE="${DOCKERFILE:-Dockerfile}"

	case "$VERSION" in
	snapshot)
		export BRANCH="master"
		;;
	*-SNAPSHOT)
		export BRANCH="openwrt-${VERSION%-*}"
		;;
	*)
		export BRANCH="openwrt-${VERSION%.*}"
		;;
	esac

	if [ "$VERSION" = "snapshot" ]; then
		DOWNLOAD_PATH="snapshots/targets/$(echo "$TARGET" | tr '-' '/')"
	else
		DOWNLOAD_PATH="releases/$VERSION/targets/$(echo "$TARGET" | tr '-' '/')"
	fi
	export DOWNLOAD_PATH
}
