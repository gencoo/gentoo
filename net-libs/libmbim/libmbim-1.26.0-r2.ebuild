# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..10} )
inherit python-any-r1 rhel9

DESCRIPTION="Mobile Broadband Interface Model (MBIM) modem protocol helper library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libmbim/ https://gitlab.freedesktop.org/mobile-broadband/libmbim"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ppc64 ~riscv x86"

RDEPEND=">=dev-libs/glib-2.56:2"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-Werror \
		--disable-static \
		--disable-gtk-doc
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
