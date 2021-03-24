# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd cargo git-r3 linux-info xdg

MY_PN="asusd"

DESCRIPTION="${PN} (${MY_PN}) is a utility for Linux to control many aspects of various ASUS laptops."
HOMEPAGE="https://asus-linux.org"
EGIT_REPO_URI="https://gitlab.com/asus-linux/${PN}.git"

LICENSE="MPL-2.0"
SLOT="9999"
IUSE="+gfx +notify systemd"

RDEPEND="!!sys-power/rog-core
!!sys-power/asus-nb-ctrl:2
!!sys-power/asus-nb-ctrl:3"
DEPEND="${RDEPEND}
    systemd? ( sys-apps/systemd )
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
    gfx? ( !sys-kernel/gentoo-g14-next )
"

src_unpack() {
    default
    git-r3_src_unpack
    cargo_live_src_unpack
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
    refault
}

src_compile() {
    cargo_gen_config
    ## patch config to NOT trigger install in "all" target (this will fail)
    sed -i 's/build\ install/build/g' Makefile
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
        doins data/90-nvidia-screen-G05.conf
        
        ## pm settings
        insinto /X11/xorg.conf.d
        doins data/90-asusd-nvidia-pm.rules

        ## mod blacklisting
        insinto /etc/modprobe.d
        doins "${FILESDIR}"/90-nvidia-blacklist.conf
    fi

    if use systemd; then
        insinto /usr/share/dbus-1/system.d/
        doins data/${MY_PN}.conf

        systemd_dounit data/${MY_PN}.service
        use notify && systemd_douserunit data/asus-notify.service
    fi
}

pkg_postinst() {
    xdg_icon_cache_update
    ewarn "Don't forget to reload dbus to enable \"${MY_PN}\" service, \
by runnning:\n >> systemctl reload dbus && udevadm control --reload-rules \
&& udevadm trigger"
}

pkg_postrm() {
    xdg_icon_cache_update
}
