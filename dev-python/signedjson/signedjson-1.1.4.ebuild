# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Signs JSON objects with ED25519 signatures."
HOMEPAGE="https://github.com/matrix-org/python-signedjson https://pypi.python.org/pypi/signedjson"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/_rc/.dev}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
