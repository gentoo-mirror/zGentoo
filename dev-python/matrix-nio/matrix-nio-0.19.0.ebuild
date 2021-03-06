# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Multilayered Matrix client library"
HOMEPAGE="https://pypi.python.org/pypi/matrix-nio https://github.com/poljar/matrix-nio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+e2e"

DEPEND=""
BDEPEND="e2e? ( dev-python/python-olm )"
RDEPEND="${DEPEND}"
