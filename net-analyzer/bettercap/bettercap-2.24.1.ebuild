# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/bettercap/gatt fac16c0ad797bbccae1fe4acf49761b98f7516e7"
	"github.com/bettercap/readline v1.4"
	"github.com/bettercap/recording 3ce1dcf032e391eb321311b34cdf31c6fc9523f5"
)

EGO_PN=github.com/bettercap/bettercap

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz ${EGO_VENDOR_URI}"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"

DESCRIPTION="A complete, modular, portable and easily extensible MITM framework"
HOMEPAGE="https://github.com/bettercap/bettercap/"
LICENSE="GPL-3"
SLOT=0
IUSE=""
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

#FIXME: add stable versions, see Gopkg.lock, "version"
#DEPEND="dev-go/go-isatty"
#	dev-go/gopacket
#	dev-go/mux
#	dev-go/websocket
#	dev-go/go-net
#	"

DEPEND="net-libs/libpcap
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink"

RDEPEND="${DEPEND}"

src_install() {
	dosbin bettercap
}
