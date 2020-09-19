# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/schollz/croc"
inherit golang-build golang-vcs-snapshot

SRC_URI="https://${EGO_PN}/releases/download/v${PV}/croc_${PV}_src.tar.gz"

DESCRIPTION="a tool that allows any two computers to simply and securely transfer files and folders"
HOMEPAGE="https:/github.com/schollz/croc"
LICENSE="MIT"
SLOT=0
IUSE=""
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="${DEPEND}"

src_prepare() {
	default
}

src_install() {
	dobin ${PN}
	dodoc src/${EGO_PN}/README.md
}
