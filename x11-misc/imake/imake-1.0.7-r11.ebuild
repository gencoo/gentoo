# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xorg-3 rhel-p

DESCRIPTION="C preprocessor interface to the make utility"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="x11-misc/xorg-cf-files"
BDEPEND="x11-base/xorg-proto"

S="${WORKDIR}/${P}/${P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.8-cpp-args.patch
	"${FILESDIR}"/${PN}-1.0.8-no-get-gcc.patch
	"${FILESDIR}"/${PN}-1.0.8-respect-LD.patch
	"${FILESDIR}"/${PN}-1.0.8-xmkmf-pass-cc-ld.patch
)

src_configure() {
	econf CPP="$(tc-getPROG CPP cpp)" #722046
}
