# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal rhel8

DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="https://www.gnu.org/software/gdbm/"

LICENSE="GPL-3"
SLOT="0/6" # libgdbm.so version
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+berkdb nls readline static-libs"

DEPEND="
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.18.1-gettext.patch #696838
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# gdbm doesn't appear to use either of these libraries
	export ac_cv_lib_dbm_main=no ac_cv_lib_ndbm_main=no

	local myeconfargs=(
		--includedir="${EPREFIX}"/usr/include/gdbm
		--disable-rpath
		$(use_enable berkdb libgdbm-compat)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_with readline)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
	# get rid of rpath (as per https://fedoraproject.org/wiki/Packaging:Guidelines#Beware_of_Rpath)
	# currently --disable-rpath doesn't work for gdbm_dump|load, gdbmtool and libgdbm_compat.so.4
	# https://puszcza.gnu.org.ua/bugs/index.php?359
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	fi

	mv "${ED}"/usr/include/gdbm/gdbm.h "${ED}"/usr/include/ || die
}
