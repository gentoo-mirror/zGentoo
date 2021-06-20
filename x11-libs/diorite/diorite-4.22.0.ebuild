
# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit python-single-r1 vala waf-utils xdg

DESCRIPTION="Diorite library is a private utility and widget library for \
Nuvola Apps project based on GLib, GIO and GTK"
HOMEPAGE="https://nuvola.tiliado.eu/"
SRC_URI="
    https://github.com/tiliado/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="valadoc valalint"

RDEPEND="
    ${PYTHON_DEPS}
	>=dev-libs/glib-2.66.7:2
	>=x11-libs/gtk+-3.24.22:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare

	default
}

python_prepare_all() {
	vala_src_prepare
}

src_configure() {
    waf-utils_src_configure --novaladoc --nodebug --no-vala-lint
}

src_compile() {
    waf-utils_src_compile
}

src_install() {
    waf-utils_src_install
}
