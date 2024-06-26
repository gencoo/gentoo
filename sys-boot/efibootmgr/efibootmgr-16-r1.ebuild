# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs rhel8

DESCRIPTION="User-space application to modify the EFI boot manager"
HOMEPAGE="https://github.com/rhinstaller/efibootmgr"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 x86"
IUSE=""

RDEPEND="sys-apps/pciutils
	>=sys-libs/efivar-25:="
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e 's/-Werror //' Make.defaults || die
}

src_configure() {
	tc-export CC
	export EFIDIR="Gentoo"
}

src_compile() {
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)"
}
