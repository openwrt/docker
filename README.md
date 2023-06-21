# OpenWrt Docker repository

[![GPL-2.0-only License][license-badge]][license-ref]
[![CI][ci-badge]][ci-ref]
[![Docker Hub][docker-hub-badge]][docker-hub-ref]


This repository contains files to create OpenWrt containers. While mostly used
for our CI you may use the scripts to build containers on your own.

> **Warning**
> We switch our docker.io account from `openwrtorg` to `openwrt`

Available containers:

* `imagebuilder` create firmware images
* `sdk` compile OpenWrt packages
* `rootfs` test software inside an OpenWrt runtime

All containers are mirrored to the follwing three registries:

* docker.io
* ghcr.io
* quay.io

Find more details on the container types below

## `sdk`

Contains the [OpenWrt
SDK](https://openwrt.org/docs/guide-developer/toolchain/using_the_sdk) based on
the same container we use for our [Buildbot](https://buildbot.org)
infrastructure. This can be useful when building packages on macOS, Windows or
via CI.

### SDK Example

```shell
docker run --rm -v "$(pwd)"/bin/:/builder/bin -it openwrt/sdk
# inside the Docker container
./scripts/feeds update packages
make defconfig
./scripts/feeds install tmate
make package/tmate/{clean,compile} -j$(nproc)
```

Enjoy a local OpenWrt SDK container building the `tmate` package and but the
binary in hosts `./bin` folder.

### SDK Tags

All currently available SDKs via tags in the following format:

* `<target>-<subtarget>[-<branch|tag|version>]`

The `branch|tag|version` can be something like `openwrt-22.03` (branch),
`v22.03.4` (tag) or `21.02.3` (version). To use daily builds use either `main`
or `SNAPSHOT`.

## `imagebuilder`

Contains the [OpenWrt
ImageBuilder](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)
based on the same container we use for our [buildbot](buildbot.org)
infrastructure. This can be useful when creating images on macOS, Windows or
via CI.

### ImageBuilder Example

```shell
docker run --rm -v "$(pwd)"/bin/:/builder/bin -it openwrt/imagebuilder
# inside the Docker container
make image PROFILE=generic PACKAGES=tmate
```

Enjoy a local OpenWrt ImageBuilder container building an image for x86/64 and
store the binary in hosts `./bin` folder.

### ImageBuilder Tags

All currently available ImageBuilders via tags in the following format:

* `<target>-<subtarget>[-<branch|tag|version>]`
* `<arch>[-<branch|tag|version>]`

The `branch|tag|version` can be something like `openwrt-22.03` (branch),
`v22.03.4` (tag) or `21.02.3` (version). To use daily builds use either `main`
or `SNAPSHOT`.

## `rootfs` (experimental)

> The OpenWrt runtime uses multiple active serices to work, it's not really
> suited as a container. This `rootfs` should only be used for special cases
> like CI testing.

An unpackaged version of OpenWrt's rootfs for different architectures. The
`./rootfs` folder requires slight modifications to work within Docker,
additional files for the rootfs should be added there before building.

### Rootfs Example

```shell
docker run --rm -it openwrt/rootfs
# inside the Docker container
mkdir /var/lock/
opkg update
opkg install tmate
tmate
```

Enjoy a local OpenWrt container running the x86/64 architecture with internet
access. Once closed the container is removed.

### Rootfs Tags

"|||armvirt/32|armvirt/64|malta/be|mvebu/cortexa9

* `x86/64` or `x86_64`
* `x86/generic` or `i386_pentium4`
* `x86/geode` or `i386_pentium-mmx`
* `armvirt/32` or `arm_cortex-a15_neon-vfpv4`
* `armvirt/64` or `aarch64_cortex-a53`
* `malta/be` or `mips_24kc`
* `mvebu/cortexa9` or `arm_cortex-a9_vfpv3-d16`

## Build Your Own

If you wan to create your own container you can use the `Dockerfile`. You can set the following build arguments:

* `TARGET` - the target to build for (e.g. `x86/64`)
* `DOWNLOAD_FILE` - the file to download (e.g. `imagebuilder-.*x86_64.tar.xz`)
* `FILE_HOST` - the host to download the ImageBuilder/SDK/rootfs from (e.g. `downloads.openwrt.org`)
* `VERSION_PATH` - the path to the ImageBuilder/SDK/rootfs (e.g. `snapshots` or `releases/21.02.3`)

### Example ImageBuilder

> If you plan to use your own server please add your own GPG key to the
> `./keys/` folder.

```shell
docker build \
    --build-arg TARGET=x86/64 \
    --build-arg DOWNLOAD_FILE="imagebuilder-.*x86_64.tar.xz" \
    --build-arg FILE_HOST=downloads.openwrt.org \
    --build-arg VERSION_PATH=snapshots \
    -t openwrt/x86_64 .
```

[ci-badge]: https://github.com/openwrt/docker/actions/workflows/containers.yml/badge.svg
[ci-ref]: https://github.com/openwrt/docker/actions/workflows/containers.yml
[docker-hub-badge]: https://img.shields.io/badge/docker--hub-openwrt-blue.svg?style=flat-square
[docker-hub-ref]: https://hub.docker.com/u/openwrt
[license-badge]: https://img.shields.io/github/license/openwrt/docker.svg?style=flat-square
[license-ref]: LICENSE
