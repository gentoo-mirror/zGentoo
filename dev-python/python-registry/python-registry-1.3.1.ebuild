# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 git-r3

DESCRIPTION="Cross-Platform Windows Registry Browser"
HOMEPAGE="https://github.com/williballenthin/python-registry https://pypi.org/project/python-registry"
EGIT_REPO_URI="https://github.com/williballenthin/python-registry.git"
EGIT_TAG="${PV}"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	"${PYTHON}" setup.py test || die
}
