# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
inherit cargo shell-completion git-r3

EGIT_REPO_URI="https://github.com/orhun/git-cliff.git"
EGIT_BRANCH="main"

DESCRIPTION="A highly customizable Changelog Generator that follows Conventional Commit specifications"
HOMEPAGE="https://git-cliff.org/"

SLOT="0"
LICENSE="
    Apache-2.0 MIT BSD-2 BSD Boost-1.0 CDDL ISC MPL-2.0 
    Unicode-3.0 Unicode-DFS-2016 ZLIB
"

PATCHES=(
    "${FILESDIR}/${P}-disable_git_upstream_remote_test.patch"
    # silences a "command not found" error (QA)
    "${FILESDIR}/${P}-silence_run_os_command_test.patch"
)

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

src_compile() {
    cargo_src_compile

    local target_dir="${S}/$(cargo_target_dir)"

    # generating man pages
    mkdir "${target_dir}/man"
    OUT_DIR="${target_dir}/man" "${target_dir}/"${PN}-mangen

    # generating completion scripts
    mkdir "${target_dir}/completion"
    OUT_DIR="${target_dir}/completion" "${target_dir}/"${PN}-completions
}

src_install() {
    local release_dir="${S}/$(cargo_target_dir)"

    insinto /usr/bin
    dobin "${release_dir}/"${PN}

    # install man file
    doman "${release_dir}/man/"${PN}.1

    # install completion scripts
    newbashcomp "${release_dir}/completion/${PN}.bash" ${PN}
    newfishcomp "${release_dir}/completion/${PN}.fish" ${PN}

    # install docs
    einstalldocs

    insinto /usr/share/doc/${P}/examples
    doins -r ${S}/examples/
}
