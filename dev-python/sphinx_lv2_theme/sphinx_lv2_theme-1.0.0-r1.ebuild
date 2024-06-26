# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Minimal pure-CSS Sphinx theme using the LV2 plugin documentation style"
HOMEPAGE="https://gitlab.com/lv2/sphinx_lv2_theme"
SRC_URI="https://gitlab.com/lv2/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86"

S="${WORKDIR}/${PN}-v${PV}"
