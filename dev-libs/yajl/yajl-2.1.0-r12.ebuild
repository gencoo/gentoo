# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib rhel8-a

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.com/yajl/"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_test() {
	cd "${S}"/test/parsing || die
	./run_tests.sh "${BUILD_DIR}"/test/parsing/yajl_test || die
}

src_install() {
	cmake-multilib_src_install
	find "${D}" -name libyajl_s.a -delete || die
}
