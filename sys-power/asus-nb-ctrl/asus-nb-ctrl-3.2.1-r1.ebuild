# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd cargo git-r3 linux-info xdg

_PN="asusd"

DESCRIPTION="${PN} (${_PN}) is a utility for Linux to control many aspects of various ASUS laptops."
HOMEPAGE="https://asus-linux.org"
SRC_HASH="4f06d49e84373678b16b7c04a897ea57"
SRC_URI="
    https://gitlab.com/asus-linux/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz
    https://gitlab.com/asus-linux/${PN}/uploads/${SRC_HASH}/vendor_${PN}_${PV}.tar.xz
"

LICENSE="MPL-2.0"
SLOT="3/3.2.1"
KEYWORDS="~amd64"
IUSE="+gfx +notify systemd"

RDEPEND="!!sys-power/rog-core
    !!sys-power/asus-nb-ctrl:2"
DEPEND="${RDEPEND}
    systemd? ( sys-apps/systemd )
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
    gfx? ( !sys-kernel/gentoo-g14-next )
"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
    unpack ${PN}-${PV}.tar.gz
    # adding vendor-package
    cd ${S} && unpack vendor_${PN}_${PV}.tar.xz
}

src_prepare() {
    # checking for needed kernel-modules since v3.2.0
    k_err="\n"
    require_configured_kernel
    linux_chkconfig_module VFIO_PCI || k_err="${k_err}CONFIG_VFIO_PCI must be enabled as module\n"
    linux_chkconfig_module VFIO_IOMMU_TYPE1 || k_err="${k_err}CONFIG_VFIO_IOMMU_TYPE1 must be enabled as module\n"
    linux_chkconfig_module VFIO_VIRQFD || k_err="${k_err}CONFIG_VFIO_VIRQFD must be enabled as module\n"
    linux_chkconfig_module VFIO_MDEV || k_err="${k_err}CONFIG_VFIO_MDEV must be enabled as module\n"
    linux_chkconfig_module VFIO || k_err="${k_err}CONFIG_VFIO must be enabled as module\n"
    [[ ${k_err} != "\n" ]] && die "\nKernel configuration mismatch:\n${k_err}"

    # adding vendor package config
    mkdir -p ${S}/.cargo && cp ${FILESDIR}/vendor_config ${S}/.cargo/config
    default
}

src_compile() {
    cargo_gen_config
    default
}

src_install() {
    insinto /etc/${_PN}
    doins data/${_PN}-ledmodes.toml

    insinto /usr/share/icons/hicolor/512x512/apps/
    doins data/icons/*.png

    insinto /lib/udev/rules.d/
    doins data/${_PN}.rules

    if [ -f data/_asusctl ] && [ -d /usr/share/zsh/site-functions ]; then
        insinto /usr/share/zsh/site-functions
        doins data/_asusctl
    fi
    
    ## GFX needs testing
    if use gfx; then
        ## screen settings
        insinto /lib/udev/rules.d
        doins data/90-nvidia-screen-G05.conf
        
        ## pm settings
        insinto /etc/X11/xorg.conf.d
        doins data/90-asusd-nvidia-pm.rules

        ## mod blacklisting
        insinto /etc/modprobe.d
        doins ${FILESDIR}/90-nvidia-blacklist.conf
    fi

    if use systemd; then
        insinto /usr/share/dbus-1/system.d/
        doins data/${_PN}.conf

        systemd_dounit data/${_PN}.service
        use notify && systemd_douserunit data/asus-notify.service
    fi

    use notify && cargo_src_install --path "asus-notify"
    cargo_src_install --path "asusctl"
    cargo_src_install --path "daemon"
}

pkg_postinst() {
    xdg_icon_cache_update
    ewarn "Don't forget to reload dbus to enable \"${_PN}\" service, \
by runnning:\n >> systemctl reload dbus && udevadm control --reload-rules \
&& udevadm trigger"
}

pkg_postrm() {
    xdg_icon_cache_update
}
