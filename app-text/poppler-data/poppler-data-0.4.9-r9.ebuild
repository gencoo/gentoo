# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rhel9-a

DESCRIPTION="Data files for poppler to support uncommon encodings without xpdfrc"
HOMEPAGE="https://poppler.freedesktop.org/"

LICENSE="BSD GPL-2 MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

src_install() {
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install

	# bug 409361
	dodir /usr/share/poppler/cMaps
	cd "${D}/${EPREFIX}"/usr/share/poppler/cMaps || die
	find ../cMap -type f -exec ln -s {} . \; || die
}
