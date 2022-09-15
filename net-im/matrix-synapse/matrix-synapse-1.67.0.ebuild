# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 systemd

DESCRIPTION="Synapse: Matrix reference homeserver"
HOMEPAGE="http://matrix.org"
LICENSE="GPL-3"

SRC_URI="https://github.com/matrix-org/synapse/archive/v${PV/_rc/rc}.tar.gz -> ${P/_rc/rc}.tar.gz"
S="${WORKDIR}/synapse-${PV/_rc/rc}"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="systemd +hiredis"

RDEPEND="
	acct-user/synapse
    acct-group/synapse
	dev-db/redis
	hiredis? ( dev-python/hiredis[${PYTHON_USEDEP}] )
	systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/bcrypt-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/bleach-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/canonicaljson-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/daemonize-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/frozendict-2.3.2[${PYTHON_USEDEP}]
	>=dev-python/ijson-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-4.11.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/phonenumbers-8.2.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.1.2[jpeg,${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.7[${PYTHON_USEDEP}]
	>=dev-python/pymacaroons-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/redis-py-4.2.2[${PYTHON_USEDEP}]
	>=dev-python/service_identity-16.0.0[${PYTHON_USEDEP}]
	>=dev-python/signedjson-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/treq-15.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.9.0[${PYTHON_USEDEP}]
	>=dev-python/txredisapi-1.4.7[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/unpaddedbase64-2.1.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all

    # config
    insinto /etc/synapse
    doins "${FILESDIR}"/server.yaml.example

    # service
    if use systemd; then 
        systemd_dounit  "${FILESDIR}"/synapse.service
    else
	    newinitd "${FILESDIR}"/synapse.initd synapse
    fi

    # env-conf
	newconfd "${FILESDIR}"/synapse.confd synapse
}

pkg_postinst() {
    ewarn "Don't forget to configure your synapse instance before starting"
    ewarn "the daemon, using the following command:"
    ewarn
    ewarn "$ cd /etc/synapse; \\"
    ewarn " python -m synapse.app.homeserver \\"
    ewarn " -H <SERVERNAME> -c server.yaml \\"
    ewarn " --generate-config --report-stats=no \\"
    ewarn " --data-directory /var/lib/synapse \\"
    ewarn " --config-directory /etc/synapse \\"
    ewarn " --keys-directory /etc/synapse"
    ewarn
    ewarn "And make sure to point your log somwhere inside /var/lib/synapse"
}