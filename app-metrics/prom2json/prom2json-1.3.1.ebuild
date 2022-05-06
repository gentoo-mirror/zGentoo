# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A tool to scrape a Prometheus client and dump the result as JSON"
HOMEPAGE="https://github.com/prometheus/prom2json"
SRC_URI="
	https://github.com/prometheus/prom2json/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
"
# default vendor package created using:
# > GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw && \
# > tar -c -I 'xz -9 -T0' -f vendor-prometheus-<version>.tar.xz vendor

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Revision}}/${PR}/" \
		-e "s/{{.Version}}/${PV}/" \
		.promu.yml || die
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CONTRIBUTING}.md
}
