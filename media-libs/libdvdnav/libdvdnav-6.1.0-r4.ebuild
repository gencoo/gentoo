# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal rhel9-a

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="https://www.videolan.org/developers/libdvdnav.html"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

RDEPEND=">=media-libs/libdvdread-6.0.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
# To get pkg.m4 for eautoreconf #414391
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog doc/dvd_structures doc/library_layout README TODO )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
}
