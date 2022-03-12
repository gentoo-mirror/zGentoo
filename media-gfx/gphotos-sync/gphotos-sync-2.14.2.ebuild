# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Google Photos Sync downloads your Google Photos to the local file system."
SRC_URI="https://github.com/gilesknap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://pypi.org/project/gphotos-sync/ https://github.com/gilesknap/gphotos-sync"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="MIT"
IUSE="doc"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
    dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/appdirs
	media-gfx/exif
	dev-python/exif
	dev-python/pyyaml
	dev-python/requests-oauthlib
	dev-python/selenium
	dev-python/urllib3
"
RDEPEND="${DEPEND}"

RESTRICT="test" # broken since v1.4.3

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd test || die
	"${EPYTHON}" testall.py || die "Testsuite failed"
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then 
        local HTML_DOCS=( docs/_build/html/. )
	    einstalldocs
    fi
}