# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="A highly customizable Changelog Generator that follows Conventional Commit specifications"
HOMEPAGE="https://git-cliff.org/"
SRC_URI="https://github.com/orhun/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
    https://vendors.simple-co.de/${PN}/${PN}-vendor-${PV}.tar.xz"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/rust-1.75.0"
RDEPEND="${DEPEND}"
BDEPEND=""

QA_PRESTRIPPED="/usr/bin/git-cliff"

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
}
