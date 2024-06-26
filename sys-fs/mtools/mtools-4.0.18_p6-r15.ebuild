# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

suffix_ver=$(ver_cut 5)
[[ ${suffix_ver} ]] && DSUFFIX="_${suffix_ver}"

inherit flag-o-matic autotools rhel8

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="https://www.gnu.org/software/mtools/ https://savannah.gnu.org/projects/mtools"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x64-macos ~x64-solaris"
IUSE="X elibc_glibc"

RDEPEND="
	!elibc_glibc? ( virtual/libiconv )
	X? (
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}"

src_prepare() {
 	default
	# Don't throw errors on existing directories
	sed -i -e "s:mkdir:mkdir -p:" mkinstalldirs || die

	eapply "${FILESDIR}"/${MY_P}-locking.patch # https://crbug.com/508713
	eapply "${FILESDIR}"/${MY_P}-attr.patch # https://crbug.com/644387
	eapply "${FILESDIR}"/${MY_P}-memset.patch

	eautoreconf
}

src_configure() {
	use !elibc_glibc && use !elibc_musl && append-libs "-liconv" #447688
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/mtools
		--disable-floppyd
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local -a DOCS=( README* Release.notes )
	default

	insinto /etc/mtools
	doins mtools.conf

	# default is fine
	sed -i -e '/^SAMPLE FILE$/s:^:#:' "${ED}"/etc/mtools/mtools.conf || die
}
