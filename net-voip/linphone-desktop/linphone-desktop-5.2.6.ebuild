# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
IUSE="+av1 +codec2 -daemon doc -extras"

# language support
LANGS="cs da de en es fr_FR hu it ja lt pt_BR ru sv tr uk zh_CN"
for lang in ${LANGS}; do
    IUSE="${IUSE} linguas_${lang}"
done

inherit cmake distutils-r1 git-r3 xdg

DESCRIPTION="Open source softphone for voice and video over IP calling and instant messaging."
HOMEPAGE="https://www.linphone.org/technical-corner/linphone"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
#RESTRICT="test" # TODO

EGIT_REPO_URI="https://github.com/BelledonneCommunications/linphone-desktop.git"
EGIT_COMMIT="${PV}"
EGIT_SUBMODULES=(
    '*'
    '-linphone-sdk/external/*'
    'linphone-sdk/external/bv16-floatingpoint'
    'linphone-sdk/external/soci'
    'linphone-sdk/external/liboqs'
    'linphone-sdk/external/decaf'
)

RDEPEND="
    dev-db/sqlite
    dev-libs/jsoncpp
    dev-libs/libayatana-appindicator
    dev-libs/libxml2
    dev-libs/qtkeychain
    dev-libs/xerces-c
    dev-python/pystache[${PYTHON_USEDEP}]
    dev-python/six[${PYTHON_USEDEP}]
    dev-qt/linguist-tools[qml]
    dev-qt/qtmultimedia:5
    dev-qt/qtquickcontrols[widgets]
    dev-qt/qtquickcontrols2[widgets]
    media-libs/glew:0
    media-libs/libjpeg-turbo
    media-libs/libvpx
    media-libs/libyuv
    media-libs/opencore-amr
    media-libs/openh264
    media-libs/opus
    media-libs/speex
    media-libs/speexdsp
    media-libs/vo-amrwbenc
    media-libs/zxing-cpp
    media-sound/gsm
    media-video/ffmpeg
    net-libs/libsrtp:2
    net-libs/mbedtls
    net-nds/openldap
    av1? (
        media-libs/dav1d
        media-libs/libaom
    )
    codec2? ( media-libs/codec2 )
    doc? ( app-text/doxygen )
"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${P}-fix_enum.patch"

src_unpack() {
    git-r3_src_unpack
    default
}

src_prepare() {
    # invalid files (those are directories and must be removed)
    rm -rf linphone-sdk/external/liboqs/scripts/copy_from_upstream/src/CMakeLists.txt || die
    rm -rf linphone-sdk/external/liboqs/scripts/copy_from_upstream/CMakeLists.txt || die

    # patching non-default TLS_PEER_CN flag (this might cause serious problems)
    sed -i 's/LDAP_OPT_X_TLS_PEER_CN/0x601c/g' \
        linphone-sdk/liblinphone/src/ldap/ldap-contact-provider.cpp || die

    # patching post-build copyings
    sed -i -e "s~>\ \"~>\ \"/${T}/${P}~g" -e "s~/\"\ \"~\"\ \"/${T}/${P}~g" \
        linphone-app/CMakeLists.txt || die

    # removing jsoncpp (it does no longer provide cmake files)
    sed -i '/find_package(JsonCPP REQUIRED)/d' linphone-sdk/liblinphone/CMakeLists.txt || die

    # we must make sure that ${D}/usr/lib* exists during compile
    mkdir -p "${T}/${P}/usr/`get_libdir`" || die

    cmake_src_prepare
}

