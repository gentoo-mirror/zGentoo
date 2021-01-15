# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd cargo git-r3

MY_PN="asusd"

DESCRIPTION="${PN} (${MY_PN}) is a utility for Linux to control many aspects of various ASUS laptops."
HOMEPAGE="https://asus-linux.org"
SRC_URI="
    https://gitlab.com/asus-linux/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz
    https://gitlab.com/asus-linux/asus-nb-ctrl/uploads/df4fa5bb409512dda33ddebe5db71700/vendor_${PN}_${PV}.tar.xz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx +notify"

RDEPEND="!!sys-power/rog-core"
DEPEND="${RDEPEND}
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
    gfx? ( !sys-kernel/gentoo-g14-next )
"

src_unpack() {
    unpack ${PN}-${PV}.tar.gz
    # adding vendor-package
    cd "${S}" && unpack vendor_${PN}_${PV}.tar.xz
}

src_prepare() {
    # adding vendor package config
    mkdir -p "${S}"/.cargo && cp "${FILESDIR}"/vendor_config "${S}"/.cargo/config
    default
}

src_compile() {
    cargo_gen_config
    default
}

src_install() {
    cargo_src_install --path "${PN}"
    use notify && cargo_src_install --path "asus-notify"

    insinto /etc/${MY_PN}
    doins data/${MY_PN}-ledmodes.toml
    doins "${FILESDIR}"/${MY_PN}.conf && ewarn Resetted /etc/${MY_PN}/${MY_PN}.conf make sure to check your settings!

    insinto /usr/share/icons/hicolor/512x512/apps/
    doins data/icons/*.png

    insinto /etc/udev/rules.d/
    doins data/${MY_PN}.rules

    insinto /usr/share/dbus-1/system.d/
    doins data/${MY_PN}.conf

    if [ -f data/_asusctl ] && [ -d /usr/share/zsh/site-functions ]; then
        insinto /usr/share/zsh/site-functions
        doins data/_asusctl
    fi
    
    ## GFX needs testing
    if use gfx; then
        ## screen settings
        insinto /lib/udev/rules.d
        data/90-nvidia-screen-G05.conf
        
        ## pm settings
        insinto /X11/xorg.conf.d
        data/90-asusd-nvidia-pm.rules

        ## mod blacklisting
        insinto /etc/modprobe.d
        "${FILESDIR}"/90-nvidia-blacklist.conf
    fi

    systemd_dounit data/${MY_PN}.service
    use notify && systemd_douserunit data/asus-notify.service
}

pkg_postinst() {
    ewarn "Don't forget to reload dbus to enable \"${MY_PN}\" service, \
by runnning:\n >> systemctl reload dbus && udevadm control --reload-rules \
&& udevadm trigger"
}
