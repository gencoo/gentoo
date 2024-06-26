# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1 rhel9-a

DESCRIPTION="Persistent/Functional/Immutable data structures"
HOMEPAGE="https://github.com/tobgu/pyrsistent/ https://pypi.org/project/pyrsistent/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
