# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A logging replacement for Python"
HOMEPAGE="https://logbook.readthedocs.io/en/stable/
	https://github.com/getlogbook/logbook
	https://pypi.org/project/Logbook/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE=""

BDEPEND="
	test? (
		app-arch/brotli[${PYTHON_USEDEP},python]
		dev-python/execnet[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!!dev-python/contextvars
	!!dev-python/gevent"

distutils_enable_tests pytest
distutils_enable_sphinx docs

python_prepare_all() {
	# Delete test file requiring local connection to redis server
	rm tests/test_queues.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	export DISABLE_LOGBOOK_CEXT=1
}
