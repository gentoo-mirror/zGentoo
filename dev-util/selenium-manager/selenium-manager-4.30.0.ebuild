# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler2@2.0.0
	adler@1.0.2
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.14
	anstyle-parse@0.2.4
	anstyle-query@1.0.3
	anstyle-wincon@3.0.3
	anstyle@1.0.8
	anyhow@1.0.97
	apple-flat-package@0.20.0
	apple-xar@0.20.0
	ar@0.9.0
	arbitrary@1.3.2
	arrayvec@0.7.4
	assert_cmd@2.0.16
	autocfg@1.3.0
	backtrace@0.3.71
	base64@0.22.1
	base64ct@1.6.0
	bcder@0.7.4
	bit-set@0.6.0
	bit-vec@0.7.0
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	bstr@1.9.1
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.9.0
	bzip2-sys@0.1.13+1.0.8
	bzip2@0.4.4
	bzip2@0.5.2
	cc@1.1.30
	cfb@0.7.3
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.5.31
	clap_builder@4.5.31
	clap_derive@4.5.28
	clap_lex@0.7.4
	colorchoice@1.0.1
	const-oid@0.9.6
	core-foundation-sys@0.8.6
	cpio-archive@0.10.0
	cpufeatures@0.2.12
	crc-catalog@2.4.0
	crc32fast@1.4.2
	crc@3.2.1
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	cryptographic-message-syntax@0.27.0
	debpkg@0.6.0
	der@0.7.9
	deranged@0.3.11
	derive_arbitrary@1.3.2
	difflib@0.4.0
	digest@0.10.7
	directories@6.0.0
	dirs-sys@0.5.0
	displaydoc@0.2.5
	doc-comment@0.3.3
	either@1.12.0
	env_filter@0.1.0
	env_home@0.1.0
	env_logger@0.11.6
	equivalent@1.0.1
	errno@0.3.10
	exitcode@1.1.2
	fastrand@2.1.1
	filetime@0.2.23
	filetime_creation@0.2.0
	flate2@1.1.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	fs2@0.4.3
	fs_extra@1.3.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	futures@0.3.30
	generic-array@0.14.7
	getrandom@0.2.15
	getrandom@0.3.1
	gimli@0.28.1
	glob@0.3.1
	hashbrown@0.12.3
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	http-body-util@0.1.1
	http-body@1.0.0
	http@1.1.0
	httparse@1.8.0
	humantime@2.1.0
	hyper-rustls@0.27.2
	hyper-util@0.1.10
	hyper@1.5.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@1.9.3
	indexmap@2.7.1
	infer@0.19.0
	infer@0.8.1
	ipnet@2.9.0
	is_executable@1.0.4
	is_terminal_polyfill@1.70.0
	itoa@1.0.11
	jobserver@0.1.31
	js-sys@0.3.69
	libc@0.2.168
	libredox@0.1.3
	libz-sys@1.1.20
	linux-raw-sys@0.4.14
	litemap@0.7.4
	log@0.4.26
	lzma-rust@0.1.7
	lzma-sys@0.1.20
	md-5@0.10.6
	memchr@2.7.4
	mime@0.3.17
	miniz_oxide@0.7.2
	miniz_oxide@0.8.5
	mio@1.0.2
	nt-time@0.8.1
	num-conv@0.1.0
	num-traits@0.2.19
	object@0.32.2
	once_cell@1.19.0
	option-ext@0.2.0
	pem@3.0.4
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.92
	quinn-proto@0.11.6
	quinn-udp@0.5.4
	quinn@0.11.3
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	redox_users@0.5.0
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	relative-path@1.9.3
	reqwest@0.12.12
	ring@0.17.8
	rstest@0.19.0
	rstest_macros@0.19.0
	rustc-demangle@0.1.24
	rustc-hash@2.0.0
	rustc_version@0.4.1
	rustix@0.38.42
	rustls-pemfile@2.1.2
	rustls-pki-types@1.7.0
	rustls-webpki@0.102.6
	rustls@0.23.12
	ryu@1.0.18
	same-file@1.0.6
	scroll@0.12.0
	scroll_derive@0.12.0
	semver@1.0.23
	serde-xml-rs@0.6.0
	serde@1.0.218
	serde_derive@1.0.218
	serde_json@1.0.140
	serde_spanned@0.6.8
	serde_urlencoded@0.7.1
	sevenz-rust@0.6.1
	sha1@0.10.6
	sha2@0.10.8
	shlex@1.3.0
	signature@2.2.0
	simple-file-manifest@0.11.0
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	spin@0.9.8
	spki@0.7.3
	stable_deref_trait@1.2.0
	strsim@0.11.1
	subtle@2.5.0
	syn@2.0.90
	sync_wrapper@1.0.1
	synstructure@0.13.1
	tar@0.4.43
	tempfile@3.17.1
	termtree@0.4.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.6
	thiserror@1.0.69
	thiserror@2.0.6
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinystr@0.7.6
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.5.0
	tokio-rustls@0.26.0
	tokio@1.43.0
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.2
	tracing-core@0.1.32
	tracing@0.1.40
	try-lock@0.2.5
	typenum@1.17.0
	unicode-ident@1.0.13
	untrusted@0.9.0
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.1
	uuid@1.8.0
	vcpkg@0.2.15
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	webpki-roots@0.26.1
	which@7.0.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-registry@0.2.0
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.3
	winsafe@0.0.19
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	x509-certificate@0.24.0
	xattr@1.3.1
	xml-rs@0.8.24
	xz2@0.1.7
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zeroize@1.8.1
	zeroize_derive@1.4.2
	zerovec-derive@0.10.3
	zerovec@0.10.4
	zip@2.2.3
	zstd-safe@5.0.2+zstd.1.5.2
	zstd-sys@2.0.10+zstd.1.5.6
	zstd@0.11.2+zstd.1.5.2
"

inherit cargo

DESCRIPTION="CLI tool that manages the browser/driver infrastructure required by Selenium"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/SeleniumHQ/selenium"
SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/SeleniumHQ/selenium/archive/refs/tags/selenium-${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/selenium-selenium-${PV}/rust"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="test? ( || ( www-client/firefox www-client/firefox-bin ) )"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	# Avoid tests requiring a network
	rm -f tests/{browser_download,chrome_download,grid}_tests.rs || die

	# Avoid tests requiring a specific browser to be installed to keep
	# the dependency tree manageable.
	rm -f tests/{cli,iexplorer,output,safari,stable_browser}_tests.rs || die
	sed -i -e '/case.*\(chrome\|edge\|iexplorer\)/ s:^://:' tests/{browser,config,exec_driver}_tests.rs || die
	sed -e '/browser_version_test/,/^}/ s:^://:' \
		-e '/#\[test\]/,/^}/ s:^://:' \
		-i tests/browser_tests.rs || die
}

src_install() {
	default

	cargo_src_install

	dodoc README.md
}
