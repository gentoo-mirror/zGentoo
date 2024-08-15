# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd cargo

DESCRIPTION="BOFH excuse generator"
HOMEPAGE="https://lab.simple-co.de/zappel/${PN}"
SRC_URI="https://lab.simple-co.de/zappel/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
    https://lab.simple-co.de/api/v4/projects/86/packages/generic/${PN}/v${PV}/${PN}-vendor-${PV}.tar.xz"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="server"

DEPEND=">=virtual/rust-1.79.0
    server? ( 
        acct-user/${PN}
        acct-group/${PN}
    )
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
    mv ${WORKDIR}/vendor ${S}/vendor
    mkdir -p ${S}/.cargo && cp ${FILESDIR}/vendor_config ${S}/.cargo/config
    default
}

src_compile() {
    cargo_gen_config
    cargo_src_compile

    # cargo is using a different target-path during compilation (correcting it)
    [ -d `cargo_target_dir` ] && mv -f "`cargo_target_dir`/"* ./target/release/
}

src_install() {
    insinto /usr/bin
    dobin ${S}/target/release/${PN}

    if use server; then
        insinto /etc/${PN}
        newins ${FILESDIR}/${PN}.settings settings.env
        systemd_dounit ${FILESDIR}/${PN}.service
    fi
}
