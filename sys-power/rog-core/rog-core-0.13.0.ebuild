# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd cargo

DESCRIPTION="rog-core is a utility for Linux to control many aspects (eventually) of the ASUS ROG laptops like the Zephyrus GX502GW."
HOMEPAGE="https://github.com/flukejones/rog-core"
SRC_URI="
    https://github.com/flukejones/${PN}/archive/v${PV}.tar.gz
    https://github.com/flukejones/${PN}/releases/download/v${PV}/vendor_${PN}_${PV}.tar.xz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
"

CARGO_INSTALL_PATH="${PN}"

src_unpack() {
    unpack v${PV}.tar.gz
    # adding vendor-package
    cd "${S}" && unpack vendor_${PN}_${PV}.tar.xz
}

src_prepare() {
    # adding vendor package config
    mkdir -p "${S}"/.cargo && cp "${FILESDIR}"/vendor_config "${S}"/.cargo/config
    default
}

src_install() {
    cargo_src_install

    insinto /etc
    doins data/rogcore.conf && ewarn Resetted /etc/rogcore.conf make sure to check your fan-levels!

    insinto /usr/share/dbus-1/system.d/
    doins data/${PN}.conf
    
    systemd_dounit data/${PN}.service
}

pkg_postinst() {
    ewarn "Don't forget to reload dbus and enable \"${PN}\" service, \
by runnning:\n'systemctl reload dbus && systemctl enable ${PN} \
&& systemctl start ${PN}'"
}
