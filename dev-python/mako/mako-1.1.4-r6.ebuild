# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..10} )
inherit distutils-r1 optfeature rhel9-a

MY_P=${P^}
DESCRIPTION="A Python templating language"
HOMEPAGE="https://www.makotemplates.org/ https://pypi.org/project/Mako/"
S="${WORKDIR}/${PN}-rel_${PV//./_}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

RDEPEND=">=dev-python/markupsafe-0.9.2[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/mako-1.1.1-pypy3-test.patch
)

distutils_enable_tests pytest

python_install_all() {
	rm -r doc/build || die

	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "caching support" dev-python/beaker
}
