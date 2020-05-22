# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

# HINT: this list must be upddate on any version change
CRATES="
proc-macro2-1.0.12
unicode-xid-0.2.0
libc-0.2.69
syn-1.0.18
memchr-2.3.3
version_check-0.9.1
cfg-if-0.1.10
cc-1.0.52
log-0.4.8
pkg-config-0.3.17
glob-0.3.0
lazy_static-1.4.0
slab-0.4.2
proc-macro-nested-0.1.4
futures-core-0.3.4
bitflags-1.2.1
proc-macro-hack-0.5.15
futures-sink-0.3.4
regex-syntax-0.6.17
unicode-width-0.1.7
quick-error-1.2.3
crc32fast-1.2.0
bindgen-0.53.2
rustversion-1.0.2
ansi_term-0.11.0
termcolor-1.1.0
futures-task-0.3.4
vec_map-0.8.1
pin-utils-0.1.0
strsim-0.8.0
futures-io-0.3.4
shlex-0.1.1
adler32-1.0.4
take_mut-0.2.2
lazycell-1.2.1
rle-decode-fast-1.0.1
rustc-hash-1.1.0
peeking_take_while-0.1.2
serde-1.0.106
fnv-1.0.6
bit-vec-0.5.1
pin-project-lite-0.1.4
bytes-0.5.4
thread_local-1.0.1
futures-channel-0.3.4
humantime-1.3.0
textwrap-0.11.0
bit-set-0.5.1
nom-5.1.1
proc-macro-error-attr-1.0.2
proc-macro-error-1.0.2
clang-sys-0.29.3
aho-corasick-0.7.10
libflate-0.1.27
libdbus-sys-0.2.1
quote-1.0.4
atty-0.2.14
xattr-0.2.2
filetime-0.2.9
which-3.1.1
iovec-0.1.4
net2-0.2.34
num_cpus-1.13.0
clap-2.33.0
tar-0.4.26
mio-0.6.22
regex-1.3.7
libloading-0.5.2
cexpr-0.4.0
env_logger-0.7.1
libusb1-sys-0.3.6
toml-0.5.6
syn-mid-0.5.0
synstructure-0.12.3
rusb-0.5.5
uhidrs-sys-1.0.0
futures-macro-0.3.4
thiserror-impl-1.0.16
tokio-macros-0.2.5
enumflags2_derive-0.6.4
gumdrop_derive-0.8.0
serde_derive-1.0.106
smart-default-0.6.0
tokio-0.2.20
enumflags2-0.6.4
uhid-virt-0.0.4
err-derive-0.2.4
futures-util-0.3.4
thiserror-1.0.16
intel-pstate-0.2.1
futures-executor-0.3.4
futures-0.3.4
dbus-0.8.2
gumdrop-0.8.0
dbus-tokio-0.5.1
"

# sub-dependdenciess (THIS IS REALLY BAD!)
CRATES="${CRATES}
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
kernel32-sys-0.2.2
miow-0.2.1
winapi-0.2.8
winapi-0.3.8
atty-0.2.14
hermit-abi-0.1.12
winapi-util-0.1.5
winapi-build-0.1.1
ws2_32-sys-0.2.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
vcpkg-0.2.8
redox_syscall-0.1.56
"

inherit systemd cargo

DESCRIPTION="rog-core is a utility for Linux to control many aspects (eventually) of the ASUS ROG laptops like the Zephyrus GX502GW."
HOMEPAGE="https://github.com/flukejones/rog-core"
SRC_URI="
https://github.com/flukejones/${PN}/archive/v${PV}.tar.gz
$(cargo_crate_uris ${CRATES})
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"

# TODO: workaround because '--path' parameter is not working(?)
# (https://github.com/gentoo/gentoo/pull/14097)
CARGO_INSTALL_PATH="${PN}"

src_install() {
    cargo_src_install
    insinto /usr/share/dbus-1/system.d/
    doins "${WORKDIR}/${P}"/data/${PN}.conf
    systemd_dounit "${WORKDIR}/${P}"/data/${PN}.service
}

pkg_postinst() {
    ewarn "Don't forget to reload dbus and enable \"${PN}\" service, \
by runnning:\n'$ systemctl reload dbus && systemctl enable ${PN} \
&& systemctl start ${PN}'"
}
