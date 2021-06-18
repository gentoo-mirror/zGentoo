# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils webapp

DESCRIPTION="Simple, modern and fast web-based email client (community-edition)"
HOMEPAGE="http://www.rainloop.net"
SRC_URI="https://github.com/RainLoop/rainloop-webmail/releases/download/v${PV}/${P}.zip"
LICENSE="AGPL-3"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[curl,iconv,json,ssl,xml]
	virtual/httpd-php"

S=${WORKDIR}

src_prepare() {
	eapply_user
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_src_install
}