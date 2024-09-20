# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd

DESCRIPTION="MOP server and utilities for Linux"
HOMEPAGE="https://lab.simple-co.de/zappel/netbsd-mopd"
EGIT_REPO_URI="https://lab.simple-co.de/zappel/netbsd-mopd.git"
EGIT_COMMIT="453051d7"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd -ultrix"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
    emake -f Makefile.linux
}

src_install() {
    emake -f Makefile.linux install PREFIX=${D}/usr
    ! use ultrix && rm ${D}/usr/bin/mkultconf

    dodoc ${S}/README.md

    doman ${S}/*/*.1
    doman ${S}/*/*.8

    ## install needed confs/systemd
    insinto /etc/mopd
    newins "${FILESDIR}/mopd.conf" "mopd.conf"
    use systemd && systemd_dounit "${FILESDIR}/mopd.service"
    ## todo: init.d

    # firmware directory
    keepdir /var/tftp/mop
}

pkg_postinst() {
    ewarn "Serverconfig: /etc/mopd/mopd.conf"
    ewarn "Firmware dir: /var/tftp/mop"
}
