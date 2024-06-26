# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1 rhel9-a

DESCRIPTION="Identify specific nodes in a JSON document (according to draft 08)"
HOMEPAGE="https://github.com/stefankoegl/python-json-pointer https://pypi.org/project/jsonpointer/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

python_test() {
	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
