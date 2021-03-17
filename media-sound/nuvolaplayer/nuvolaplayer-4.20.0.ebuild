# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

inherit python-single-r1 vala waf-utils xdg

DESCRIPTION="Nuvola Player™ provides a tight Linux desktop integration for web- \
based media streaming services"
HOMEPAGE="https://nuvola.tiliado.eu/"
SRC_URI="
    https://github.com/tiliado/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="MIT"
SLOT="0"
# KEYWORDS="~amd64"

RDEPEND="
    ${PYTHON_DEPS}
	>=dev-libs/glib-2.66.7:2
	>=x11-libs/gtk+-3.24.22:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	virtual/pkgconfig
    >=x11-libs/diorite-4.20
    x11-libs/libdri2
"

src_prepare() {
    eapply_user
	python_setup
	python_fix_shebang -f "${S}/waf"
    waf-utils_src_prepare
	vala_src_prepare
}

src_configure() {
    ## this needs to be sorted out, especially appindicator
    waf-utils_src_configure \
        --no-appindicator \
        --no-unity \
        --no-debug-symbols \
        --no-vala-lint \
        --no-js-lint \
        --dummy-engine \
        --no-strict
}

src_compile() {
    waf-utils_src_compile
}

src_install() {
    waf-utils_src_install
}
