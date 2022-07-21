# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 systemd

DESCRIPTION="An immutable dictionary"
HOMEPAGE="https://pypi.python.org/pypi/matrix-webhook https://github.com/nim65s/matrix-webhook"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	acct-user/${PN}
    acct-group/${PN}"
RDEPEND="${DEPEND}
    dev-python/aiofiles
    dev-python/aiohttp
    dev-python/aiohttp-socks
    dev-python/h11
    dev-python/h2
    dev-python/logbook
    dev-python/markdown
    dev-python/matrix-nio"

python_install_all() {
    newconfd "${FILESDIR}"/${PN}.confd ${PN}
    systemd_dounit "${FILESDIR}"/${PN}.service

    distutils-r1_python_install_all
}
