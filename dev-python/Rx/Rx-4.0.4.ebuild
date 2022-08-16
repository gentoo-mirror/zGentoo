# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 virtualx

MY_P="RxPY-${PV}"
DESCRIPTION="Reactive Extensions for Python"
HOMEPAGE="http://reactivex.io/"
SRC_URI="https://github.com/ReactiveX/RxPY/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? ( dev-python/pytest-asyncio[${PYTHON_USEDEP}] )
	dev-python/pyproject2setuppy
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
