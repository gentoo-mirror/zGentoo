# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit systemd

DESCRIPTION="Ratchet (PRIME) loading of nvidia (propietary) drivers beside an amdgpu (Vega 7)."
HOMEPAGE="https://lab.retarded.farm/zappel/nvidia-ratchet-g14"
SRC_URI="https://lab.retarded.farm/zappel/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# min/max supported kernel versions
K_MIN="5.6.13"
K_MAX="5.7.0"

# kernel 5.6 and 5.7 patches
K_56="${K_MIN} 5.6.14 5.6.15 5.6.16"
K_57="${K_MAX}"

## combined version
K_SUP="${K_56} ${K_57}"

BDEPEND=""
RDEPEND="${BDEPEND}
    >=x11-drivers/nvidia-drivers-435.21-r1[uvm,libglvnd,kms]
    >=gnome-base/gdm-3.36.2
    >=x11-apps/xrandr-1.5.1
    >=sys-kernel/gentoo-sources-${K_MIN}
    <=sys-kernel/gentoo-sources-${K_MAX}
    >=sys-power/rog-core-0.9.9
"
DEPEND="${RDEPEND}"

src_install() {
    insinto /
    doins -r src/*
    dodoc README.md
}

pkg_postinst() {
    ## patching the kernel

    for kv in ${K_SUP}; do
    	if [[ -d "${ROOT}"/usr/src/linux-${kv}-gentoo ]]; then
            elog "Applying kernel patchsets for \"sys-kernel/gentoo-sources-${kv}\"..."
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/asus-wmi-kernel-${kv}.patch || ewarn "could not apply asus-wmi-kernel-${kv}.patch"
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/k10temp-kernel-${kv}.patch || ewarn "could not apply k10temp-kernel-${kv}.patch"
            patch -d "${ROOT}"/usr/src/linux-${kv}-gentoo -p1 < "${FILESDIR}"/snd-hda-intel_realtek-kernel-${kv}.patch || ewarn "could not apply snd-hda-intel_realtek-kernel-${kv}.patch"
	    fi
    done
    ewarn "Please upgrade your kernel accordingly. Normally just run 'genkernel' to do so."
}
