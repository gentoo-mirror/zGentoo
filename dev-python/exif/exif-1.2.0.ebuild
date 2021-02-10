# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit edos2unix distutils-r1

DESCRIPTION="Read and modify image EXIF metadata using Python"
HOMEPAGE="https://gitlab.com/TNThieding/exif
	https://pypi.org/project/exif/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/plum-py"

python_test() {
	"${PYTHON}" setup.py test || die
}
