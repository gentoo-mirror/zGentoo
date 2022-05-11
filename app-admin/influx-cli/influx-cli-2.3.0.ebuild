# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

## WARN
# This ebuild is still WIP! Expect issues. If you find one - please contribute!
# The best place for this is dicord(currently): https://discord.gg/f8xbb6g
#
# Due to the mass of dependencies, LICENSEs might not be complete. (TODO)

EAPI=8
inherit go-module systemd
go-module_set_globals


DESCRIPTION="CLI for managing resources in InfluxDB v2"
HOMEPAGE="https://github.com/influxdata/${PN}"
SRC_URI="
	https://github.com/influxdata/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
"
RESTRICT="mirror"

LICENSE="MIT BSD Apache-2.0 EPL-1.0 MPL-2.0 BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=""
COMMON_DEPEND=""
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	go build -ldflags="-X main.version=${PV}" -o ${S}/bin/influx ${S}/cmd/influx || die "compile failed"
}

src_install() {
	dobin bin/influx
	dosym /usr/bin/influx /usr/bin/influx-cli

	# docs
	dodoc *.md
}
