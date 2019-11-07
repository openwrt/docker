#!/bin/bash

set -ex

export GNUPGHOME="/keys/gpg/"
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

export USIGNHOME="/keys/usign/"
mkdir -p "$USIGNHOME"
chmod 700 "$USIGNHOME"

# LEDE Build System (LEDE GnuPG key for unattended build jobs)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/626471F1.asc' | gpg --import \
    && echo '54CC74307A2C6DC9CE618269CD84BCED626471F1:6:' | gpg --import-ownertrust

# PGP key for 19.07 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/2074BE7A.asc' | gpg --import \
    && echo 'D9C6901F45C9B86858687DFF28A39BC32074BE7A:6:' | gpg --import-ownertrust

# LEDE Release Builder (17.01 "Reboot" Signing Key)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/D52BBB6B.asc' | gpg --import \
    && echo 'B09BE781AE8A0CD4702FDCD3833C6010D52BBB6B:6:' | gpg --import-ownertrust

# OpenWrt Release Builder (18.06 Signing Key)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/17E1CE16.asc' | gpg --import \
    && echo '6768C55E79B032D77A28DA5F0F20257417E1CE16:6:' | gpg --import-ownertrust

# LEDE Build System (LEDE usign key for unattended build jobs)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/b5043e70f9a75cde' \
	--create-dirs -o "$USIGNHOME/b5043e70f9a75cde"

# Public usign key for unattended snapshot builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/b5043e70f9a75cde' \
       	--create-dirs -o "$USIGNHOME/b5043e70f9a75cde"

# Public usign key for 19.07 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/f94b9dd6febac963' \
	--create-dirs -o "$USIGNHOME/f94b9dd6febac963"
