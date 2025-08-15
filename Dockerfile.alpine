FROM alpine:latest

USER root

RUN apk add -u --no-cache \
  bash \
  build-base \
  bzip2 \
  ccache \
  coreutils \
  diffutils \
  findutils \
  gawk \
  git \
  gettext \
  gpg \
  gpg-agent \
  grep \
  gzip \
  libxslt \
  ncurses-dev \
  openssl-dev \
  perl \
  python3 \
  py3-setuptools \
  rsync \
  unzip \
  util-linux \
  tar \
  wget \
  xz \
  zlib-dev \
  zstd

ARG USER=buildbot
ARG WORKDIR=/builder/
ARG CMD="/bin/bash"

ARG DOWNLOAD_FILE="imagebuilder-.*x86_64.tar.[xz|zst]"
ARG TARGET=x86/64
ARG FILE_HOST=downloads.openwrt.org
ARG VERSION_PATH

ENV DOWNLOAD_FILE=$DOWNLOAD_FILE
ENV TARGET=$TARGET
ENV FILE_HOST=$FILE_HOST
ENV VERSION_PATH=$VERSION_PATH

RUN adduser -h $WORKDIR -DH $USER

USER $USER
WORKDIR $WORKDIR

ADD --chown=buildbot:buildbot keys/*.asc /builder/keys/
COPY --chmod=0755 setup.sh /builder/setup.sh

ARG RUN_SETUP=0
ENV RUN_SETUP=$RUN_SETUP
RUN if [ "$RUN_SETUP" -eq 1 ]; then /builder/setup.sh; fi

ENTRYPOINT [ ]

# required to have CMD as ENV to be executed
ENV CMD_ENV=${CMD}
CMD ${CMD_ENV}
