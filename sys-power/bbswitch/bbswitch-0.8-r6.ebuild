# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod toolchain-funcs

inherit git-r3
EGIT_REPO_URI="https://github.com/Bumblebee-Project/${PN}.git"
EGIT_BRANCH="develop"
EGIT_COMMIT="ddbd243"
KEYWORDS="amd64 x86"

DESCRIPTION="Toggle discrete NVIDIA Optimus graphics card"
HOMEPAGE="https://github.com/Bumblebee-Project/bbswitch"

SLOT="0"
LICENSE="GPL-3+"
IUSE="g14"

RDEPEND="
	g14? ( 
		x11-misc/optimus-manager[amdgpu]
		sys-power/acpi_call
	)
"
DEPEND="
	${RDEPEND}
	virtual/linux-sources
	sys-kernel/linux-headers
"

MODULE_NAMES="bbswitch(acpi)"

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_TARGETS="default"
	BUILD_PARAMS="KVERSION=${KV_FULL} CC=$(tc-getCC)"
}

src_prepare() {
	default

	# Fix build failure, bug #513542
	sed "s%^KDIR :=.*%KDIR := ${KERNEL_DIR}%g" -i Makefile || die

	use g14 && eapply "${FILESDIR}/${P}-zephyrus14.patch"
}

src_install() {
	einstalldocs

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/bbswitch.modprobe bbswitch.conf
	if use g14; then
		insinto /etc/modules-load.d
		newins "${FILESDIR}"/bbswitch.modload bbswitch.conf
	fi

	linux-mod_src_install
}
