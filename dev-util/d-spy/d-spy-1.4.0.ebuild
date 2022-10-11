# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="It's like d-feet, but written in C and blisteringly fast. Also comes with a library for IDE integration."
HOMEPAGE="https://gitlab.gnome.org/GNOME/d-spy"

IUSE="-introspection vapi docs extras"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
    >=gui-libs/gtk-4.6.6
	>=dev-libs/glib-2.74.0
    >=gui-libs/libadwaita-1.0
	virtual/pkgconfig
"

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
