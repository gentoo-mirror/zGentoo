# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit systemd

DESCRIPTION="Prometheus exporter for snmp metrics"
HOMEPAGE="https://github.com/prometheus/snmp_exporter"
SRC_URI="
	https://github.com/prometheus/snmp_exporter/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz
	https://vendors.retarded.farm/snmp_exporter/vendor-${P}.tar.xz
"
## vendor archive: go mod vendor

KEYWORDS="~amd64"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="systemd"

DEPEND=">=dev-lang/go-1.16
	net-analyzer/net-snmp
	acct-group/${PN}
	acct-user/${PN}"

src_unpack() {
	default
	mv vendor ${S}/vendor
}

src_compile() {
	pushd ${S} || die
	BDT=`date --iso-8601=seconds`
	GO111MODULE=on GOCACHE="${T}"/go-cache go build -mod=vendor -o ./bin/${PN} -ldflags " \
		-X github.com/prometheus/common/version.Version=${PV} \
		-X github.com/prometheus/common/version.Revision=${PR} \
		-X github.com/prometheus/common/version.Branch=non-git \
		-X github.com/prometheus/common/version.BuildUser=portage \
		-X github.com/prometheus/common/version.BuildDate=${BDT} \
		" -a -tags netgo .
	pushd generator || die
	GO111MODULE=on GOCACHE="${T}"/go-cache go build -mod=vendor -o ../bin/generator . || die
	popd || die
}

src_install() {
	pushd ${S} || die
	dobin bin/*
	dodoc {README,CONTRIBUTING}.md generator/{FORMAT,README}.md generator/generator.yml
	insinto /etc/snmp_exporter
	newins snmp.yml snmp.yml.example
	popd || die
	keepdir /var/lib/snmp_exporter /var/log/snmp_exporter
	fowners ${PN}:${PN} /var/lib/snmp_exporter /var/log/snmp_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"

	## installing environment and services
	newconfd "${FILESDIR}"/snmp_exporter.confd snmp_exporter
	newinitd "${FILESDIR}"/snmp_exporter.initd snmp_exporter
	use systemd && systemd_newunit "${FILESDIR}"/snmp_exporter.service snmp_exporter.service
}
