# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

_PN=${PN/-bin/}
inherit pam xdg desktop

DESCRIPTION="Yet another remote desktop software, written in Rust."
HOMEPAGE="https://rustdesk.com/"
SRC_URI="https://github.com/${_PN}/${_PN}/releases/download/${PV}/${_PN}-${PV}-x86_64.deb"

LICENSE="AGPL-3.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

## TODO: add all needed DEPS(!) - still WiP
RDEPEND="
    x11-misc/xdotool
    x11-libs/libvdpau
"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="
    /usr/lib/${_PN}/${_PN}
    /usr/lib/${_PN}/lib/lib${_PN}.so
    /usr/lib/${_PN}/lib/libapp.so
    /usr/lib/${_PN}/lib/libdesktop_drop_plugin.so
    /usr/lib/${_PN}/lib/libdesktop_multi_window_plugin.so
    /usr/lib/${_PN}/lib/libflutter_custom_cursor_plugin.so
    /usr/lib/${_PN}/lib/libflutter_linux_gtk.so
    /usr/lib/${_PN}/lib/libscreen_retriever_plugin.so
    /usr/lib/${_PN}/lib/libtexture_rgba_renderer_plugin.so
    /usr/lib/${_PN}/lib/liburl_launcher_linux_plugin.so
    /usr/lib/${_PN}/lib/libwindow_manager_plugin.so
    /usr/lib/${_PN}/lib/libwindow_size_plugin.so
"

src_unpack() {
    default
    mkdir -p "${S}"
    tar xf data.tar.xz -C "${S}"
}

src_install() {
    insinto /
    doins -r .

    # bin
    chmod +x "${D}"/usr/lib/${_PN}/${_PN}
    chmod +x "${D}"/usr/share/rustdesk/files/polkit
    dosym /usr/lib/${_PN}/${_PN} /usr/bin/${_PN}

    # pam
    dopamd etc/pam.d/rustdesk
    # desktop
    domenu usr/share/applications/${_PN}.desktop
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}