# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/acarl005/stripansi 5a71ef0e047d"
	"github.com/adrianmo/go-nmea v1.3.0"
	"github.com/antchfx/jsonquery v1.1.4"
	"github.com/antchfx/xpath v1.1.11"
	"github.com/bettercap/gatt df6e615f2f67"
	"github.com/bettercap/nrf24 aa37e6d0e0eb"
	"github.com/bettercap/readline 655e48bcb7bf"
	"github.com/bettercap/recording 3ce1dcf032e3"
	"github.com/chifflier/nfqueue-go 61ca646babef"
	"github.com/chzyer/logex v1.1.10"
	"github.com/chzyer/test a1ea475d72b1"
	"github.com/dustin/go-humanize v1.0.0"
	"github.com/elazarl/goproxy a92cc753f88e"
	"github.com/evilsocket/islazy v1.10.6"
	"github.com/gobwas/glob e7a84e9525fe"
	"github.com/golang/groupcache 41bb18bfe9da"
	"github.com/google/go-cmp v0.5.5"
	"github.com/google/go-github v17.0.0"
	"github.com/google/go-querystring v1.1.0"
	"github.com/google/gopacket v1.1.19"
	"github.com/google/gousb v2.1.0"
	"github.com/gorilla/mux v1.8.0"
	"github.com/gorilla/websocket v1.4.2"
	"github.com/hashicorp/mdns v1.0.3"
	"github.com/inconshreveable/go-vhost 06d84117953b"
	"github.com/jpillora/go-tld v1.1.1"
	"github.com/koppacetic/go-gpsd v0.4.0"
	"github.com/kr/binarydist v0.1.0"
	"github.com/malfunkt/iprange v0.9.0"
	"github.com/mdlayher/dhcp6 2a67805d7d0b"
	"github.com/miekg/dns v1.1.41"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/pkg/errors v0.9.1"
	"github.com/robertkrimen/otto ef014fd054ac"
	"github.com/tarm/serial 98f6abe2eb07"
	"github.com/thoj/go-ircevent 8e7ce4b5a1eb"
	"golang.org/x/net afb366fc7cd1 github.com/golang/net"
	"golang.org/x/sys e8d321eab015 github.com/golang/sys"
	"golang.org/x/xerrors 5ec99f83aff1 github.com/golang/xerrors"
	"gopkg.in/sourcemap.v1 v1.0.5 github.com/go-sourcemap/sourcemap"
	
	# sub dependencies
	"github.com/mgutz/logxi v1"
	"github.com/mgutz/ansi d51e80e"
	"github.com/mattn/go-colorable v0.1.8"
	"github.com/mattn/go-isatty v0.0.13"
	"golang.org/x/text v0.3.6 github.com/golang/text"
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
