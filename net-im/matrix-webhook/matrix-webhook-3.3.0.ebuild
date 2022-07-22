# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 systemd

DESCRIPTION="Post a message to a matrix room with a simple HTTP POST"
HOMEPAGE="https://pypi.python.org/pypi/matrix-webhook https://github.com/nim65s/matrix-webhook"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+e2e"

DEPEND="
	acct-user/${PN}
    acct-group/${PN}"
RDEPEND="${DEPEND}
    dev-python/aiofiles[${PYTHON_USEDEP}]
    dev-python/aiohttp[${PYTHON_USEDEP}]
    dev-python/aiohttp-socks[${PYTHON_USEDEP}]
    dev-python/future[${PYTHON_USEDEP}]
    dev-python/h11[${PYTHON_USEDEP}]
    dev-python/h2[${PYTHON_USEDEP}]
    dev-python/jsonschema[${PYTHON_USEDEP}]
    dev-python/logbook[${PYTHON_USEDEP}]
    dev-python/markdown[${PYTHON_USEDEP}]
    dev-python/matrix-nio[${PYTHON_USEDEP}]
    e2e? ( dev-python/matrix-nio[${PYTHON_USEDEP},e2e] )
    dev-python/pycryptodome[${PYTHON_USEDEP}]
    dev-python/unpaddedbase64[${PYTHON_USEDEP}]"

python_install_all() {
    newconfd "${FILESDIR}"/${PN}.confd ${PN}
    systemd_dounit "${FILESDIR}"/${PN}.service

    distutils-r1_python_install_all
}
