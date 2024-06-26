# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools rhel8-a

DESCRIPTION="Multitouch Protocol Translation Library"
HOMEPAGE="https://bitmath.org/code/mtdev/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

DEPEND=">=sys-kernel/linux-headers-2.6.31"

src_prepare() {
	default
	autoreconf --force -v --install
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
