# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

GIT_COMMIT="f77293fc4aa8c2f5645b2d05d8f0d476220cba9a"

DESCRIPTION="Linux kernel driver for reading RAPL registers for AMD Zen CPUs"
HOMEPAGE="https://github.com/BoukeHaarsma23/zenergy"
SRC_URI="https://github.com/BoukeHaarsma23/zenergy/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-kernel_6.16.patch" )

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

MODULES_KERNEL_MIN=5.10
MODULES_KERNEL_MAX=6.16
CONFIG_CHECK="HWMON PCI AMD_NB"

src_compile() {
    local modlist=( ${PN}=kernel/drivers/hwmon:${S} )
    local modargs=(
        NIH_SOURCE="${KV_OUT_DIR}"
        KDIR="${KV_OUT_DIR}"
    )
    linux-mod-r1_src_compile
}
