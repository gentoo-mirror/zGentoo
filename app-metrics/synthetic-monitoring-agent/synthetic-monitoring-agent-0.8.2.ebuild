# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

## WARN
# This ebauild was moved from net-analyzer/telegraf to app-metrics/telegraf
#
# This ebuild is still WIP! Expect issues. If you find one - please contribute!
# The best place for this is dicord(currently): https://discord.gg/f8xbb6g
#
# Due to the mass of dependencies, LICENSEs might not be complete. (TODO)

EAPI=8
inherit go-module systemd
go-module_set_globals

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics."
HOMEPAGE="https://github.com/grafana/synthetic-monitoring-agent"
SRC_URI="
    https://github.com/grafana/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
    https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
"
RESTRICT="mirror"

LICENSE="MIT BSD Apache-2.0 EPL-1.0 MPL-2.0 BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=""
DEPEND="acct-group/grafana
    acct-user/grafana"
RDEPEND="${DEPEND}"

src_compile() {
    go build -ldflags="-X main.version=${PV}" -o ${S}/bin/${PN} ${S}/cmd/${PN} || die "compile failed"
}

src_install() {
    dobin bin/${PN}

    # todo: implement config and services

    dodoc -r *.md

    keepdir /var/log/${PN}
    fowners grafana:grafana /var/log/${PN}
}