src_configure() {
    local LIBDIR="/usr/`get_libdir`"
    local mycmakeargs=(
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_SHARED_LIBS=ON
        -DENABLE_SHARED=ON

        # daemon
        -DENABLE_DOC=$(usex doc)
        -DENABLE_DAEMON=$(usex daemon)
        -DENABLE_TOOLS=$(usex extras)
        -DENABLE_AV1=$(usex av1)
        -DENABLE_CODEC2=$(usex codec2)

        # not availbale libs (must be build)
        -DBUILD_BV16=ON
        -DBUILD_LIBOQS=ON
        -DBUILD_SOCI=ON

        # disabled building external libs
        -DBUILD_AOM=OFF
        -DBUILD_CODEC2=OFF
        -DBUILD_DAV1D=OFF
        -DBUILD_FFMPEG=OFF
        -DBUILD_GSM=OFF
        -DBUILD_JSONCPP=OFF
        -DBUILD_LIBJPEGTURBO=OFF
        -DBUILD_LIBSRTP2=OFF
        -DBUILD_LIBVPX=OFF
        -DBUILD_LIBXML2=OFF
        -DBUILD_LIBYUV=OFF
        -DBUILD_MBEDTLS=OFF
        -DBUILD_OPENCORE_AMR=OFF
        -DBUILD_OPENH264=OFF
        -DBUILD_OPENLDAP=OFF
        -DBUILD_OPUS=OFF
        -DBUILD_SPEEX=OFF
        -DBUILD_SQLITE3=OFF
        -DBUILD_VO_AMRWBENC=OFF
        -DBUILD_XERCESC=OFF
        -DBUILD_ZLIB=OFF
        -DBUILD_ZXINGCPP=OFF

        # correcting targets
        -DOpenH264_TARGET=openh264
        -DJsonCPP_TARGET=jsoncpp
        -DDav1d_TARGET=dav1d
        -DAom_TARGET=aom

        # Qt5 adjustments (use system keychain)
        -DENABLE_QT_KEYCHAIN=OFF
        -DQTKEYCHAIN_TARGET_NAME=Qt5Keychain

        # correcting plugin paths
        -DLIBLINPHONE_PLUGINS_DIR=/opt/${PN}/plugins
        -DLINPHONE_PACKAGE_PLUGINS_DIR=/opt/${PN}/plugins

        # skipping RPATH
        -DCMAKE_SKIP_RPATH=ON

        # hide dev-warnings
        -Wno-dev

        # add missing include dirs
        -DCMAKE_CXX_FLAGS=-I\ /usr/include/openh264\ -I\ /usr/include/jsoncpp\ -I\ "${T}/${P}"/usr/include
    )
    cmake_src_configure
}

src_compile() {
    cmake_src_compile
    sed -i 's/RelWithDebInfo/Release/g' \
        "${WORKDIR}/${P}_build/cmake_install.cmake" || die

    ## some cleanup
    rm "${WORKDIR}/${P}_build/${PN%%-*}-app/assets"/*.ts
    rm "${WORKDIR}/${P}_build/${PN%%-*}-app/assets"/*.cmake
}

src_install() {
    cmake_src_install # this might produce "errors" (corrections below)

    # package base-name (linphone)
    local PBN=${PN%%-*}

    einfo "cleaning up build-fragments.."
    rm -rf "${D}"/usr/cmake
    rm -rf "${D}"/usr/include
    rm -rf "${D}"/usr/share/*/cmake
    rm -rf "${D}"/usr/share/BCUnit
    rm -rf "${D}"/usr/share/images
    rm -rf "${D}/usr/`get_libdir`"/cmake
    rm -rf "${D}/usr/`get_libdir`"/pkgconfig

    einfo "removing external docs.."
    rm -rf "${D}"/usr/share/doc/ortp*

    einfo "correcting qt-conf.."
    dodir /opt/${PN}/bin
    mv "${D}/usr/bin/qt.conf" "${D}/opt/${PN}/bin/qt.conf"


    einfo "installing plugin(s).."
    dodir "/opt/${PN}/plugins/"
    dosym "/usr/`get_libdir`/libsoci_core.so" "/opt/${PN}/plugins/libsoci_core.so"
    dosym "/usr/`get_libdir`/libsoci_sqlite3.so" "/opt/${PN}/plugins/libsoci_sqlite3.so"

    einfo "move binaries into right place.."
    for exf in "${D}"/usr/bin/*; do
        local exb=`basename ${exf}`
        exeinto /opt/${PN}/bin
        doexe ${exf}                                    # install from bin (exe)
        rm ${exf}                                       # remove installed bin
        dodir /opt/${PN}/bin
        dosym /opt/${PN}/bin/${exb} /usr/bin/${exb}     # re-link to bin
    done

    einfo "installing assets.."
    insinto /opt/${PN}
    doins -r "${WORKDIR}/${P}_build/${PBN}-app/assets"

    einfo "sanitizing languages.."
    for lang in ${LANGS}; do
        [ ${lang} == "en" ] && continue # skipt if default lang
        if ! use linguas_${lang} ; then
            rm "${D}/opt/${PN}/assets/languages/${lang}.qm"
            sed -i "/${lang}.qm/d" "${D}/opt/${PN}/assets/languages/i18n.qrc" || die
        fi
    done
}
