# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.82.0"
CRATES="
    addr2line@0.24.1
    adler2@2.0.0
    adler32@1.2.0
    ahash@0.8.11
    aho-corasick@1.1.3
    aligned-vec@0.6.1
    allocator-api2@0.2.18
    android_system_properties@0.1.5
    android-tzdata@0.1.1
    anstream@0.6.15
    anstyle-parse@0.2.5
    anstyle-query@1.1.1
    anstyle-wincon@3.0.4
    anstyle@1.0.8
    anyhow@1.0.89
    arraydeque@0.5.1
    arrayvec@0.7.6
    async-compression@0.4.12
    async-trait@0.1.82
    autocfg@1.3.0
    backtrace@0.3.74
    base64@0.21.7
    base64@0.22.1
    bincode_derive@2.0.0-rc.3
    bincode@1.3.3
    bincode@2.0.0-rc.3
    bitflags@1.3.2
    bitflags@2.6.0
    block-buffer@0.10.4
    bstr@1.10.0
    bumpalo@3.16.0
    bytemuck@1.18.0
    byteorder@1.5.0
    bytes@1.7.2
    cacache@13.0.0
    cc@1.1.21
    cfg-if@1.0.0
    chrono-tz-build@0.3.0
    chrono-tz@0.9.0
    chrono@0.4.38
    clap_builder@4.5.21
    clap_complete@4.5.38
    clap_derive@4.5.18
    clap_lex@0.7.2
    clap_mangen@0.2.24
    clap@4.5.21
    colorchoice@1.0.2
    config@0.14.1
    console@0.15.8
    conventional_commit_parser@0.9.4
    core-foundation-sys@0.8.7
    core-foundation@0.9.4
    core2@0.4.0
    cpp_demangle@0.4.4
    cpufeatures@0.2.14
    crc32fast@1.4.2
    crossbeam-deque@0.8.5
    crossbeam-epoch@0.9.18
    crossbeam-utils@0.8.20
    crypto-common@0.1.6
    dary_heap@0.3.6
    debugid@0.8.0
    deranged@0.3.11
    deunicode@1.6.0
    diff@0.1.13
    digest@0.10.7
    directories@5.0.1
    dirs-sys@0.4.1
    dirs@5.0.1
    displaydoc@0.2.5
    dissimilar@1.0.9
    doc-comment@0.3.3
    document-features@0.2.10
    dyn-clone@1.0.17
    either@1.13.0
    encode_unicode@0.3.6
    encoding_rs@0.8.34
    env_logger@0.10.2
    equator-macro@0.2.1
    equator@0.2.2
    equivalent@1.0.1
    errno@0.3.9
    expect-test@1.5.0
    fastrand@2.1.1
    findshlibs@0.10.2
    flate2@1.0.33
    fnv@1.0.7
    form_urlencoded@1.2.1
    futures-channel@0.3.31
    futures-core@0.3.31
    futures-executor@0.3.31
    futures-io@0.3.31
    futures-macro@0.3.31
    futures-sink@0.3.31
    futures-task@0.3.31
    futures-util@0.3.31
    futures@0.3.31
    generic-array@0.14.7
    getrandom@0.2.15
    gimli@0.31.0
    git-conventional@0.12.7
    git2@0.19.0
    glob@0.3.1
    globset@0.4.15
    globwalk@0.9.1
    h2@0.3.26
    hashbrown@0.14.5
    hashbrown@0.15.1
    hashlink@0.8.4
    heck@0.5.0
    hermit-abi@0.3.9
    hermit-abi@0.4.0
    hex@0.4.3
    http-body-util@0.1.2
    http-body@0.4.6
    http-body@1.0.1
    http-cache-reqwest@0.15.0
    http-cache-semantics@2.1.0
    http-cache@0.20.0
    http-serde@2.1.1
    http@0.2.12
    http@1.1.0
    httparse@1.9.4
    httpdate@1.0.3
    humansize@2.1.3
    humantime@2.1.0
    hyper-rustls@0.24.2
    hyper-rustls@0.27.3
    hyper-util@0.1.8
    hyper@0.14.30
    hyper@1.4.1
    iana-time-zone-haiku@0.1.2
    iana-time-zone@0.1.61
    icu_collections@1.5.0
    icu_locid_transform_data@1.5.0
    icu_locid_transform@1.5.0
    icu_locid@1.5.0
    icu_normalizer_data@1.5.0
    icu_normalizer@1.5.0
    icu_properties_data@1.5.0
    icu_properties@1.5.1
    icu_provider_macros@1.5.0
    icu_provider@1.5.0
    idna_adapter@1.2.0
    idna@1.0.3
    ignore@0.4.23
    include-flate-codegen@0.2.0
    include-flate@0.3.0
    indexmap@2.6.0
    indicatif@0.17.9
    inferno@0.11.21
    ipnet@2.10.0
    is_terminal_polyfill@1.70.1
    is-terminal@0.4.13
    itoa@1.0.11
    jobserver@0.1.32
    js-sys@0.3.70
    lazy_static@1.5.0
    lazy-regex-proc_macros@3.3.0
    lazy-regex@3.3.0
    libc@0.2.158
    libflate_lz77@2.1.0
    libflate@2.1.0
    libgit2-sys@0.17.0+1.8.1
    libm@0.2.8
    libredox@0.1.3
    libz-sys@1.1.20
    linux-raw-sys@0.4.14
    litemap@0.7.3
    litrs@0.4.1
    lock_api@0.4.12
    log@0.4.22
    memchr@2.7.4
    memmap2@0.5.10
    memmap2@0.9.5
    miette-derive@5.10.0
    miette@5.10.0
    mime@0.3.17
    minimal-lexical@0.2.1
    miniz_oxide@0.8.0
    mio@1.0.2
    next_version@0.2.19
    nix@0.26.4
    nom@7.1.3
    num-conv@0.1.0
    num-format@0.4.4
    num-traits@0.2.19
    number_prefix@0.4.0
    object@0.36.4
    once_cell@1.19.0
    option-ext@0.2.0
    parking_lot_core@0.9.10
    parking_lot@0.12.3
    parse-zoneinfo@0.3.1
    pathdiff@0.2.1
    percent-encoding@2.3.1
    pest_derive@2.7.13
    pest_generator@2.7.13
    pest_meta@2.7.13
    pest@2.7.13
    phf_codegen@0.11.2
    phf_generator@0.11.2
    phf_shared@0.11.2
    phf@0.11.2
    pin-project-internal@1.1.5
    pin-project-lite@0.2.14
    pin-project@1.1.5
    pin-utils@0.1.0
    pkg-config@0.3.30
    portable-atomic@1.8.0
    powerfmt@0.2.0
    pprof@0.14.0
    ppv-lite86@0.2.20
    pretty_assertions@1.4.1
    proc-macro2@1.0.86
    quick-xml@0.26.0
    quinn-proto@0.11.8
    quinn-udp@0.5.5
    quinn@0.11.5
    quote@1.0.37
    rand_chacha@0.3.1
    rand_core@0.6.4
    rand@0.8.5
    redox_syscall@0.5.4
    redox_users@0.4.6
    reflink-copy@0.1.19
    regex-automata@0.4.9
    regex-syntax@0.8.5
    regex@1.11.1
    reqwest-middleware@0.4.0
    reqwest@0.11.27
    reqwest@0.12.9
    rgb@0.8.50
    ring@0.17.8
    rle-decode-fast@1.0.3
    roff@0.2.2
    rust-embed-impl@8.5.0
    rust-embed-utils@8.5.0
    rust-embed@8.5.0
    rustc-demangle@0.1.24
    rustc-hash@2.0.0
    rustix@0.38.37
    rustls-pemfile@1.0.4
    rustls-pemfile@2.1.3
    rustls-pki-types@1.8.0
    rustls-webpki@0.101.7
    rustls-webpki@0.102.8
    rustls@0.21.12
    rustls@0.23.13
    ryu@1.0.18
    same-file@1.0.6
    scopeguard@1.2.0
    sct@0.7.1
    secrecy@0.8.0
    semver@1.0.23
    serde_derive@1.0.215
    serde_json@1.0.133
    serde_regex@1.1.0
    serde_spanned@0.6.7
    serde_urlencoded@0.7.1
    serde@1.0.215
    sha-1@0.10.1
    sha1@0.10.6
    sha2@0.10.8
    shellexpand@3.1.0
    shlex@1.3.0
    siphasher@0.3.11
    slab@0.4.9
    slug@0.1.6
    smallvec@1.13.2
    socket2@0.5.7
    spin@0.9.8
    ssri@9.2.0
    stable_deref_trait@1.2.0
    str_stack@0.1.0
    strsim@0.11.1
    subtle@2.6.1
    symbolic-common@12.11.1
    symbolic-demangle@12.11.1
    syn@2.0.87
    sync_wrapper@0.1.2
    sync_wrapper@1.0.1
    synstructure@0.13.1
    system-configuration-sys@0.5.0
    system-configuration@0.5.1
    temp-dir@0.1.14
    tempfile@3.12.0
    tera@1.20.0
    termcolor@1.4.1
    terminal_size@0.4.0
    thiserror-impl@1.0.64
    thiserror-impl@2.0.3
    thiserror@1.0.64
    thiserror@2.0.3
    time-core@0.1.2
    time-macros@0.2.18
    time@0.3.36
    tinystr@0.7.6
    tinyvec_macros@0.1.1
    tinyvec@1.8.0
    tokio-macros@2.4.0
    tokio-rustls@0.24.1
    tokio-rustls@0.26.0
    tokio-stream@0.1.16
    tokio-util@0.7.12
    tokio@1.41.1
    toml_datetime@0.6.8
    toml_edit@0.22.21
    toml@0.8.19
    tower-layer@0.3.3
    tower-service@0.3.3
    tower@0.4.13
    tracing-core@0.1.32
    tracing@0.1.40
    try-lock@0.2.5
    typenum@1.17.0
    ucd-trie@0.1.6
    unic-char-property@0.9.0
    unic-char-range@0.9.0
    unic-common@0.9.0
    unic-segment@0.9.0
    unic-ucd-segment@0.9.0
    unic-ucd-version@0.9.0
    unicase@2.7.0
    unicode-ident@1.0.13
    unicode-width@0.1.14
    unicode-width@0.2.0
    untrusted@0.9.0
    update-informer@1.1.0
    ureq@2.10.1
    url@2.5.3
    urlencoding@2.1.3
    utf16_iter@1.0.5
    utf8_iter@1.0.4
    utf8parse@0.2.2
    uuid@1.10.0
    vcpkg@0.2.15
    version_check@0.9.5
    virtue@0.0.13
    walkdir@2.5.0
    want@0.3.1
    wasi@0.11.0+wasi-snapshot-preview1
    wasm-bindgen-backend@0.2.93
    wasm-bindgen-futures@0.4.43
    wasm-bindgen-macro-support@0.2.93
    wasm-bindgen-macro@0.2.93
    wasm-bindgen-shared@0.2.93
    wasm-bindgen@0.2.93
    web-sys@0.3.70
    web-time@1.1.0
    webpki-roots@0.25.4
    webpki-roots@0.26.6
    winapi-i686-pc-windows-gnu@0.4.0
    winapi-util@0.1.9
    winapi-x86_64-pc-windows-gnu@0.4.0
    winapi@0.3.9
    windows_aarch64_gnullvm@0.48.5
    windows_aarch64_gnullvm@0.52.6
    windows_aarch64_msvc@0.48.5
    windows_aarch64_msvc@0.52.6
    windows_i686_gnu@0.48.5
    windows_i686_gnu@0.52.6
    windows_i686_gnullvm@0.52.6
    windows_i686_msvc@0.48.5
    windows_i686_msvc@0.52.6
    windows_x86_64_gnu@0.48.5
    windows_x86_64_gnu@0.52.6
    windows_x86_64_gnullvm@0.48.5
    windows_x86_64_gnullvm@0.52.6
    windows_x86_64_msvc@0.48.5
    windows_x86_64_msvc@0.52.6
    windows-core@0.52.0
    windows-core@0.58.0
    windows-implement@0.58.0
    windows-interface@0.58.0
    windows-registry@0.2.0
    windows-result@0.2.0
    windows-strings@0.1.0
    windows-sys@0.48.0
    windows-sys@0.52.0
    windows-sys@0.59.0
    windows-targets@0.48.5
    windows-targets@0.52.6
    windows@0.58.0
    winnow@0.6.18
    winreg@0.50.0
    write16@1.0.0
    writeable@0.5.5
    xxhash-rust@0.8.12
    yaml-rust2@0.8.1
    yansi@1.0.1
    yoke-derive@0.7.4
    yoke@0.7.4
    zerocopy-derive@0.7.35
    zerocopy@0.7.35
    zerofrom-derive@0.1.4
    zerofrom@0.1.4
    zeroize@1.8.1
    zerovec-derive@0.10.3
    zerovec@0.10.4
    zstd-safe@7.2.1
    zstd-sys@2.0.13+zstd.1.5.6
    zstd@0.13.2
"

inherit cargo shell-completion

DESCRIPTION="A highly customizable Changelog Generator that follows Conventional Commit specifications"
HOMEPAGE="https://git-cliff.org/"
SRC_URI="
    https://github.com/orhun/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
    ${CARGO_CRATE_URIS}    
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
    
    # elv and ps1 are not supported at time of writing
    #newelvcomp "${release_dir}/completion/${PN}.elv" ${PN}
    #newps1comp "${release_dir}/completion/${PN}.ps1" ${PN}

    # docs and examples
    dodoc ${S}/README.md

    insinto /usr/share/doc/${P}/examples
    doins -r ${S}/examples/
}
