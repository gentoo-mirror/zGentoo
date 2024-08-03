# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit systemd cargo linux-info udev xdg desktop

_PV=${PV//_rc/-RC}
_PVV=`[[ ${_PV} =~ .*"RC".* ]] && echo || echo ${_PV}`
_PN="asusd"

DESCRIPTION="${PN} (${_PN}) is a utility for Linux to control many aspects of various ASUS laptops."
HOMEPAGE="https://asus-linux.org"

## howto create vendor bundle (upstream approach is not feasable)
# >> git clone https://gitlab.com/asus-linux/asusctl -b <version> /tmp/asusctl
# >> cd /tmp/asusctl && version=`git describe --tags | sed -E "s/v([0-9.]+)/\1/g"`
# >> mkdir -p .cargo && cargo vendor | head -n -1 > .cargo/config
# >> echo 'directory = "vendor"' >> .cargo/config
# >> mkdir -p asusctl-${version}/.cargo &&  mv vendor asusctl-${version}/vendor
# >> mv .cargo/config asusctl-${version}/.cargo
# >> tar -caf asusctl-${version}-vendor.tar.xz asusctl-${version}/vendor
# >> tar -caf asusctl-${version}-cargo_config.tar.xz asusctl-${version}/.cargo

SRC_URI="
    https://gitlab.com/asus-linux/${PN}/-/archive/${_PV}/${PN}-${_PV}.tar.gz -> ${P}.tar.gz
    https://vendors.simple-co.de/${PN}/${P}-vendor.tar.xz
    https://vendors.simple-co.de/${PN}/${P}-cargo_config.tar.xz
"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC LicenseRef-UFL-1.0 MIT MPL-2.0 OFL-1.1 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0/6"
KEYWORDS="~amd64"
RESTRICT="mirror test" # tests not working at all (upstream fails as well)
IUSE="+acpi +gfx gnome gui X"
REQUIRED_USE="gnome? ( gfx )"

RDEPEND="!!sys-power/rog-core
    !!sys-power/asus-nb-ctrl
    >=sys-power/power-profiles-daemon-0.13
    acpi? ( sys-power/acpi_call )
    gui? (
        dev-libs/libappindicator:3
        sys-auth/seatd
    )
"
DEPEND="${RDEPEND}
    >=virtual/rust-1.75.0
    >=sys-devel/llvm-17.0.6
    >=sys-devel/clang-runtime-17.0.6
    dev-libs/libusb:1
    sys-apps/systemd:0=
	sys-apps/dbus
    media-libs/sdl2-gfx
    gfx? ( >=sys-power/supergfxctl-5.2.1[gnome?] )
"
src_prepare() {
    require_configured_kernel

    # checking for touchpad dependencies
    k_wrn_touch=""
    linux_chkconfig_present I2C_HID_CORE || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_CORE not found, should be either builtin or build as module\n"
    linux_chkconfig_present I2C_HID_ACPI || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_ACPI not found, should be either builtin or build as module\n"
    linux_chkconfig_present HID_ASUS || k_wrn_touch="${k_wrn_touch}> CONFIG_HID_ASUS not found, should be either builtin or build as module\n"
    linux_chkconfig_builtin PINCTRL_AMD || k_wrn_touch="${k_wrn_touch}> CONFIG_PINCTRL_AMD not found, must be builtin\n"
    [[ ${k_wrn_touch} != "" ]] && ewarn "\nKernel configuration issue(s), needed for touchpad support:\n\n${k_wrn_touch}"

    # only build rog-control-center when "gui" flag is set (TODO!)
    ! use gui && eapply "${FILESDIR}/${P}-disable_rog-cc.patch"

    # setting correfct version
    sed -i "1s/.*/Version=\"${_PV}\"/" ${S}/Makefile

    default
}

src_configure() {
    # enable X11 compatibility (needs testing)
    use gui && local myfeatures=(
        $(usex X rog-control-center/x11 '')
    )
    cargo_src_configure
}

src_compile() {
    cargo_gen_config
    cargo_src_compile
}

src_install() {
    if use gui; then
        # icons (apps)
        insinto /usr/share/icons/hicolor/512x512/apps/
        doins data/icons/*.png

        # icons (status/notify)
        insinto /usr/share/icons/hicolor/scalable/status/
        doins data/icons/scalable/*.svg
    fi

    insinto /lib/udev/rules.d/
    doins data/${_PN}.rules

    if [ -f data/_asusctl ] && [ -d /usr/share/zsh/site-functions ]; then
        insinto /usr/share/zsh/site-functions
        doins data/_asusctl
    fi

    insinto /usr/share/dbus-1/system.d/
    doins data/${_PN}.conf

    systemd_dounit data/${_PN}.service
    systemd_douserunit data/${_PN}-user.service

    if use acpi; then
        insinto /etc/modules-load.d
        doins ${FILESDIR}/90-acpi_call.conf
    fi

    use gui && domenu rog-control-center/data/rog-control-center.desktop

    default
}

pkg_postinst() {
    xdg_icon_cache_update
    udev_reload
}

pkg_postrm() {
    xdg_icon_cache_update
    udev_reload
}
