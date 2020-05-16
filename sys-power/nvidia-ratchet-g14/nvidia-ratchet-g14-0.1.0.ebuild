# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

DESCRIPTION="A simple wrapper that does winetricks things for Proton enabled games, requires Winetricks."
HOMEPAGE="https://github.com/Matoking/protontricks"
SRC_URI="https://lab.retarded.farm/zappel/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-drivers/nvidia-drivers-435.21-r1[uvm,libglvnd,kms]
        >=gnome-base/gdm-3.36.2
		>=x11-apps/xrandr-1.5.1"
DEPEND="${RDEPEND}"

src_install() {
    insinto /
    doins -r /src
    dodoc README.md
}
