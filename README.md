# OpenWrt Docker repository

[![GPL-2.0-only License][license-badge]][license-ref]
[![CI][ci-badge]][ci-ref]
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

See `.gitlab-ci.yml` for the current setup.

## `rootfs`

An unpackaged version of OpenWrt's rootfs for different architectures. The
`./rootfs` folder requires slight modifications to work within Docker,
additional files for the rootfs should be added there before building.

### Example

    docker run --rm -it openwrtorg/rootfs

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

    docker run --rm -v "$(pwd)"/bin/:/home/build/openwrt/bin -it openwrtorg/sdk
    # within the Docker container
    ./scripts/feeds update base
    make defconfig
    ./scripts/feeds install firewall
    make package/firewall/{clean,compile} -j$(nproc)

Enjoy a local OpenWrt SDK container building the `firewall3` package and but the
binary in hosts `./bin` folder.

### Tags


All currently available SDKs via lower case `<target>-<subtarget>[-<branch>]`,
appending `19.07-SNAPSHOT` or `18.06.4` let's you build other than snapshots.

## `imagebuilder`

Contains the OpenWrt ImageBuilder based on a `debian:latest` container with
required packages preinstalled. This can be usefull when creating images on
MacOS X, Windows or via CI.

### Example

    docker run --rm -v "$(pwd)"/bin/:/home/build/openwrt/bin -it openwrtorg/imagebuilder
    # within the Docker container
    make image

Enjoy a local OpenWrt ImageBuilder container building an image for x86/64 and
store the binary in hosts `./bin` folder.

### Tags

All currently available SDKs via lower case `<target>-<subtarget>[-<branch>]`,
appending `19.07-SNAPSHOT` or `18.06.4` let's you build other than snapshots.

[ci-badge]: https://code.fe80.eu/openwrt/docker/badges/master/pipeline.svg
[ci-ref]: https://code.fe80.eu/openwrt/docker/commits/master
[docker-hub-badge]: https://img.shields.io/badge/docker--hub-openwrtorg-blue.svg?style=flat-square
[docker-hub-ref]: https://hub.docker.com/u/openwrtorg
[license-badge]: https://img.shields.io/github/license/openwrt/docker.svg?style=flat-square
[license-ref]: LICENSE
