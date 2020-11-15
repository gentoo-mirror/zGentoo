# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd

MY_PN="${PN%-*}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ASUS ROG Zephyrus G14 patches and PRIME Loader for propietary nvidia drivers"
HOMEPAGE="https://lab.retarded.farm/zappel/nvidia-ratchet-g14"
SRC_URI="https://lab.retarded.farm/zappel/${MY_PN}/-/archive/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+extras gnome nvidia X -dGPU"

BDEPEND="
    !!sys-power/nvidia-ratchet-g14
    !!sys-kernel/gentoo-g14
"
RDEPEND="${BDEPEND}
    nvidia? ( >=x11-drivers/nvidia-drivers-435.21-r1[uvm,libglvnd,kms] )
    gnome? ( >=gnome-base/gdm-3.36.2 )
    X? ( >=x11-apps/xrandr-1.5.1 )
    extras? ( >=sys-power/asus-nb-ctrl-2.0.0 )
    >=sys-kernel/gentoo-sources-g14-5.9.0
"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_install() {
    if use nvidia && use dGPU; then
        insinto /etc/modprobe.d
        doins -r src/dGPU/etc/modprobe.d/*
        insinto /lib
        doins -r src/dGPU/lib/*
        if use X; then
            insinto /etc/X11
            doins -r src/dGPU/etc/X11/*
            insinto /etc/xdg
            doins -r src/dGPU/etc/xdg/*
        fi
        if use gnome; then
            insinto /usr
            doins -r src/dGPU/usr/*
            insinto /var/lib
            doins -r src/dGPU/var/lib/*
        fi
    elif use nvidia; then
        insinto /etc/modprobe.d
        doins -r src/iGPU/etc/modprobe.d/*
        insinto /lib
        doins -r src/iGPU/lib/*
        if use gnome; then
            insinto /var/lib
            doins -r src/iGPU/var/lib/*
        fi
        exeinto /usr/bin
        doexe src/iGPU/usr/bin/prime-run
    fi
    
    dodoc README.md
}

pkg_postinst() {
    ewarn "Please upgrade your kernel accordingly. Normally just run 'genkernel' to do so."
}
