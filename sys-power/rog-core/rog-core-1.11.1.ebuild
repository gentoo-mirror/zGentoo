# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

# HINT: this list must be updated on any version change
CRATES="
adler32-1.0.4
aho-corasick-0.7.10
ansi_term-0.11.0
atty-0.2.14
bindgen-0.53.3
bit-set-0.5.2
bit-vec-0.6.2
bitflags-1.2.1
bytes-0.5.4
cc-1.0.54
cexpr-0.4.0
cfg-if-0.1.10
clang-sys-0.29.3
clap-2.33.1
crc32fast-1.2.0
dbus-0.8.3
dbus-tokio-0.5.1
enumflags2_derive-0.6.4
enumflags2-0.6.4
env_logger-0.7.1
err-derive-0.2.4
filetime-0.2.10
fnv-1.0.7
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.5
futures-channel-0.3.5
futures-core-0.3.5
futures-executor-0.3.5
futures-io-0.3.5
futures-macro-0.3.5
futures-sink-0.3.5
futures-task-0.3.5
futures-util-0.3.5
glob-0.3.0
gumdrop_derive-0.8.0
gumdrop-0.8.0
hermit-abi-0.1.13
humantime-1.3.0
intel-pstate-0.2.1
iovec-0.1.4
kernel32-sys-0.2.2
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.71
libdbus-sys-0.2.1
libflate-0.1.27
libloading-0.5.2
libusb1-sys-0.3.7
log-0.4.8
memchr-2.3.3
mio-0.6.22
miow-0.2.1
net2-0.2.34
nom-5.1.1
num_cpus-1.13.0
numtoa-0.2.3
once_cell-1.4.0
peeking_take_while-0.1.2
pin-project-0.4.20
pin-project-internal-0.4.20
pin-project-lite-0.1.7
pin-utils-0.1.0
pkg-config-0.3.17
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro-hack-0.5.16
proc-macro-nested-0.1.5
proc-macro2-1.0.18
quick-error-1.2.3
quote-1.0.7
redox_syscall-0.1.56
regex-1.3.9
regex-syntax-0.6.18
rle-decode-fast-1.0.1
rusb-0.5.5
rustc-hash-1.1.0
rustversion-1.0.2
serde_derive-1.0.111
serde-1.0.111
shlex-0.1.1
slab-0.4.2
smart-default-0.6.0
strsim-0.8.0
syn-1.0.30
syn-mid-0.5.0
synstructure-0.12.4
sysfs-class-0.1.3
take_mut-0.2.2
tar-0.4.28
termcolor-1.1.0
textwrap-0.11.0
thiserror-1.0.19
thiserror-impl-1.0.19
thread_local-1.0.1
tinybmp-0.2.3
tokio-0.2.21
tokio-macros-0.2.5
toml-0.5.6
uhid-virt-0.0.4
uhidrs-sys-1.0.0
unicode-width-0.1.7
unicode-xid-0.2.0
vcpkg-0.2.9
vec_map-0.8.2
version_check-0.9.2
which-3.1.1
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
xattr-0.2.2
yansi-term-0.1.2
"

inherit systemd cargo

DESCRIPTION="rog-core is a utility for Linux to control many aspects (eventually) of the ASUS ROG laptops like the Zephyrus GX502GW."
HOMEPAGE="https://github.com/flukejones/rog-core"
SRC_URI="
https://github.com/flukejones/${PN}/archive/v${PV}.tar.gz
$(cargo_crate_uris ${CRATES})
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/rust-1.44.0
    >=sys-devel/llvm-9.0.1
    >=sys-devel/clang-runtime-9.0.1
    dev-libs/libusb:1
"

# TODO: workaround because '--path' parameter is not working(?)
# (see https://github.com/gentoo/gentoo/pull/14097)
CARGO_INSTALL_PATH="${PN}"

src_prepare() {
    default
}

src_install() {
    cargo_src_install
    
    # temporary create generic config (should be fixed in 0.11.1)
    insinto /etc
    doins "${FILESDIR}"/rogcore.conf && ewarn Resetted /etc/rogcore.conf make sure to check your fan-levels!

    insinto /usr/share/dbus-1/system.d/
    doins "${WORKDIR}/${P}"/data/${PN}.conf
    systemd_dounit "${WORKDIR}/${P}"/data/${PN}.service
}

pkg_postinst() {
    ewarn "Don't forget to reload dbus and enable \"${PN}\" service, \
by runnning:\n'$ systemctl reload dbus && systemctl enable ${PN} \
&& systemctl start ${PN}'"
}
