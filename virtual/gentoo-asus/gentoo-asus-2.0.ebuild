# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ASUS ROG on gentoo linux virtual"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=virtual/linux-sources-3-r99
	sys-kernel/gentoo-sources-g14
	sys-power/asusctl[gfx]
	"
