# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs flag-o-matic bash-completion-r1 rhel8

DESCRIPTION="Lists directories recursively, and produces an indented listing of files"
HOMEPAGE="http://mama.indstate.edu/users/ice/tree/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	sed -i -e 's:LINUX:__linux__:' tree.c || die
	mv doc/tree.1.fr doc/tree.fr.1
	if use !elibc_glibc ; then
		# 433972, also previously done only for elibc_uclibc
		sed -i -e '/^OBJS=/s/$/ strverscmp.o/' Makefile || die
	fi
	default
}

src_compile() {
	append-lfs-flags
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin tree
	doman doc/tree*.1
	einstalldocs
	newbashcomp "${FILESDIR}"/${PN}.bashcomp ${PN}
}
