# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )

inherit meson git-r3 xdg-utils

DESCRIPTION="System utility designed to provide information, control the fans and overclock your NVIDIA card"
HOMEPAGE="https://gitlab.com/leinardi/gwe"
EGIT_REPO_URI="${HOMEPAGE}"
EGIT_TAG="${PV}"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="
    dev-libs/gobject-introspection
	dev-libs/libdazzle
	dev-libs/libappindicator
	>=dev-python/injector-0.1.7
	>=dev-python/matplotlib-3.1.1
	>=dev-python/peewee-3.9.6
	>=dev-python/py3nvml-0.2.3
    >=dev-python/pyxdg-0.26
	dev-python/pycairo
	dev-python/pygobject
	dev-python/requests
	>=dev-python/python-xlib-0.26
	>=dev-python/Rx-3.0.1
"
DEPEND="${RDEPEND}
	dev-util/meson
"
pkg_postinst() {
	xdg_desktop_database_update
}