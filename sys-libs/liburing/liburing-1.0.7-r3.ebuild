# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs rhel8-a

DESCRIPTION="Efficient I/O with io_uring"
HOMEPAGE="https://github.com/axboe/liburing"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
LICENSE="MIT"
SLOT="0/1.0.7" # liburing.so version

IUSE="static-libs"
# fsync test hangs forever
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7-ucontext_h-detection.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libdevdir="${EPREFIX}/usr/$(get_libdir)"
		--mandir="${EPREFIX}/usr/share/man"
		--cc="$(tc-getCC)"
	)
	# No autotools configure! "econf" will fail.
	TMPDIR="${T}" ./configure "${myconf[@]}"
}

multilib_src_compile() {
	emake V=1 AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}

multilib_src_test() {
	emake V=1 runtests
}
