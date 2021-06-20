# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python dependency injection framework, inspired by Guice"
HOMEPAGE="https://github.com/alecthomas/injector"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

IUSE="doc test"

RDEPEND="
	test? ( 
		dev-python/pytest
		dev-python/hypothesis 
	)
"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
"


python_compile_all() {
	use doc && emake -C docs
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
