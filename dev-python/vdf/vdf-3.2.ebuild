# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Package for working with Valve's text and binary KeyValue format"
HOMEPAGE="https://github.com/ValvePython/vdf"
SRC_URI="https://github.com/ValvePython/vdf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]"
DEPEND="
    ${RDEPEND}
    dev-python/setuptools[${PYTHON_USEDEP}]"
