# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Modern API for working with files and directories in Emacs"
HOMEPAGE="https://github.com/rejeep/f.el/"
SRC_URI="https://github.com/rejeep/f.el/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/f.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ppc64 ~riscv ~sparc x86"
RESTRICT="test"

RDEPEND="
	app-emacs/dash
	app-emacs/s
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
