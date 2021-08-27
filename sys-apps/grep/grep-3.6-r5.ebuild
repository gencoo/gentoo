# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs rhel

DESCRIPTION="GNU regular expression matcher"
HOMEPAGE="https://www.gnu.org/software/grep/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls pcre static"

# We lack dev-libs/libsigsegv[static-libs] for now
REQUIRED_USE="static? ( !sparc )"

LIB_DEPEND="pcre? ( >=dev-libs/libpcre-7.8-r1[static-libs(+)] )
	dev-libs/libsigsegv"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	nls? ( virtual/libintl )
	virtual/libiconv"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	sed -i \
		-e "s:@SHELL@:${EPREFIX}/bin/sh:g" \
		-e "s:@grep@:${EPREFIX}/bin/grep:" \
		src/egrep.sh || die #523898

	default
}

src_configure() {
	use static && append-ldflags -static

	# We used to turn this off unconditionally (bug #673524) but we now
	# allow it for cases where libsigsegv is better for userspace handling
	# of stack overflows.
	# In particular, it's necessary for sparc: bug #768135
	export ac_cv_libsigsegv=$(usex sparc)

	# Always use pkg-config to get lib info for pcre.
	export ac_cv_search_pcre_compile=$(
		usex pcre "$($(tc-getPKG_CONFIG) --libs $(usex static --static '') libpcre)" ''
	)
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--without-included-regex
		--disable-silent-rules
		CPPFLAGS="-I${_includedir}/pcre"
		CFLAGS="${CFLAGS}"
		$(use_enable nls)
		$(use_enable pcre perl-regexp)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -f "${ED}"/usr/share/info/dir

	dodir ${_sysconfdir}/profile.d
	insinto ${_sysconfdir}/profile.d/
	doins ${WORKDIR}/colorgrep.sh

	insinto ${_sysconfdir}/
	doins ${WORKDIR}/GREP_COLORS

	insinto ${_libexecdir}/
	insopts -m0755
	doins ${WORKDIR}/grepconf.sh
}
