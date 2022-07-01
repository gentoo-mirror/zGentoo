# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="PyMacaroons is a Python implementation of Macaroons"
HOMEPAGE="https://github.com/ecordell/pymacaroons https://pypi.python.org/pypi/pymacaroons-pynacl"
SRC_URI="https://github.com/ecordell/pymacaroons/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/six
	dev-python/pynacl"
