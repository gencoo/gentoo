# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs rhel8-a

GDB_VERSION=10.2
UPSTREAM_VER=
EXTRA_VER=0

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/crash-utility/crash.git"
	SRC_URI="mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
	EGIT_BRANCH="master"
	inherit git-r3
else
	[[ -n ${UPSTREAM_VER} ]] && \
		UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${P}-patches-${UPSTREAM_VER}.tar.xz"

	[[ -n ${EXTRA_VER} ]] && \
		EXTRA_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${PN}-8.0.3-extra-${EXTRA_VER}.tar.xz"

	SRC_URI+=" 
		${UPSTREAM_PATCHSET_URI} ${EXTRA_PATCHSET_URI}"
	#	mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
	KEYWORDS="-* ~alpha amd64 ~arm ~ia64 ~ppc64 ~riscv ~s390 ~x86"
fi

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://crash-utility.github.io/"

LICENSE="GPL-3"
SLOT="0"
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"

DEPEND="sys-libs/ncurses
	sys-libs/zlib
	dev-libs/lzo
	sys-devel/bison
	app-arch/snappy"

src_prepare() {
	default

	if [[ -n ${UPSTREAM_VER} ]]; then
		einfo "Try to apply Crash's Upstream patch set"
		eapply "${WORKDIR}"/patches-upstream
	fi

	if [[ -n ${EXTRA_VER} ]]; then
		einfo "Try to apply Crash's Extra patch set"
		eapply "${WORKDIR}"/patches-extra
	fi

	sed -i -e "s|ar -rs|\${AR} -rs|g" Makefile || die
	ln -s "${WORKDIR}"/gdb-10.2.tar.gz . || die
}

src_configure() {
	# bug #858344
	filter-lto

	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
