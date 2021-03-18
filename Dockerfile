ARG CI_REGISTRY_IMAGE
FROM $CI_REGISTRY_IMAGE:base

MAINTAINER Paul Spooren <mail@aparcar.org>

COPY --chown=build:build . /home/build/openwrt/
RUN chown build:build /home/build/openwrt/

USER build
ENV HOME /home/build
WORKDIR /home/build/openwrt/

