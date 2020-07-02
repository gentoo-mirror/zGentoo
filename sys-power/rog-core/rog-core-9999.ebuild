# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd cargo git-r3

DESCRIPTION="rog-core is a utility for Linux to control many aspects (eventually) of the ASUS ROG laptops like the Zephyrus GX502GW."
HOMEPAGE="https://github.com/flukejones/rog-core"
EGIT_REPO_URI="https://github.com/flukejones/${PN}.git"

LICENSE="MPL-2.0"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
"
CARGO_INSTALL_PATH="${PN}"

src_unpack() {
    default
    git-r3_src_unpack
    cargo_live_src_unpack
}

src_install() {
    cargo_src_install

    insinto /etc
    if [ -f data/rogcore.conf ]; then
        doins data/rogcore.conf && ewarn Resetted /etc/rogcore.conf make sure to check your settings!
    else
        doins "${FILESDIR}"/rogcore.conf && ewarn Resetted /etc/rogcore.conf make sure to check your settings!
    fi

    insinto /usr/share/dbus-1/system.d/
    doins data/${PN}.conf
    
    systemd_dounit data/${PN}.service
}

pkg_postinst() {
    ewarn "Don't forget to reload dbus and enable \"${PN}\" service, \
by runnning:\n'systemctl reload dbus && systemctl enable ${PN} \
&& systemctl start ${PN}'"
}
