# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit edos2unix distutils-r1

DESCRIPTION="Read and modify image EXIF metadata using Python"
HOMEPAGE="https://gitlab.com/TNThieding/exif https://pypi.org/project/exif"
SRC_URI="https://gitlab.com/TNThieding/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

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
