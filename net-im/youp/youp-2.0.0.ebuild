# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

# crates.io dependencies (needs to be updated accordingly to cargo.toml everytime!)
CRATES="
gdk-0.13.2
glib-0.10.3
libappindicator-0.5.2
gdk-pixbuf-0.9.0
"

inherit gnome2-utils cargo meson xdg

DESCRIPTION="Youp - a whatsapp wrapper written with Rust and GTK3"
HOMEPAGE="https://github.com/gigitux/youpforwhatsapp"
SRC_URI="
    https://github.com/gigitux/youpforwhatsapp/releases/download/${PV:0:3}/${P}.tar.xz
    $(cargo_crate_uris ${CRATES})
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies (as available or in cargo.toml - syslibs)
RDEPEND="
	>=dev-libs/glib-2.66.7:2
	>=x11-libs/gtk+-3.24.22:3
    >=dev-libs/libappindicator-12.10.0:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.48.0
    >=sys-devel/llvm-10.0.1
    >=sys-devel/clang-runtime-10.0.1
"

src_prepare() {
	xdg_src_prepare

	# That script would update icon cache and desktop database.
	sed -i "s/meson.add_install_script('meson_post_install.py')//" meson.build \
		|| die 'Failed to remove post-install-script invocation from meson.build'

	# Don't let meson compile src, that will be handled by cargo.
	sed -i "s/subdir('src')//" meson.build \
		|| die 'Failed to remove manpage compression from meson.build'

    # Correcting gresource fallback loding path
    sed -i 's/\/app\/share\/com.gigitux.youp/\/usr\/share\/youp/g' src/main.rs \
        || die "couldn't patch share path in main.rs"
}

# needed to configure "data" (gresources, etc.)
src_configure() { meson_src_configure; }

# compile both, meson and cargo buildchains
src_compile() {
    meson_src_compile
    cargo_src_compile
}

# installing accordingly to buildchains
src_install() {
    meson_src_install
    cargo_src_install
    
    # correcting share path (patched in prepare)
    mv ${D}/usr/share/com.gigitux.youp ${D}/usr/share/youp
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}