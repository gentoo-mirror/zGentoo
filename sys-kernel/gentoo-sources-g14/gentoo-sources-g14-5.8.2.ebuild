# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="4"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

MY_S="${WORKDIR}/linux-${PV}-gentoo-g14"
if [[ ${PR} != "r0" ]]; then
	MY_S="${WORKDIR}/linux-${PV}-gentoo-${PR}-g14"
fi

src_unpack() {
	kernel-2_src_unpack
	echo ">>> Applying ASUS ROG Zephyrus G14/G15 laptop specific patches"
	eapply "${FILESDIR}/0001-HID-asus-add-support-for-ASUS-N-Key-keyboard-v5.8.patch" || die # needed for ASUS ROG NKey Keyboard devices (upstream pending)
	eapply "${FILESDIR}/0002-drm-amd-display-use-correct-scale-for-actual_brightness.patch" || die # needed for amdgpu backlight control
	eapply "${FILESDIR}/9999-module_memory-kernel-5.8.patch" || die # needed for virtualbox (for vbox itself another patch is needed)

	# changing source destination path
	mv ${S} ${MY_S}
	S=${MY_S}
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"

	einfo "please run genkernel or genkernel_upgrade afterwards"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
