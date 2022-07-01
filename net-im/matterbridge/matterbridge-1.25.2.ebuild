# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

## WARNING: still under review - error in QA (perms) .. 

inherit check-reqs go-module systemd

DESCRIPTION="A simple chat bridge - for matrix"
HOMEPAGE="https://github.com/42wim/matterbridge/wiki"
SRC_URI="
    https://github.com/42wim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
    https://vendors.retarded.farm/${PN}/vendor-${P}.tar.xz
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"
QA_PRESTRIPPED=("build/${PN}")
# needed for MS Teams
CHECKREQS_MEMORY="4G"

DEPEND="acct-group/${PN}
    acct-user/${PN}
    >=dev-lang/go-1.17"

src_unpack() {
    default
    mv vendor "${S}/vendor"
}

src_compile() {
    einfo "Building binaries using go.."
    go build -mod=vendor -o build/${PN} ${PN}.go || die "compile failed"
    # chmod -w build/${PN} || die "can't change permissions"
}

src_install() {
    dobin build/${PN}

    # config
    insinto /etc/${PN}
    newins ${PN}.toml.sample bridge.toml.sample

    # service
    if use systemd; then 
        systemd_dounit contrib/${PN}.service
    else
        newinitd contrib/${PN}.initd ${PN}
    fi

    # docs
    dodoc README.md

    # etc and permissions
    keepdir /etc/${PN}
    fowners ${PN}:${PN} /etc/${PN}/bridge.toml.sample
    fperms 0640 /etc/${PN}/bridge.toml.sample

    # working dirs and permissions
    keepdir /var/{lib,log}/${PN}
    fowners ${PN}:${PN} /var/{lib,log}/${PN}
    fperms 0750 /var/{lib,log}/${PN}
}
