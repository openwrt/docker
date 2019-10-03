#!/bin/bash

TARGETS_ROOTFS="""\
	x86-64 \
	armvirt-32 \
	armvirt-64 \
"""

TARGETS="""\
	apm821xx-nand \
	apm821xx-sata \
	ar7-ac49x \
	ar7-generic \
	ar71xx-generic \
	ar71xx-mikrotik \
	ar71xx-nand \
	ar71xx-tiny \
	arc770-generic \
	archs38-generic \
	armvirt-32 \
	armvirt-64 \
	at91-legacy \
	at91-sam9x \
	at91-sama5 \
	at91-sama5d2 \
	at91-sama5d3 \
	at91-sama5d4 \
	ath25-generic \
	ath79-generic \
	ath79-nand \
	ath79-tiny \
	bcm53xx-generic \
	brcm2708-bcm2708 \
	brcm2708-bcm2709 \
	brcm2708-bcm2710 \
	brcm47xx-generic \
	brcm47xx-legacy \
	brcm47xx-mips74k \
	brcm63xx-generic \
	brcm63xx-smp \
	cns3xxx-generic \
	gemini-generic \
	imx6-generic \
	ipq40xx-generic \
	ipq806x-generic \
	ixp4xx-generic \
	ixp4xx-harddisk \
	kirkwood-generic \
	lantiq-ase \
	lantiq-falcon \
	lantiq-xrx200 \
	lantiq-xway \
	lantiq-xway_legacy \
	layerscape-armv7 \
	layerscape-armv8_32b \
	layerscape-armv8_64b \
	malta-be \
	mediatek-mt7622 \
	mediatek-mt7623 \
	mpc85xx-generic \
	mpc85xx-p1020 \
	mpc85xx-p2020 \
	mvebu-cortexa53 \
	mvebu-cortexa72 \
	mvebu-cortexa9 \
	mxs-generic \
	octeon-generic \
	octeontx-generic \
	omap-generic \
	oxnas-ox820 \
	pistachio-generic \
	ramips-mt7620 \
	ramips-mt7621 \
	ramips-mt76x8 \
	ramips-rt288x \
	ramips-rt305x \
	ramips-rt3883 \
	rb532-generic \
	samsung-s5pv210 \
	sunxi-cortexa53 \
	sunxi-cortexa7 \
	sunxi-cortexa8 \
	tegra-generic \
	x86-64 \
	x86-generic \
	x86-geode \
	x86-legacy \
	zynq-generic \
"""

> targets_rootfs.yml

for TARGET in $TARGETS_ROOTFS; do
	echo """
deploy-rootfs-$TARGET:
  extends: .deploy-rootfs
  variables:
    TARGET: "$TARGET"
""" >> targets_rootfs.yml
done

> targets.yml

for TARGET in $TARGETS; do
	echo """
deploy-imagebuilder-$TARGET:
  extends: .deploy-imagebuilder
  variables:
    TARGET: "$TARGET"

deploy-sdk-$TARGET:
  extends: .deploy-sdk
  variables:
    TARGET: "$TARGET"
""" >> targets.yml
done
