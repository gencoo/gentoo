# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DSUFFIX=".2"
inherit multilib-minimal toolchain-funcs autotools flag-o-matic rhel9-a

DESCRIPTION="A free implementation of the unicode bidirectional algorithm"
HOMEPAGE="https://fribidi.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=""
DEPEND=""
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS NEWS ChangeLog THANKS ) # README points at README.md which wasn't disted with EAPI-7

src_prepare() {
	default
	eautoreconf -i
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"
}

multilib_src_configure() {
	append-cflags -DPAGE_SIZE=4096

	local myeconfargs=(
		--enable-shared
		--disable-static
		--disable-debug
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
