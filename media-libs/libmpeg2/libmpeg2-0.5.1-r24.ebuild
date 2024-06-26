# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal rhel9-a

DESCRIPTION="Library for decoding mpeg-2 and mpeg-1 video"
HOMEPAGE="https://libmpeg2.sourceforge.io/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="sdl X"

RDEPEND="
	sdl? ( media-libs/libsdl )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXt
		x11-libs/libXv
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${P}-altivec.patch
	"${FILESDIR}"/${P}-arm-private-symbols.patch
	"${FILESDIR}"/${P}-armv4l.patch
	"${FILESDIR}"/${P}-global-symbol-test.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--enable-shared \
		$(multilib_native_use_enable sdl) \
		$(multilib_native_use_with X x)

	# remove useless subdirs
	multilib_is_native_abi || sed -i -e 's/ libvo src//' Makefile || die
}

multilib_src_compile() {
	# mpeg2dec have rpath
	# remove rpath from libtool
	sed -i.rpath 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool || die
	sed -i.rpath 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool || die

	emake {MPEG2DEC,OPT}_CFLAGS="${CFLAGS}" LIBMPEG2_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
	insinto ${_includedir}/mpeg2dec/
	doins libmpeg2/mpeg2_internal.h
}
