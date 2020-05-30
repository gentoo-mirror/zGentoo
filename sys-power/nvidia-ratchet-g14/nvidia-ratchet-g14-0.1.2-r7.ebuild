# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd

DESCRIPTION="Ratchet (PRIME) loading of nvidia (propietary) drivers beside an amdgpu (Vega)."
HOMEPAGE="https://lab.retarded.farm/zappel/nvidia-ratchet-g14"
SRC_URI="https://lab.retarded.farm/zappel/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

K_MIN="13"
K_MAX="15"

RDEPEND=">=x11-drivers/nvidia-drivers-435.21-r1[uvm,libglvnd,kms]
        >=gnome-base/gdm-3.36.2
        >=x11-apps/xrandr-1.5.1
        >=sys-kernel/gentoo-sources-5.6.${K_MIN}
        <=sys-kernel/gentoo-sources-5.6.${K_MAX}
        sys-power/rog-core
"
DEPEND="${RDEPEND}"

src_install() {
    insinto /
    doins -r src/*
    dodoc README.md
}

pkg_postinst() {
    ## patching the kernel

    for kv in $(seq ${K_MIN} ${K_MAX}); do
        kv="5.6.${kv}"
    	if [[ -d "${ROOT}"/usr/src/linux-${kv}-gentoo ]]; then
            elog "Applying kernel patchsets for \"sys-kernel/gentoo-sources-${kv}\"..."
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/asus-wmi-kernel-${kv}.patch || ewarn "could not apply asus-wmi-kernel-${kv}.patch"
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/k10temp-kernel-${kv}.patch || ewarn "could not apply k10temp-kernel-${kv}.patch"
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/snd-hda-intel_realtek-kernel-${kv}.patch || ewarn "could not apply snd-hda-intel_realtek-kernel-${kv}.patch"
	    fi
    done
    ewarn "Please upgrade your kernel accordingly. Normally just run 'genkernel' to do so."
}
