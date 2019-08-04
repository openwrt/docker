FROM debian:latest

MAINTAINER Paul Spooren <mail@aparcar.org>

RUN apt-get update -qq &&\
    apt-get install -y \
        build-essential \
        file \
        gawk \
        gettext \
        git \
        libncurses5-dev \
        libssl-dev \
        python2.7 \
        python3 \
        subversion \
        swig \
        unzip \
        wget \
        zlib1g-dev \
        && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -c "OpenWrt Builder" -m -d /home/build -s /bin/bash build
COPY --chown=build:build . /home/build/openwrt/
RUN chown build:build /home/build/openwrt/

USER build
ENV HOME /home/build
WORKDIR /home/build/openwrt/
