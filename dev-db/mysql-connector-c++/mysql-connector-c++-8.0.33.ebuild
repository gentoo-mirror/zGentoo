# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

URI_DIR="Connector-C++"
DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="Artistic GPL-2"
SLOT="0"
# -ppc, -sparc for bug #711940
KEYWORDS="amd64 arm ~arm64 -ppc ppc64 -sparc x86"
IUSE="+legacy"

RDEPEND="
    app-arch/lz4:=
    app-arch/zstd:=
    dev-libs/openssl:=
    >=dev-libs/protobuf-3.19.6:=
    sys-libs/zlib
    legacy? (
        dev-libs/boost:=
        >=dev-db/mysql-connector-c-8.0.27:=
    )
"
DEPEND="${RDEPEND}"

PATCHES=(
    "${FILESDIR}"/${P}-build-info.patch
    "${FILESDIR}"/${PN}-8.0.27-mysqlclient_r.patch
)

src_prepare() {
    # patching backported-logger (if protobuf >=23)
    if [ `printf "%.0f" $(protoc --version | awk '{print $2}' | bc | sed 's/[.]/,/')` -ge 23 ]; then
        eapply "${FILESDIR}"/${P}-backport-logging.patch
        sed -i "s/zero_copy_stream.h>/zero_copy_stream.h>\n#include\ \"..\/..\/..\/..\/include\/logging\/logging.h\"/g" "${S}"/cdk/protocol/mysqlx/protocol.cc || die
    fi
    sed -i 's/LibraryLoader : public util::nocopy/LibraryLoader/g' "${S}"/jdbc/driver/nativeapi/library_loader.h || die
    cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
        -DBUNDLE_DEPENDENCIES=OFF
        -DWITH_PROTOBUF=system
        -DWITH_LZ4=system
        -DWITH_SSL=system
        -DWITH_ZLIB=system
        -DWITH_ZSTD=system
        -DWITH_JDBC=$(usex legacy)
    )

    if use legacy ; then
        mycmakeargs+=(
            -DWITH_BOOST="${ESYSROOT}"/usr
            -DMYSQLCLIENT_STATIC_BINDING=0
            -DMYSQLCLIENT_STATIC_LINKING=0
        )
    fi

    cmake_src_configure
}
