# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools python-r1 rhel8-a

DESCRIPTION="Tiny library providing a C \"class\" for working with arbitrary big sizes in bytes"
HOMEPAGE="https://github.com/storaged-project/libbytesize"
#SRC_URI="https://github.com/storaged-project/libbytesize/releases/download/${PV}/${P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="doc python test"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:=
	dev-libs/libpcre2
	python? ( ${PYTHON_DEPS} )
"

DEPEND="
	${RDEPEND}
	sys-devel/gettext
	doc? ( dev-util/gtk-doc )
	test? (
		dev-python/pocketlint[${PYTHON_USEDEP}]
		dev-python/polib[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md )

RESTRICT="test"

python_do() {
	if use python; then
		python_foreach_impl run_in_build_dir "$@"
	else
		"$@"
	fi
}

src_prepare() {
	default
	eautoreconf -ivf
}

src_configure() {
	local myeconfargs=(
		$(use_with doc gtk-doc)
		$(use_with python python3)
	)
	local ECONF_SOURCE="${S}"
	python_do econf "${myeconfargs[@]}"
}

src_compile() {
	python_do emake
}

src_test() {
	python_do emake check
}

install_helper() {
	emake DESTDIR="${D}" install
	use python && python_optimize
}

src_install() {
	python_do install_helper
	einstalldocs
	find "${ED}" -name "*.la" -type f -delete || die
}
