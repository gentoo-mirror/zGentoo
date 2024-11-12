# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=8

RUST_MIN_VER="1.71.1"
RUST_NEEDS_LLVM=1
LLVM_COMPAT=( {17..19} )

inherit llvm-r1 systemd cargo linux-info udev xdg desktop

_PV=${PV//_rc/-RC}
_PVV=`[[ ${_PV} =~ .*"RC".* ]] && echo || echo ${_PV}`
_PN="asusd"

DESCRIPTION="${PN} (${_PN}) is a utility for Linux to control many aspects of various ASUS laptops."
HOMEPAGE="https://asus-linux.org"
SRC_URI="
    https://gitlab.com/asus-linux/${PN}/-/archive/${_PV}/${PN}-${_PV}.tar.gz
    https://gitlab.com/asus-linux/${PN}/uploads/15f94f447c4cec063923c8d356f47695/vendor_${PN}_.tar.xz -> vendor_${PN}_${_PV}.tar.xz
    ${CARGO_CRATE_URIS}
"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC LicenseRef-UFL-1.0 MIT MPL-2.0 OFL-1.1 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0/5"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE="+acpi +gfx gnome gui"
REQUIRED_USE="gnome? ( gfx )"

RDEPEND="!!sys-power/rog-core
    !!sys-power/asus-nb-ctrl
    >=sys-power/power-profiles-daemon-0.13
    acpi? ( sys-power/acpi_call )
    gui? ( dev-libs/libayatana-appindicator )
"
DEPEND="${RDEPEND}
    dev-libs/libusb:1
    sys-apps/systemd:0=
	sys-apps/dbus
    media-libs/sdl2-gfx
    gfx? ( >=sys-power/supergfxctl-${PV}[gnome?] )
    $(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}=
		sys-devel/llvm:${LLVM_SLOT}=
	')
"
S="${WORKDIR}/${PN}-${_PV/_/-}"

src_unpack() {
    cargo_src_unpack
    unpack ${PN}-${_PV/_/.}.tar.gz
    sed -i "1s/.*/Version=\"${_PV}\"/" ${S}/Makefile

    # adding vendor-package
    cd ${S} && unpack vendor_${PN}_${_PV%%_*}.tar.xz
}

src_prepare() {
    require_configured_kernel

    # checking for touchpad dependencies
    k_wrn_touch=""
    linux_chkconfig_present I2C_HID_CORE || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_CORE not found, should be either builtin or build as module\n"
    linux_chkconfig_present I2C_HID_ACPI || k_wrn_touch="${k_wrn_touch}> CONFIG_I2C_HID_ACPI not found, should be either builtin or build as module\n"
    linux_chkconfig_present HID_ASUS || k_wrn_touch="${k_wrn_touch}> CONFIG_HID_ASUS not found, should be either builtin or build as module\n"
    linux_chkconfig_builtin PINCTRL_AMD || k_wrn_touch="${k_wrn_touch}> CONFIG_PINCTRL_AMD not found, must be builtin\n"
    [[ ${k_wrn_touch} != "" ]] && ewarn "\nKernel configuration issue(s), needed for touchpad support:\n\n${k_wrn_touch}"

    # adding vendor package config
    mkdir -p ${S}/.cargo && cp ${FILESDIR}/${P}-vendor_config ${S}/.cargo/config

    # only build rog-control-center when "gui" flag is set (TODO!)
    ! use gui && eapply "${FILESDIR}/${P}-disable_rog-cc.patch"

    default
    rust_pkg_setup
}

src_compile() {
    cargo_gen_config
    cargo_src_compile

    # cargo is using a different target-path during compilation (correcting it)
    [ -d `cargo_target_dir` ] && mv -f "`cargo_target_dir`/"* ./target/release/
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
