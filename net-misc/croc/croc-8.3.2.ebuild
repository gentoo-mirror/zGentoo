# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/OneOfOne/xxhash v1.2.5"
	"github.com/cespare/xxhash v1.1.0"
	"github.com/cpuguy83/go-md2man v2.0.0"
	"github.com/denisbrodbeck/machineid v1.0.1"
	"github.com/fatih/color v1.9.0"
	"github.com/kalafut/imohash v1.0.0"
	"github.com/kr/pretty v0.1.0"
	"github.com/mattn/go-colorable v0.1.7"
	"github.com/schollz/logger v1.2.0"
	"github.com/schollz/mnemonicode v1.0.1"
	"github.com/schollz/pake v2.0.4"
	"github.com/schollz/peerdiscovery v1.6.0"
	"github.com/schollz/progressbar v3.5.1"
	"github.com/schollz/spinner 1.2"
	"github.com/spaolacci/murmur3 v1.1.0"
	"github.com/stretchr/testify v1.4.0"
	"github.com/tscholl2/siec master"
	"github.com/urfave/cli v2.2.0"
	"github.com/golang/crypto 5c72a88"
	"github.com/golang/net master"
	"github.com/golang/sys master"
	"github.com/golang/text v0.3.3"
	"github.com/go-check/check v1"
	"github.com/go-yaml/yaml v2.3.0"
	"github.com/mattn/go-runewidth v0.0.9"
	"github.com/mitchellh/colorstring master"
	"github.com/russross/blackfriday v2.0.1"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
)

EGO_PN="github.com/schollz/croc"
inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz  ${EGO_VENDOR_URI}"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"

DESCRIPTION="a tool that allows any two computers to simply and securely transfer files and folders"
HOMEPAGE="https:/github.com/schollz/croc"
LICENSE="MIT"
SLOT=0
IUSE=""
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	# patching .vN and other changed namespaces (upstream compatibility)
	for gs in `find . -name \*.go`; do
		for i in {1..3}; do sed -i "s~\/v${i}~~g" "${gs}"; done
		for i in {crypto,net,sys,text}; do 
			sed -i "s~golang.org\/x\/${i}~github.com\/golang\/${i}~g" "${gs}"
		done
	done
}

src_install() {
	dobin croc
	dodoc src/github.com/schollz/croc/README.md
}
