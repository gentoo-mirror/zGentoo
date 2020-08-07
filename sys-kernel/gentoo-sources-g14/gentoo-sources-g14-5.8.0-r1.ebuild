# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="2"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	default
	eapply "${FILESDIR}/0001-HID-asus-add-support-for-ASUS-N-Key-keyboard-v5.8.patch" || die # needed for ASUS ROG NKey Keyboard devices (upstream pending)
	eapply "${FILESDIR}/0002-drm-amd-display-use-correct-scale-for-actual_brightness.patch" || die # needed for amdgpu backlight control
	eapply "${FILESDIR}/6000-asus-nb-wmi-add-support-for-ASUS-ROG-Zephyrus-G14.patch" || die # needed for G14/G15 asus-nb-wmi (upstream pending)
	eapply "${FILESDIR}/9999-module_memory-kernel-5.8.patch" || die # needed for virtualbox (for vbox itself another patch is needed)
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
