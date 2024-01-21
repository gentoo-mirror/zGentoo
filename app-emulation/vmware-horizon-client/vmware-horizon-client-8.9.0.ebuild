# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="VMware Horizon View client"
HOMEPAGE="https://my.vmware.com/web/vmware/info/slug/desktop_end_user_computing/vmware_horizon_clients/8_0"
SRC_URI="https://download3.vmware.com/software/CART24FQ1_LIN64_2303/VMware-Horizon-Client-2303-${PV}-21435420.x64.bundle -> ${PF}.bin"

RESTRICT="mirror"

LICENSE="vmware"
SLOT="0/2303"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-arch/bzip2
	dev-libs/atk
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib
	dev-libs/icu
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/libsigc++
	dev-libs/libxml2
	media-gfx/graphite2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng
	sys-apps/util-linux
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango
	x11-libs/pixman
"
RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib/vmware/*"

#
# VMware bundle is in $DISTDIR
#
src_unpack() {
	cp -L "${DISTDIR}/${A}" "$WORKDIR"   # Bundle is symlink; to workdir
	chmod +x "${WORKDIR}/${A}"           # Bundle is not executable
	"${WORKDIR}/${A}" -x "$S" --console  # Extract contents from bundle
}

#
# Installs:
#   VMware Horizon Client
#   VMware Horizon Seamless Window support (required as of 4.9.0)
#   VMware PCoIP support
#
# NOTE:
#   This ebuild prefers to use the bundled OpenSSL and older PNG
#   libraries (1.2.x), instead of using the system libraries
#
src_install() {
	#
	# VMware Horizon client
	#
	cd "${S}/vmware-horizon-client"

	# Client shell wrapper
	dobin bin/vmware-view

	# Client library
	exeinto usr/lib/vmware/view/bin
	doexe lib/vmware/view/bin/vmware-view

	insinto usr/lib/vmware/view/env/
	doins -r lib/vmware/view/env/*

	insinto usr/lib/vmware
	insopts -m755
	doins -r lib/vmware/view/lib/*

	cd "${S}/vmware-horizon-pcoip/lib"

	insinto usr/lib/vmware
	insopts -m755
	doins -r vmware/*

	cd "${S}/vmware-horizon-hosted-apps/lib"

	insinto usr/lib/vmware
	insopts -m755
	doins -r vmware/*

	# These are not necessary from the 'doins' above
	rm -rf "${ED}/usr/lib/vmware/rdpvcbridge"
	rm -rf "${ED}/usr/lib/vmware/xkeymap"
	rm -rf "${ED}/usr/lib/vmware/view/crtbora"
	rm -rf "${ED}/usr/lib/vmware/view/software"
	rm -rf "${ED}/usr/lib/vmware/view/vdpService"

	# Create libudev.so.0 symlink if necessary
	if [[ -f "/$(get_libdir)/libudev.so.1" ]]; then
		dosym "/$(get_libdir)/libudev.so.1" "usr/lib/vmware/libudev.so.0"
	fi
}
