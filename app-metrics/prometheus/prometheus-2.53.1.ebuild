# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
MY_PV=v${PV/_rc/-rc.}

# create deps/assets tarball
# >> git clone https://github.com/prometheus/prometheus/ -b v<version> /tmp/prometheus
# >> cd /tmp/prometheus && version=`git describe --tags | sed -E "s/v0.([0-9.]+)/2.\1/g"
# >> GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw -x
# >> tar -caf prometheus-${version}-deps.tar.xz go-mod
# >> make assets-compress &&  tar -caf prometheus-${version}-assets.tar.xz web/ui

DESCRIPTION="Prometheus monitoring system and time series database"
HOMEPAGE="https://github.com/prometheus/prometheus"
SRC_URI="https://github.com/prometheus/prometheus/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://vendors.simple-co.de/${PN}/${P}-deps.tar.xz
	https://vendors.simple-co.de/${PN}/${P}-assets.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"

COMMON_DEPEND="
	acct-group/prometheus
	acct-user/prometheus"
DEPEND="
	!app-metrics/prometheus-bin
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

BDEPEND=">=dev-util/promu-0.15.0"

RESTRICT+=" test"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/HEAD/" \
		-e "s/{{.Revision}}/${PR}/" \
		-e "s/{{.Version}}/${PV}/" \
		.promu.yml || die
	cp -a -u "${WORKDIR}"/web/ui web || die "cp failed"
}

src_compile() {
	emake PROMU="${EPREFIX}"/usr/bin/promu common-build plugins
}

src_install() {
	dobin prometheus promtool
	dodoc -r {documentation,{README,CHANGELOG,CONTRIBUTING}.md}
	insinto /usr/share/prometheus
	doins -r console_libraries consoles
	insinto /etc/prometheus
	doins documentation/examples/prometheus.yml
	dosym -r /usr/share/prometheus/console_libraries /etc/prometheus/console_libraries
	dosym -r /usr/share/prometheus/consoles /etc/prometheus/consoles

	systemd_dounit "${FILESDIR}"/prometheus.service
	newinitd "${FILESDIR}"/prometheus.initd prometheus
	newconfd "${FILESDIR}"/prometheus.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}

pkg_postinst() {
	if has_version '<net-analyzer/prometheus-2.0.0_rc0'; then
		ewarn "Old prometheus 1.x TSDB won't be converted to the new prometheus 2.0 format"
		ewarn "Be aware that the old data currently cannot be accessed with prometheus 2.0"
		ewarn "This release requires a clean storage directory and is not compatible with"
		ewarn "files created by previous beta releases"
	fi
}
