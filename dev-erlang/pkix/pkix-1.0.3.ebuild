# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="PKIX certificates management library for Erlang"
HOMEPAGE="https://github.com/processone/pkix"
SRC_URI="https://github.com/processone/pkix/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-libs/gd[png,jpeg,webp]
	>=dev-lang/erlang-17.1
	>=dev-erlang/p1_utils-1.0.14"
DEPEND="${RDEPEND}"

DOCS=( README.md LICENSE )
