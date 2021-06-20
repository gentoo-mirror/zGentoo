# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )

inherit git-r3 desktop xdg-utils python-single-r1 cmake

DESCRIPTION="A hex editor for reverse engineers, programmers, and eyesight"
HOMEPAGE="https://github.com/WerWolv/ImHex"
EGIT_REPO_URI="https://github.com/WerWolv/ImHex.git"
# SRC_URI="https://github.com/WerWolv/ImHex/archive/v${PV}.tar.gz"
EGIT_SUBMODULES=(
	external/nativefiledialog
	external/yara/yara
	external/xdgpp
	external/fmt
	external/curl
)
EGIT_COMMIT="0717d4a"
S="${WORKDIR}/ImHex-${PV}"
EGIT_CHECKOUT_DIR="${S}"

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
PATCHES=("${FILESDIR}/${P}-gcc11.patch")

CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	local mycmakeargs=(
        -Wno-dev
		-DCMAKE_BUILD_TYPE=RelWithDebInfo
		-DPROJECT_VERSION="${PV}"
    )
	cmake_src_configure

	## patching cmake_install directories
	sed -i "s/\/lib\//\/$(get_libdir)\//g" ${BUILD_DIR}/cmake_install.cmake || \
	sed -i "s/\/lib64\//\/$(get_libdir)\//g" ${BUILD_DIR}/cmake_install.cmake || \
	die "Couldn't patch library path for multilib"
}

src_install() {
	# can't use cmake_src_install, doing it manual
	newbin ${BUILD_DIR}/${PN} ${PN}
	newlib.so ${BUILD_DIR}/plugins/lib${PN}/lib${PN}.so lib${PN}.so
	newins ${BUILD_DIR}/plugins/builtin/builtin.hexplug /usr/bin/builtin.hexplug

	insinto /usr/share/${PN}
	doins -r ${S}/python_libs/lib/.
	doins ${S}/res/icon.ico
  	
	# create desktop icon
	make_desktop_entry /opt/${PV}/bin/imhex "ImHex" /usr/share/${PN}/icon.ico "X-Editor"

	# install docs
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
