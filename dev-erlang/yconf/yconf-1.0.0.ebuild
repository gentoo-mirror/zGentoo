# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="YAML configuration processor"
HOMEPAGE="https://github.com/processone/yconf"
SRC_URI="https://github.com/processone/yconf/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-libs/gd[png,jpeg,webp]
	>=dev-lang/erlang-17.1
	>=dev-erlang/fast_yaml-1.0.20"
DEPEND="${RDEPEND}"

DOCS=( LICENSE )
