# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit edos2unix distutils-r1

DESCRIPTION="ctypes bindings for hidapi"
HOMEPAGE="https://github.com/apmorton/pyhidapi https://pypi.org/project/hid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/hidapi
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" setup.py test || die
}
