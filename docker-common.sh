#!/bin/bash

set -ex

export GNUPGHOME="${GNUPGHOME:-/keys/gpg/}"
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

export USIGNHOME="${USIGNHOME:-/keys/usign/}"
mkdir -p "$USIGNHOME"
chmod 700 "$USIGNHOME"

# OpenWrt Build System (PGP key for unattended snapshot builds)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/626471F1.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<pgpsign-snapshots@openwrt.org>' | grep '^fpr:::::::::54CC74307A2C6DC9CE618269CD84BCED626471F1:$' \
 && echo '54CC74307A2C6DC9CE618269CD84BCED626471F1:6:' | gpg --import-ownertrust

# OpenWrt Build System (PGP key for 17.01 "Reboot" release builds)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/D52BBB6B.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<pgpsign-17.01@openwrt.org>' | grep '^fpr:::::::::B09BE781AE8A0CD4702FDCD3833C6010D52BBB6B:$' \
 && echo 'B09BE781AE8A0CD4702FDCD3833C6010D52BBB6B:6:' | gpg --import-ownertrust

# OpenWrt Release Builder (18.06 Signing Key)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/17E1CE16.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<openwrt-devel@lists.openwrt.org>' | grep '^fpr:::::::::6768C55E79B032D77A28DA5F0F20257417E1CE16:$' \
 && echo '6768C55E79B032D77A28DA5F0F20257417E1CE16:6:' | gpg --import-ownertrust

# PGP key for 18.06 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/15807931.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<openwrt-devel@lists.openwrt.org>' | grep '^fpr:::::::::AD0507363D2BCE9C9E36CEC4FBCB78F015807931:$' \
 && echo 'AD0507363D2BCE9C9E36CEC4FBCB78F015807931:6:' | gpg --import-ownertrust

# OpenWrt Build System (PGP key for 19.07 release builds)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/2074BE7A.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<pgpsign-19.07@openwrt.org>' | grep '^fpr:::::::::D9C6901F45C9B86858687DFF28A39BC32074BE7A:$' \
 && echo 'D9C6901F45C9B86858687DFF28A39BC32074BE7A:6:' | gpg --import-ownertrust

# OpenWrt Build System (PGP key for 21.02 release builds)
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=gpg/88CA59E8.asc' | gpg --import \
 && gpg --fingerprint --with-colons '<pgpsign-21.02@openwrt.org>' | grep '^fpr:::::::::667205E379BAF348863A5C6688CA59E88F681580:$' \
 && echo '667205E379BAF348863A5C6688CA59E88F681580:6:' | gpg --import-ownertrust

# untrusted comment: Public usign key for unattended snapshot builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/b5043e70f9a75cde' --create-dirs -o "$USIGNHOME/b5043e70f9a75cde" \
 && echo "d7ac10f9ed1b38033855f3d27c9327d558444fca804c685b17d9dcfb0648228f *$USIGNHOME/b5043e70f9a75cde" | sha256sum -c

# untrusted comment: Public usign key for 18.06 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/1035ac73cc4e59e3' --create-dirs -o "$USIGNHOME/1035ac73cc4e59e3" \
 && echo "8dc2e7f5c4e634437e6641f4df77a18bf59f0c8e9016c8ba4be5d4a0111e68c2 *$USIGNHOME/1035ac73cc4e59e3" | sha256sum -c

# untrusted comment: Public usign key for 19.07 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/f94b9dd6febac963' --create-dirs -o "$USIGNHOME/f94b9dd6febac963" \
 && echo "b1d09457cfbc36fccfe18382d65c54a2ade3e7fd3902da490a53aa517b512755 *$USIGNHOME/f94b9dd6febac963" | sha256sum -c

# untrusted comment: Public usign key for 21.02 release builds
curl 'https://git.openwrt.org/?p=keyring.git;a=blob_plain;f=usign/2f8b0b98e08306bf' --create-dirs -o "$USIGNHOME/2f8b0b98e08306bf" \
 && echo "d102bdd75421c62490b97f520f9db06aadb44ad408b244755d26e96ea5cd3b7f *$USIGNHOME/2f8b0b98e08306bf" | sha256sum -c
