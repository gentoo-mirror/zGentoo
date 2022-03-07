# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ASUS ROG on gentoo linux virtual"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=virtual/linux-sources-3-r100
	sys-kernel/gentoo-sources-rog
	sys-power/asusctl[gfx]
	"
