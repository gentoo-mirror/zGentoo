# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )
inherit distutils-r1

DISTUTILS_USE_PEP517=setuptools

DESCRIPTION="Adds support for tests during installation of setup.py files"
HOMEPAGE="https://pypi.org/project/pytest-runner/ https://github.com/pytest-dev/pytest-runner"
SRC_URI="https://files.pythonhosted.org/packages/2b/b2/5a07a37f314d3c0457c5431fd5b130e04355fa143f042356f77dd1570d36/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="
	>=dev-python/setuptools-40.6.3[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	doc? (
		dev-python/jaraco-packaging[${PYTHON_USEDEP}]
		dev-python/rst-linker[${PYTHON_USEDEP}]
	)
	test? ( ${RDEPEND} )
"

distutils_enable_sphinx docs

# Tests require network access to download packages
RESTRICT="test"

python_test() {
	esetup.py pytest
}
