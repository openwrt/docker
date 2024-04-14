ARG BASE_IMAGE=ghcr.io/openwrt/buildbot/buildworker-v3.11.1:latest

FROM ghcr.io/openwrt/buildbot/buildworker-v3.11.1:latest

WORKDIR /build/

# use "sdk-.*.Linux-x86_64.tar.xz" to create the SDK
ARG DOWNLOAD_FILE="imagebuilder-.*x86_64.tar.[xz|zst]"
ARG TARGET=x86/64
ARG FILE_HOST=downloads.openwrt.org
ARG VERSION_PATH

# if $VERSION is empty fallback to snapshots
ENV VERSION_PATH=${VERSION_PATH:-snapshots}
ENV DOWNLOAD_PATH=$VERSION_PATH/targets/$TARGET

RUN curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums" -fs -o sha256sums
RUN curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums.asc" -fs -o sha256sums.asc || true
RUN curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums.sig" -fs -o sha256sums.sig || true

ADD keys/*.asc keys/
RUN gpg --import keys/*.asc
RUN gpg --with-fingerprint --verify sha256sums.asc sha256sums

# determine archive name
RUN echo $(grep "$DOWNLOAD_FILE" sha256sums | cut -d "*" -f 2) >> ~/file_name

# download imagebuilder/sdk archive
RUN wget --quiet "https://$FILE_HOST/$DOWNLOAD_PATH/$(cat ~/file_name)"

# shrink checksum file to single desired file and verify downloaded archive
RUN grep "$(cat ~/file_name)" sha256sums > sha256sums_min
RUN cat sha256sums_min
RUN sha256sum -c sha256sums_min

# cleanup
RUN rm -rf sha256sums{,_min,.sig,.asc} keys/

RUN tar xf "$(cat ~/file_name)" --strip=1 --no-same-owner -C .
RUN rm -rf "$(cat ~/file_name)"

FROM $BASE_IMAGE

ARG USER=buildbot
ARG WORKDIR=/builder/
ARG CMD="/bin/bash"

USER $USER
WORKDIR $WORKDIR

COPY --from=0 --chown=$USER:$USER /build/ ./

ENTRYPOINT [ ]

# required to have CMD as ENV to be executed
ENV CMD_ENV=${CMD}
CMD ${CMD_ENV}
