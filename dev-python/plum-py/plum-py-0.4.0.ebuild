# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit edos2unix distutils-r1 git-r3

DESCRIPTION="Pack/Unpack Memory"
HOMEPAGE="https://gitlab.com/dangass/plum/
	https://pypi.org/project/plum-py/"
EGIT_REPO_URI="https://gitlab.com/dangass/plum.git"
EGIT_COMMIT="6a9ff863"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	"${PYTHON}" setup.py test || die
}
