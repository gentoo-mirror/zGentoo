# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
ETYPE="sources"

inherit kernel-2

KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://lab.retarded.farm/zappel/asus-rog-zephyrus-g14"
IUSE="experimental"

SLOT="${PV}-rc3"
K_NAME="linux-5.8-rc3"

DESCRIPTION="Full sources including the Gentoo patchset for the ${K_NAME} kernel tree"
SRC_URI="https://git.kernel.org/torvalds/t/${K_NAME}.tar.gz"


S="${WORKDIR}/linux-${PV}-gentoo"

src_unpack() {
	unpack ${K_NAME}.tar.gz
	mv ${K_NAME} ${S}
	## setting default kernel-config
	cp "${FILESDIR}/kernel-${PV}.config" ${S}/.config
}

src_prepare() {
	default
	eapply "${FILESDIR}/0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-CLONE_NEWUSER.patch" || die
	eapply "${FILESDIR}/0001-nonupstream-navi10-vfio-reset.patch" || die
	eapply "${FILESDIR}/1510_fs-enable-link-security-restrictions-by-default.patch" || die
	eapply "${FILESDIR}/3000-fsnotify-access.patch" || die
	eapply "${FILESDIR}/4567_distro-Gentoo-Kconfig.patch" || die
	eapply "${FILESDIR}/5000_ZSTD-v5-1-8-prepare-zstd-for-preboot-env.patch" || die
	eapply "${FILESDIR}/5001_ZSTD-v5-2-8-prepare-xxhash-for-preboot-env.patch" || die
	eapply "${FILESDIR}/5002_ZSTD-v5-3-8-add-zstd-support-to-decompress.patch" || die
	eapply "${FILESDIR}/5003_ZSTD-v5-4-8-add-support-for-zstd-compres-kern.patch" || die
	eapply "${FILESDIR}/5004_ZSTD-v5-5-8-add-support-for-zstd-compressed-initramfs.patch" || die
	eapply "${FILESDIR}/5005_ZSTD-v5-6-8-bump-ZO-z-extra-bytes-margin.patch" || die
	eapply "${FILESDIR}/5006_ZSTD-v5-7-8-support-for-ZSTD-compressed-kernel.patch" || die
	eapply "${FILESDIR}/6000-asus-wmi-kernel-5.8.patch" || die
	eapply "${FILESDIR}/6001-snd-hda-intel_realtek-kernel-5.8.patch" || die
	eapply "${FILESDIR}/6002-amdgpu-dm-kernel-5.8.patch" || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"

	einfo "please run genkernel or genkernel_upgrade afterwards"
}