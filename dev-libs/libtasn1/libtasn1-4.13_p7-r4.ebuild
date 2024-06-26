# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

suffix_ver=$(ver_cut 4)
[[ ${suffix_ver} ]] && DSUFFIX="_${suffix_ver}"

inherit multilib-minimal libtool rhel8

DESCRIPTION="ASN.1 library"
HOMEPAGE="https://www.gnu.org/software/libtasn1/"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0/6" # subslot = libtasn1 soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test valgrind"

RESTRICT="!test? ( test )"

BDEPEND="sys-apps/help2man
	virtual/yacc
	test? ( valgrind? ( dev-util/valgrind ) )"

DOCS=(
	AUTHORS
	ChangeLog
	NEWS
	THANKS
)

pkg_setup() {
	if use doc; then
		DOCS+=( doc/libtasn1.pdf )
		HTML_DOCS=( doc/reference/html/. )
	fi
}

src_prepare() {
	default
	elibtoolize  # for Solaris shared library
	autoreconf -v -f --install
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable static-libs static)
		$(multilib_native_use_enable valgrind valgrind-tests)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
