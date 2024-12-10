# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.82.0"
inherit cargo git-r3

EGIT_REPO_URI="https://github.com/nymtech/nym.git"
EGIT_BRANCH="master"

DESCRIPTION="NYM(VPN) is a privacy platform providing strong network-level privacy."
HOMEPAGE="https://nymtech.net"
SRC_URI="https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.12.zip -> swagger-ui-5.17.12.zip"

# todo: implement use-flags to controll the portions
#IUSE="api explorer authenticator client observatory router node socks5 validator visor"

SLOT="0"
LICENSE="GPL-3 Apache-2.0 BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"

RDEPEND="
    acct-group/${PN}
    acct-user/${PN}
"

src_unpack() {
    default
    git-r3_src_unpack
    cargo_live_src_unpack
}

src_prepare() {
    default
    cargo_gen_config
    rust_pkg_setup
}

src_configure() {
	cargo_src_configure --frozen
}

src_compile() {
	export SWAGGER_UI_DOWNLOAD_URL="file://${DISTDIR}/swagger-ui-5.17.12.zip"
	cargo_src_compile
}

src_install() {
    local release_dir="${S}/$(cargo_target_dir)"

    insinto /usr/bin
    dobin "${release_dir}/"${PN}-api
    dobin "${release_dir}/"${PN}-authenticator
    dobin "${release_dir}/"${PN}-client
    dobin "${release_dir}/"${PN}-data-observatory
    dobin "${release_dir}/"${PN}-ip-packet-router
    dobin "${release_dir}/"${PN}-mixnode
    dobin "${release_dir}/"${PN}-network-requester
    dobin "${release_dir}/"${PN}-node
    dobin "${release_dir}/"${PN}-node-status-api
    dobin "${release_dir}/"${PN}-socks5-client
    dobin "${release_dir}/"${PN}-validator-rewarder
    dobin "${release_dir}/"${PN}visor
    newbin "${release_dir}/explorer-api" ${PN}-explorer-api

    dodoc ${S}/README.md
}
