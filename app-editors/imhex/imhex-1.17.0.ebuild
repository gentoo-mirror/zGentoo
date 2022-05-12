# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit git-r3 desktop xdg-utils python-single-r1 cmake

DESCRIPTION="A hex editor for reverse engineers, programmers, and eyesight"
HOMEPAGE="https://github.com/WerWolv/ImHex"
EGIT_REPO_URI="https://github.com/WerWolv/ImHex.git"
SRC_URI="https://github.com/WerWolv/ImHex-Patterns/archive/448a81a06dd39f160d1770989d41b6dba7338753.zip -> imhex-patterns-${PV}.zip"

# see: https://github.com/WerWolv/ImHex/blob/v${PV}/.gitmodules
EGIT_SUBMODULES=(
	lib/external/capstone
	lib/external/curl
	lib/external/fmt
	lib/external/libromfs
	lib/external/nativefiledialog
	lib/external/pattern_language
	lib/external/xdgpp
	lib/external/yara/yara
)
EGIT_TAG="v${PV}"
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

CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	## we respect the network-sandbox!
	_POS=`grep -n downloadImHexPatternsFiles cmake/build_helpers.cmake | cut -d: -f1`
	sed -i "${_POS},\$d" cmake/build_helpers.cmake || \
		die "couldn't patch build_helpers to respect the sandbox"
	sed -i "s/downloadImHexPatternsFiles/#downloadImHexPatternsFiles/g" CMakeLists.txt || \
		die "couldn't patch CMakeLists to respect the sandbox"

	## unpacking imhex-patterns
	unpack imhex-patterns-${PV}.zip
	mv ${S}/ImHex-Patterns-*/{constants,encodings,includes,patterns,magic} .

	## configure
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
	newlib.so ${BUILD_DIR}/lib/lib${PN}/lib${PN}.so lib${PN}.so


	insinto /usr/share/${PN}/plugins/
	doins ${BUILD_DIR}/plugins/builtin/builtin.hexplug

	insinto /usr/share/${PN}
	doins -r ${S}/resources/lib/python/lib/.

	# create desktop icon
	doicon ${S}/resources/icon.png
	make_desktop_entry ${PN} "ImHex" icon "Editor;X-Editor"

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
