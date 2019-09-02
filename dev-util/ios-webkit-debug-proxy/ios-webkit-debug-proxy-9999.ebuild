# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools git-2

DESCRIPTION="The ios_webkit_debug_proxy allows developers to inspect MobileSafari and UIWebViews on real and simulated iOS devices via the DevTools UI and WebKit Remote Debugging Protocol. "
HOMEPAGE="https://github.com/google/ios-webkit-debug-proxy"
EGIT_REPO_URI="git://github.com/google/ios-webkit-debug-proxy.git"
EGIT_COMMIT="master"

LICENSE="Google BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/automake
	dev-libs/libusb
	app-pda/libplist
	app-pda/libusbmuxd
	app-pda/usbmuxd
	app-pda/libimobiledevice"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}

