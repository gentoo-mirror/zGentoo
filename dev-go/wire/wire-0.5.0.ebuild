# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wire: Automated Initialization in Go"
HOMEPAGE="https://github.com/google/${PN}"
SRC_URI="
	https://github.com/google/${PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz
	https://vendors.simple-co.de/${PN}/vendor-${P}.tar.xz
"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
>=dev-lang/go-1.16
"

src_unpack() {
	default
	mv vendor ${S}/vendor
}

src_compile() {
	GO111MODULE=on GOCACHE="${T}"/go-cache go build -mod=vendor -o ./bin/${PN} ./cmd/wire/main.go
}

src_install() {
	dobin bin/*
	dodoc {README,CONTRIBUTING}.md
}
