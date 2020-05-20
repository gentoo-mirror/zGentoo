# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd

KV="5.6.13"

DESCRIPTION="Ratchet (PRIME) loading of nvidia (propietary) drivers beside an amdgpu (Vega)."
HOMEPAGE="https://lab.retarded.farm/zappel/nvidia-ratchet-g14"
SRC_URI="https://lab.retarded.farm/zappel/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-drivers/nvidia-drivers-435.21-r1[uvm,libglvnd,kms]
        >=gnome-base/gdm-3.36.2
        >=x11-apps/xrandr-1.5.1
        =sys-kernel/gentoo-sources-${KV}
"
DEPEND="${RDEPEND}"

src_install() {
    insinto /
    doins -r src/*
    systemd_dounit "${FILESDIR}"/ratchet-tt.service
    dodoc README.md
}

pkg_postinst() {
    ## patching the kernel
	if [[ -d "${ROOT}"/usr/src/linux-${KV}-gentoo ]]; then
        ewarn "Applying kernel patch for \"sys-kernel/gentoo-sources-${KV}\"..."
        patch -d "${ROOT}"/usr/src/linux-${KV}-gentoo -p1 < "${FILESDIR}"/asus-wmi-kernel-${KV}.patch || eerror "could not apply asus-wmi-kernel-${KV}.patch"

        ewarn "Please upgrade your kernel accordingly. Normally just run 'genkernel' to do so."
	fi
}
