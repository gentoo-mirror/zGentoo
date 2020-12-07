# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )

inherit desktop xdg-utils python-single-r1 cmake-utils llvm

DESCRIPTION="A Hex Editor for Reverse Engineers, Programmers and people that value their eye sight when working at 3 AM."
HOMEPAGE="https://github.com/WerWolv/ImHex"
SRC_URI="https://github.com/WerWolv/ImHex/archive/v${PV}.tar.gz"
S="${WORKDIR}/ImHex-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
  ${PYTHON_DEPS}
  sys-devel/llvm:=
  media-libs/glfw
  media-libs/glm
  sys-apps/file
  dev-libs/openssl
  dev-libs/capstone
  sys-devel/llvm
  dev-cpp/nlohmann_json
  dev-lang/python
"
RDEPEND="${DEPEND}"
BDEPEND="
  dev-util/cmake
"

src_install() {
	# Install executable
	exeinto /opt/${PN}
	doexe ${BUILD_DIR}/ImHex
	fperms +x /opt/${PN}/ImHex

	# Symlink executable
	dodir /opt/bin
	dosym ../${PN}/ImHex /opt/bin/ImHex

	# Install auxiliary files
	insinto /opt/${PN}
	doins ${S}/icon.ico
	doins -r ${S}/python_libs/lib/.

	make_desktop_entry /opt/bin/ImHex "ImHex" /opt/${PN}/icon.ico "Editor"

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
