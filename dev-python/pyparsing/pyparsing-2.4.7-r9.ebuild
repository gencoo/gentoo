# Copyright 2004-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..10} pypy3 )

inherit distutils-r1 rhel9

MY_P=${P/-/_}
DESCRIPTION="Easy-to-use Python module for text parsing"
HOMEPAGE="https://github.com/pyparsing/pyparsing https://pypi.org/project/pyparsing/"
S=${WORKDIR}/${PN}-${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
