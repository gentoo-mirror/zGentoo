# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental +fanmode_hotkey"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

MY_S="${WORKDIR}/linux-${PV}-gentoo-g14"
if [[ ${PR} != "r0" ]]; then
	MY_S="${WORKDIR}/linux-${PV}-${PR}-gentoo-g14"
fi

src_unpack() {
	kernel-2_src_unpack
	echo ">>> Applying ASUS ROG notebook specific patches"

	# updated device ids and generalized G14 detection
	eapply "${FILESDIR}/0001-HID-asus-Add-support-for-2021-ASUS-N-Key-keyboard.patch" || die
	eapply "${FILESDIR}/0001-HID-asus-Filter-keyboard-EC-for-old-ROG-keyboard.patch" || die
	eapply "${FILESDIR}/0001-WMI-asus-Reduce-G14-and-G15-match-to-min-product-nam.patch" || die
	
	# fixes ASUS ROG NKey Keyboard devices fan mode keypress (experimental)
	use fanmode_hotkey && eapply "${FILESDIR}/0002-HID-ASUS-Add-support-for-ASUS-N-Key-keyboard_fanmode.patch" || die

	# changing source destination path
	mv ${S} ${MY_S}
	S=${MY_S}
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"

	einfo "please run genkernel or genkernel_upgrade afterwards, and make"
	einfo "sure that grub-mkconfig created the correct order if this is a"
	einfo "revision(-rX) installation."
}

pkg_postrm() {
	kernel-2_pkg_postrm
}