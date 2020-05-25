# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTORECONF=yes

inherit eutils autotools

DESCRIPTION="HIDAPI library for Windows, Linux, FreeBSD and macOS"
HOMEPAGE="https://github.com/libusb/hidapi"
SRC_URI="https://github.com/libusb/${PN}/archive/${P}.tar.gz"

LICENSE="|| ( BSD GPL-3 HIDAPI )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="doc fox static-libs"

RDEPEND="virtual/libusb:1
	virtual/libudev:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	fox? ( x11-libs/fox )"

## stupid
S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	if ! use fox; then
		sed -i -e 's:PKG_CHECK_MODULES(\[fox\], .*):AC_SUBST(fox_CFLAGS,[ ])AC_SUBST(fox_LIBS,[ ]):' configure.ac || die
	fi

	eapply_user

	eautoreconf
}

src_configure() {
	local myconf

	use fox && myconf="${myconf} --enable-fox"
	econf \
		${myconf}

	emake
}
