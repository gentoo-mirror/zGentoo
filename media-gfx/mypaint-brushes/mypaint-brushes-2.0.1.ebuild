# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Brushes used by MyPaint and other software using libmypaint"
HOMEPAGE="https://github.com/mypaint/mypaint-brushes"
SRC_URI="https://github.com/mypaint/mypaint-brushes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="2.0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	eapply_user
	eautoreconf
}
