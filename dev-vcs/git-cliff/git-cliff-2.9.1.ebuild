# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo shell-completion

DESCRIPTION="A highly customizable Changelog Generator that follows Conventional Commit specifications"
HOMEPAGE="https://git-cliff.org/"
SRC_URI="
    https://github.com/orhun/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
    https://vendors.simple-co.de/git-cliff/${P}-crates.tar.xz   
"

SLOT="0"
KEYWORDS="~amd64"
LICENSE="
    Apache-2.0 MIT BSD-2 BSD Boost-1.0 CDDL ISC MPL-2.0 
    Unicode-3.0 Unicode-DFS-2016 ZLIB
"

PATCHES=(
    # disables tests against local (.)git repo
    "${FILESDIR}/${P}-disable_repo_tests.patch"
    # silences a "command not found" error (QA)
    "${FILESDIR}/${P}-silence_run_os_command_test.patch"
)

src_prepare() {
    default
    cargo_gen_config
    rust_pkg_setup
}

src_install() {
    local release_dir="${S}/$(cargo_target_dir)"

    insinto /usr/bin
    dobin "${release_dir}/"${PN}

    # generate and install man file
    mkdir "${release_dir}/man"
    OUT_DIR="${release_dir}/man" "${release_dir}/"${PN}-mangen
    doman "${release_dir}/man/"${PN}.1

    # generate and install completion scripts
    mkdir "${release_dir}/completion"
    OUT_DIR="${release_dir}/completion" "${release_dir}/"${PN}-completions

    newbashcomp "${release_dir}/completion/${PN}.bash" ${PN}
    newfishcomp "${release_dir}/completion/${PN}.fish" ${PN}

    # docs and examples
    dodoc ${S}/README.md

    insinto /usr/share/doc/${P}/examples
    doins -r ${S}/examples/
}
