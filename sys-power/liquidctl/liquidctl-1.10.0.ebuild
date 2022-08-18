# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Cross-platform tool and drivers for liquid coolers and other devices"
HOMEPAGE="https://github.com/jonasmalacofilho/liquidctl"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+experimental"

BDEPEND="dev-libs/libusb:1
        dev-libs/hidapi
        dev-python/docopt[${PYTHON_USEDEP}]
        dev-python/pyusb[${PYTHON_USEDEP}]
        dev-python/setuptools[${PYTHON_USEDEP}]
        dev-python/hidapi[${PYTHON_USEDEP}]
        dev-python/smbus[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
