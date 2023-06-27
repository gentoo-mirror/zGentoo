# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

ESCRIPTION="Cirrus Logic firmware blobs"
HOMEPAGE="https://www.cirrus.com/"

EGIT_COMMIT="5d521dc7d8584399f5dff26839a24142d53c6a33"
EGIT_REPO_URI="https://gitlab.com/asus-linux/firmware"

LICENSE="unknown"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="sys-kernel/linux-firmware"

src_install() {
    [ -f /var/db/pkg/sys-kernel/linux-firmware-*/CONTENTS ] && die "Could not determine the base-firmware blobs."
    list=`cat /var/db/pkg/sys-kernel/linux-firmware-*/CONTENTS | grep cirrus | awk '{print $2}'`
    for f in `find cirrus \( -type l -o -type f \)`; do
        if ! [[ $list =~ .*"${f}".* ]]; then
            insinto /lib/firmware/`dirname ${f}`
            doins ${f}
        fi
    done
}
