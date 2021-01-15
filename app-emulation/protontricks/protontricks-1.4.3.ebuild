# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A simple wrapper that does winetricks things for Proton enabled games, requires Winetricks."
HOMEPAGE="https://github.com/Matoking/protontricks"
SRC_URI="https://github.com/Matoking/protontricks/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Depends on neither, steam-launcher OR steam-client-meta - or both. And winetricks, of course.
RDEPEND="${PYTHON_DEPS}
		|| ( games-util/steam-launcher games-util/steam-client-meta )
		app-emulation/winetricks
		dev-python/vdf"
DEPEND="${RDEPEND}
		dev-python/setuptools"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
