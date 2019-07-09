# OpenWrt Docker repository

[![GPL-2.0-only License][license-badge]][license-ref]
[![Circle CI][circle-ci-badge]][circle-ci-ref]
[![Docker Hub][docker-hub-badge]][docker-hub-ref]

This repository contains scripts to create Docker containers for OpenWrt. The
scripts are run via an CI and upload such containers to docker.io.

Used variables are `BRANCHES`, `TARGETS`, `DOCKER_USER`, `DOCKER_PASS` and `DOCKER_IMAGE`.

`$BRANCHES`: space separated list of OpenWrt branches to build ("master 18.06.2 18.06.1")
`$TARGETS`: space separated list of OpenWrt targets to build ("x86-64 ath79-generic")
`$DOCKER_USER`: user to upload
`$DOCKER_PASS`: passwort to upload
`$DOCKER_IMAGE`: image name

`$BRANCHES` and `$TARGETS` unite to a build matrix.

See `.circleci/config.yml` for the current setup.

## `rootfs`

An unpackaged version of OpenWrt's rootfs for different architectures. The
`./rootfs` folder requires slight modifications to work within Docker,
additional files for the rootfs should be added there before building.

### Example

    docker run --rm -it openwrtorg/rootfs:x86-64

Enjoy a local OpenWrt container with internet access. Once closed the image is
removed.

### Tags

* x86-64
* armvirt-32
* armvirt-64

## `sdk`

Contains the OpenWrt SDK based on a `debian:latest` container with required
packages preinstalled. This can be usefull when building packages on MacOS X,
Windows or via CI.

### Example

    docker run --rm -v "$(pwd)"/bin/:/home/build/sdk/bin -it openwrtorg/sdk:x86-64
    # within the Docker container
    ./scripts/feeds update base
    make defconfig
    ./scripts/feeds install firewall
    make package/firewall/{clean,compile} -j$(nproc)

Enjoy a local OpenWrt SDK container building the `firewall3` package and but the
binary in hosts `./bin` folder.

### Tags

All currently available SDKs via lower case `<target>-<subtarget>`

## `imagebuilder`

Contains the OpenWrt ImageBuilder based on a `debian:latest` container with
required packages preinstalled. This can be usefull when creating images on
MacOS X, Windows or via CI.

### Example

    docker run --rm -v "$(pwd)"/bin/:/home/build/imagebuilder/bin -it openwrtorg/imagebuilder:x86-64
    # within the Docker container
    make image

Enjoy a local OpenWrt ImageBuilder container building an image for x86/64 and
store the binary in hosts `./bin` folder.

### Tags

All currently available ImageBuilders via lower case `<target>-<subtarget>`

[circle-ci-badge]: https://img.shields.io/circleci/build/gh/openwrt/docker.svg?style=flat-square
[circle-ci-ref]: https://circleci.com/gh/openwrt/docker
[docker-hub-badge]: https://img.shields.io/badge/docker--hub-openwrtorg-blue.svg?style=flat-square
[docker-hub-ref]: https://hub.docker.com/u/openwrtorg
[license-badge]: https://img.shields.io/github/license/openwrt/docker.svg?style=flat-square
[license-ref]: LICENSE
