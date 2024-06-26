# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..10} pypy3 )

inherit distutils-r1 rhel9

DESCRIPTION="SOCKS client module"
HOMEPAGE="https://github.com/Anorov/PySocks https://pypi.org/project/PySocks/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

#BDEPEND="
#	test? (
#		net-proxy/3proxy
#		$(python_gen_cond_dep 'dev-python/test_server[${PYTHON_USEDEP}]' -3)
#	)"

#distutils_enable_tests pytest

# tests fail semi-randomly; probably starting proxy server doesn't work
# as expected
RESTRICT="test"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/PySocks-1.7.1-test_server.patch
	)

#	if use test; then
#		ln -s "${BROOT}/usr/bin/3proxy" test/bin/3proxy || die
#	fi

	# requires Internet
	sed -i -e 's:test_socks5_proxy_connect_timeout:_&:' \
		test/test_pysocks.py || die

	distutils-r1_src_prepare
}

python_test() {
	python_is_python3 || return
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
