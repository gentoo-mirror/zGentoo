# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit edos2unix distutils-r1

MY_PV=${PVR/-r/.post}

DESCRIPTION="Python bindings for Linux SMBus access through i2c-dev"
HOMEPAGE="https://pypi.org/project/smbus"
#SRC_URI="https://files.pythonhosted.org/packages/4d/5c/70e14aa4f0c586efc017e1d1aa6e2f7921eefc7602fc2d03368ff912aa91/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

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
