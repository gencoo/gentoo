# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DSUFFIX="_9"
inherit autotools rhel8

DESCRIPTION="Excellent text file viewer"
HOMEPAGE="http://www.greenwoodsoftware.com/less/"

LICENSE="|| ( GPL-3 BSD-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pcre unicode"

DEPEND=">=app-misc/editor-wrapper-3
	>=sys-libs/ncurses-5.2:0=
	pcre? ( dev-libs/libpcre2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	rm -f ./configure
	eautoreconf
}

src_configure() {
	append-cflags -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

	export ac_cv_lib_ncursesw_initscr=$(usex unicode)
	export ac_cv_lib_ncurses_initscr=$(usex !unicode)
	local myeconfargs=(
		--with-regex=$(usex pcre pcre2 posix)
		--with-editor="${EPREFIX}"/usr/libexec/editor
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newbin "${FILESDIR}"/lesspipe-r1.sh lesspipe
	newenvd "${FILESDIR}"/less.envd 70less

	dobin "${WORKDIR}"/lesspipe.sh

	insinto /etc/profile.d
	doins "${WORKDIR}"/less.{c,}sh
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-483-r1" ; then
		elog "The lesspipe.sh symlink has been dropped.  If you are still setting"
		elog "LESSOPEN to that, you will need to update it to '|lesspipe %s'."
		elog "Colorization support has been dropped.  If you want that, check out"
		elog "the new app-text/lesspipe package."
	fi
}
