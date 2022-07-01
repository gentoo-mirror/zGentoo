# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Common utilities for Synapse, Sydent and Sygnal."
HOMEPAGE="https://github.com/matrix-org/matrix-python-common https://pypi.python.org/pypi/matrix-common"
SRC_URI="https://github.com/matrix-org/matrix-python-common/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/matrix-python-common-${PV/_rc/rc}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
    dev-python/attrs[${PYTHON_USEDEP}]"
