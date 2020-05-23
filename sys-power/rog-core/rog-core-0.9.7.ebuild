# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=7

# HINT: this list must be updated on any version change
CRATES="
adler32-1.0.4
aho-corasick-0.7.10
ansi_term-0.11.0
atty-0.2.14
bindgen-0.53.2
bit-set-0.5.1
bit-vec-0.5.1
bitflags-1.2.1
bytes-0.5.4
cc-1.0.52
cexpr-0.4.0
cfg-if-0.1.10
clang-sys-0.29.3
clap-2.33.0
crc32fast-1.2.0
dbus-0.8.2
dbus-tokio-0.5.1
enumflags2_derive-0.6.4
enumflags2-0.6.4
env_logger-0.7.1
err-derive-0.2.4
filetime-0.2.9
fnv-1.0.6
futures-0.3.4
futures-channel-0.3.4
futures-core-0.3.4
futures-executor-0.3.4
futures-io-0.3.4
futures-macro-0.3.4
futures-sink-0.3.4
futures-task-0.3.4
futures-util-0.3.4
glob-0.3.0
gumdrop_derive-0.8.0
gumdrop-0.8.0
humantime-1.3.0
intel-pstate-0.2.1
iovec-0.1.4
lazy_static-1.4.0
lazycell-1.2.1
libc-0.2.69
libdbus-sys-0.2.1
libflate-0.1.27
libloading-0.5.2
libusb1-sys-0.3.6
log-0.4.8
memchr-2.3.3
mio-0.6.22
net2-0.2.34
nom-5.1.1
num_cpus-1.13.0
peeking_take_while-0.1.2
pin-project-lite-0.1.4
pin-utils-0.1.0
pkg-config-0.3.17
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro-hack-0.5.15
proc-macro-nested-0.1.4
proc-macro2-1.0.12
quick-error-1.2.3
quote-1.0.4
regex-1.3.7
regex-syntax-0.6.17
rle-decode-fast-1.0.1
rusb-0.5.5
rustc-hash-1.1.0
rustversion-1.0.2
serde_derive-1.0.106
serde-1.0.106
shlex-0.1.1
slab-0.4.2
smart-default-0.6.0
strsim-0.8.0
syn-1.0.18
syn-mid-0.5.0
synstructure-0.12.3
sysfs-class-0.1.3
take_mut-0.2.2
tar-0.4.26
termcolor-1.1.0
textwrap-0.11.0
thiserror-1.0.16
thiserror-impl-1.0.16
thread_local-1.0.1
tokio-0.2.20
tokio-macros-0.2.5
toml-0.5.6
uhid-virt-0.0.4
uhidrs-sys-1.0.0
unicode-width-0.1.7
unicode-xid-0.2.0
vec_map-0.8.1
version_check-0.9.1
which-3.1.1
xattr-0.2.2
"

# sub-dependencies (should be avoided)
CRATES="${CRATES}
atty-0.2.14
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
hermit-abi-0.1.12
kernel32-sys-0.2.2
numtoa-0.2.3
miow-0.2.1
redox_syscall-0.1.56
vcpkg-0.2.8
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
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
# (see https://github.com/gentoo/gentoo/pull/14097)
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
