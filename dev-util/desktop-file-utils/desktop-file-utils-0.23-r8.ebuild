# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit elisp-common rhel8-a

DESCRIPTION="Command line utilities to work with desktop menu entries"
HOMEPAGE="https://freedesktop.org/wiki/Software/desktop-file-utils"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="emacs"

RDEPEND=">=dev-libs/glib-2.12:2
	emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

SITEFILE=desktop-entry-mode-init.el

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_prepare() {
	default
	sed -i -e '/SUBDIRS =/s:misc::' Makefile.in || die
}

src_configure() {
	econf "$(use_with emacs lispdir "${SITELISP}"/${PN})"
}

src_compile() {
	default
	use emacs && elisp-compile misc/desktop-entry-mode.el
}

src_install() {
	default
	if use emacs; then
		elisp-install ${PN} misc/*.el misc/*.elc || die
		elisp-site-file-install "${WORKDIR}"/${SITEFILE} || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
