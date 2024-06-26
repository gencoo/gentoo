# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs multilib-minimal rhel8

MY_P="${P//_/-}"

DESCRIPTION="SELinux binary policy representation library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 8888 ]]; then
	EGIT_REPO_URI="$EGIT_REPO_URI https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	KEYWORDS="amd64 ~arm arm64 ~mips x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"

# tests are not meant to be run outside of the full SELinux userland repo
RESTRICT="test"

src_prepare() {
	eapply_user
	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC AR RANLIB

	# https://bugs.gentoo.org/706730
	local -x CFLAGS="${CFLAGS} -fcommon"

	emake \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)"
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		install
}
