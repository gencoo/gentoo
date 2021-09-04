# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

DESCRIPTION="DKIM and ARC email signing and verification library"
HOMEPAGE="https://launchpad.net/dkimpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="dev-python/dnspython[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/authres[${PYTHON_USEDEP}]
		dev-python/pynacl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "ARC support" dev-python/authres
	optfeature "ed25519 capability" dev-python/pynacl
	optfeature "asyncio support" dev-python/aiodns
}
