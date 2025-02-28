# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

DESCRIPTION="Seafile desktop client"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile-client/"
SRC_URI="https://github.com/haiwen/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="shibboleth test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/jansson:=
	dev-libs/openssl:=
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	>=net-libs/libsearpc-3.3.0
	~net-misc/seafile-${PV}
	sys-libs/zlib
	virtual/opengl
	elibc_musl? ( sys-libs/fts-standalone )
	shibboleth? ( dev-qt/qtwebengine:6[widgets] )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist,widgets]"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
		-DBUILD_TESTING="$(usex test)"
	)
	# 863554
	use elibc_musl && mycmakeargs+=( -DCMAKE_CXX_STANDARD_LIBRARIES="-lfts" )
	cmake_src_configure
}
