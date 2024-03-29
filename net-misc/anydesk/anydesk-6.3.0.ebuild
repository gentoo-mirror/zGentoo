# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop systemd xdg-utils

DESCRIPTION="Feature rich multi-platform remote desktop application"
HOMEPAGE="https://anydesk.com"
SRC_URI="
	https://download.anydesk.com/linux/${P}-amd64.tar.gz
	https://download.anydesk.com/linux/generic-linux/${P}-amd64.tar.gz
"

# OpeSSL/SSLeay, libvpx, zlib, Xiph, xxHash
LICENSE="AnyDesk-TOS BSD BSD-2 openssl ZLIB"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND=(
	">=dev-util/patchelf-0.10"
)
RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/glu
	media-libs/mesa[X(+)]
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/gtkglext
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXtst
	x11-libs/pango
"

RESTRICT="bindist mirror"

QA_PREBUILT="opt/${PN}/*"

src_install() {
	local dst="/opt/${PN}"

    ## removing dynamik linkage of pangox
    patchelf --remove-needed libpangox-1.0.so.0 ${PN}

	dodir ${dst}
	exeinto ${dst}
	doexe ${PN}

	dodir /opt/bin

	dosym ${dst}/${PN} /opt/bin/${PN}

	newinitd "${FILESDIR}"/anydesk.init anydesk
	systemd_newunit "${FILESDIR}"/anydesk.service anydesk.service

	insinto /usr/share/polkit-1/actions
	doins polkit-1/com.anydesk.anydesk.policy

	insinto /usr/share
	doins -r icons

	domenu "${FILESDIR}"/anydesk.desktop

	keepdir /etc/${PN}

	dodoc copyright README
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To run AnyDesk as background service use:"
		elog
		elog "OpenRC:"
		elog "# rc-service anydesk start"
		elog "# rc-update add anydesk default"
		elog
		elog "Systemd:"
		elog "# systemctl start anydesk.service"
		elog "# systemctl enable anydesk.service"
		elog
		elog "Please see README at /usr/share/doc/${PF}/README.bz2 for"
		elog "further information about the linux version of AnyDesk."
		elog
	fi

	elog "For querying information about the host PC AnyDesk calls"
	elog "the following commands. Feel free to install them, but it"
	elog "should run without as well."
	elog
	optfeature "lsb_release" sys-apps/lsb-release
	optfeature "lspci" sys-apps/pciutils
	optfeature "lsusb" sys-apps/usbutils
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
