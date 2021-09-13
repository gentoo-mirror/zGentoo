# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="4"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo and ASUS ROG patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

# setting kernel version (-rog) and source dir
KV="${PV}-gentoo-rog"
if [[ ${PR} != "r0" ]]; then
	KV="${PV}-${PR}-gentoo-rog"
fi
KV_FULL="${KV}"
S="${WORKDIR}/linux-${KV}"

src_unpack() {
	kernel-2_src_unpack

	# ROG Patches
	echo ">>> Applying ASUS ROG notebook specific patches"
	for p in ${FILESDIR}/*.patch; do
		eapply "${p}" || die
	done
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