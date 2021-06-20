# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Cross-platform tool and drivers for liquid coolers and other devices"
HOMEPAGE="https://github.com/jonasmalacofilho/liquidctl"
SRC_URI="https://github.com/jonasmalacofilho/liquidctl/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+experimental"

BDEPEND="dev-libs/libusb:1
        dev-libs/hidapi
        dev-python/docopt
        dev-python/pyusb
        dev-python/setuptools"

# TODO: need smbus and hidus (from pypi/pip) as dependencies

RDEPEND="${BDEPEND}"
