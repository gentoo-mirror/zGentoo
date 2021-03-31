# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extension for visualizing asus-nb-ctrl(asusd) settings and status."
HOMEPAGE="https://gitlab.com/asus-linux/asus-nb-gex"
SRC_URI="https://gitlab.com/asus-linux/asus-nb-gex/-/jobs/1141394745/artifacts/download -> ${P}.zip"
S="${WORKDIR}/asus-nb-gex@asus-linux.org"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
DEPEND="
	dev-libs/glib:2
"
RDEPEND="${DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.36
"
BDEPEND=""

src_install() {
	insinto /usr/share/gnome-shell/extensions/asus-nb-gex@asus-linux.org
    doins -r ${S}/*
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
