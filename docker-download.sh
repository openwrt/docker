#!/bin/bash

set -ex

export FILE_HOST="${FILE_HOST:-downloads.openwrt.org}"
export GNUPGHOME="${GNUPGHOME:-/keys/gpg/}"
export USIGNHOME="${USIGNHOME:-/keys/usign/}"

curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums" -fs -o sha256sums
curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums.asc" -fs -o sha256sums.asc || true
curl "https://$FILE_HOST/$DOWNLOAD_PATH/sha256sums.sig" -fs -o sha256sums.sig || true
if [ ! -f sha256sums.asc ] && [ ! -f sha256sums.sig ]; then
    echo "Missing sha256sums signature files"
    exit 1
fi
[ ! -f sha256sums.asc ] || gpg --with-fingerprint --verify sha256sums.asc sha256sums

if [ -f sha256sums.sig ]; then
	if hash signify-openbsd 2>/dev/null; then
		SIGNIFY_BIN=signify-openbsd # debian
	else
		SIGNIFY_BIN=signify # alpine
	fi
    VERIFIED=
    for KEY in "$USIGNHOME"* ; do
        echo "Trying $KEY..."
        if "$SIGNIFY_BIN" -V -q -p "$KEY" -x sha256sums.sig -m sha256sums; then
            echo "...verified"
            VERIFIED=1
            break
        fi
    done
    if [ -z "$VERIFIED" ]; then
        echo "Could not verify usign signature"
        exit 1
    fi
fi

FILE_NAME=$(grep "$DOWNLOAD_FILE" sha256sums | cut -d "*" -f 2)
wget "https://$FILE_HOST/$DOWNLOAD_PATH/$FILE_NAME" || exit 1

# shrink checksum file to single desired file and verify downloaded archive
grep "$FILE_NAME" sha256sums > sha256sums_min
sha256sum -c sha256sums_min
rm -f sha256sums{,_min,.sig,.asc}

mkdir -p ./build
tar xf "$FILE_NAME" --strip=1 -C ./build
rm -rf "$FILE_NAME"
