# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit edos2unix distutils-r1

DESCRIPTION="Wrapper library of google-api-python-client"
HOMEPAGE="https://github.com/iterative/PyDrive2 https://pypi.org/project/PyDrive2"
SRC_URI="https://files.pythonhosted.org/packages/bd/37/f256fce47c0bd63af9e8c63253e144f26e22ad5969dc83dfa59282ff11cb/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/google-api-python-client[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" setup.py test || die
}
