# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Forward alerts from Grafana to a Matrix chat room."
HOMEPAGE="https://gitlab.com/hectorjsmith/grafana-matrix-forwarder"

go-module_set_globals
SRC_URI="
    https://gitlab.com/hectorjsmith/${PN}/-/archive/${PV}/${P}.tar.gz
	https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
"
### build vendor budle:
# mkdir -p grafana-matrix-forwarder-<version>/src/
# cd src && go mod vendor && mv vendor ../grafana-matrix-forwarder-<version>/src/ && cd ..
# tar -c -I 'xz -9 -T0' -f vendor-grafana-matrix-forwarder-<version>.tar.xz grafana-matrix-forwarder-<version>

LICENSE="MIT BSD-3 MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm"

DEPEND="
	acct-group/${PN}
	acct-user/${PN}"
BDEPEND="dev-lang/go"

src_compile() {
	(cd src && go build -o ../bin/${PN}) || die "Can't compile ${PN}"
}

src_install() {
    dobin bin/*

    systemd_dounit "${FILESDIR}"/${PN}.service
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

    dodoc -r {README,CHANGELOG}.md
}
