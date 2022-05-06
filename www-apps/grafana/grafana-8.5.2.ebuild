# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

MY_PV=${PV/_beta/-beta}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The open-source platform for monitoring and observability"
HOMEPAGE="https://grafana.com"
SRC_URI="
	https://github.com/grafana/grafana/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
	https://vendors.retarded.farm/${PN}/vendor_yarn-${P}.tar.xz
"
# default vendor pacakge created using:
# > go mod vendor && tar -c -I 'xz -9 -T0' -f vendor-grafana-<version>.tar.xz vendor
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="!www-apps/${PN}-bin
	acct-group/${PN}
	acct-user/${PN}
	media-libs/fontconfig
	>=net-libs/nodejs-16[icu]
	sys-apps/yarn
	>=dev-lang/go-1.16
	dev-go/wire"

QA_PRESTRIPPED="usr/bin/${PN}-*"

src_unpack() {
	default
	mv vendor ${S}/vendor
	mv vendor_yarn ${S}/vendor_yarn
}

src_prepare() {
	sed -i "s:;reporting_enabled = .*:reporting_enabled = false:" \
		conf/sample.ini || die "prepare failed"
	sed -i "s:;check_for_updates = .*:check_for_updates = false:" \
		conf/sample.ini || die "prepare failed"

	mkdir "plugins-bundled/external"

	## offline/cache installation
	echo "enableMirror: true" >> .yarnrc.yml
	echo "cacheFolder: ./vendor_yarn" >> .yarnrc.yml
	# to create the vendor package after the patch above:
	# > rm -rf vendor_yarn && yarn cache clean --mirror && yarn install
	# > tar -c -I 'xz -9 -T0' -f vendor_yarn-grafana-<version>.tar.xz vendor_yarn

	## install yarn deps(offline)..
	export CYPRESS_INSTALL_BINARY=0
	yarn install || die "prepare failed"

	default
}

src_compile() {
	addpredict /etc/npm

	einfo "Wiring everything up.."
	wire gen -tags oss ./pkg/server ./pkg/cmd/grafana-cli/runner || die "wiring failed"
	einfo "Building binaries using go.."
	go run -mod=vendor build.go build || die "compile failed"
	einfo "Building frontend using webpack.."
	# beware, we need at least 8G RAM (@32T)
	export NODE_OPTIONS="--max-old-space-size=8192"
	yarn run build || die "compile failed"
	yarn run plugins:build-bundled || die "compile failed"
}

src_install() {
	insinto /etc/grafana
	newins conf/sample.ini grafana.ini
	newins conf/ldap.toml ldap.toml

	dobin `(find bin -name grafana-cli)`
	dobin `(find bin -name grafana-server)`

	insinto "/usr/share/${PN}"
	doins -r public conf tools

	newconfd "${FILESDIR}/grafana.confd" "${PN}"
	newinitd "${FILESDIR}/grafana.initd" "${PN}"
	use systemd && systemd_newunit "${FILESDIR}/${PN}.service" "${PN}.service"

	keepdir /var/{lib,log}/grafana
	fowners grafana:grafana /var/{lib,log}/grafana
	fperms 0750 /var/{lib,log}/grafana

	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/lib/grafana/{dashboards,plugins}

	keepdir /etc/grafana
	fowners grafana:grafana /etc/grafana/{grafana.ini,ldap.toml}
	fperms 0640 /etc/grafana/{grafana.ini,ldap.toml}
}

postinst() {
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "/etc/grafana/grafana.ini for related settings."
	elog
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
}
