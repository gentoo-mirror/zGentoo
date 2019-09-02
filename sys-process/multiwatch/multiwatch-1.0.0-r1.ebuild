# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools git-2

DESCRIPTION="multiwatch forks and watches multiple instances of a program"
HOMEPAGE="http://redmine.lighttpd.net/projects/multiwatch"
EGIT_REPO_URI="git://git.lighttpd.net/multiwatch.git"
EGIT_COMMIT="d23de523"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-libs/libev
	dev-libs/glib:2"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	doman multiwatch.1
}
