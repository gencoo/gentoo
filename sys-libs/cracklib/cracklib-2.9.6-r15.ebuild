# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Note: ideally bump with sys-apps/cracklib-words

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 libtool multilib-minimal usr-ldscript rhel8

MY_P=${P/_}
DESCRIPTION="Password Checking Library"
HOMEPAGE="https://github.com/cracklib/cracklib/"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls python static-libs zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	nls? ( virtual/libintl )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"
BDEPEND="nls? ( sys-devel/gettext )"

do_python() {
	multilib_is_native_abi || return 0
	use python || return 0
	pushd python > /dev/null || die
	distutils-r1_src_${EBUILD_PHASE}
	popd > /dev/null
}

pkg_setup() {
	# workaround #195017
	if has unmerge-orphans ${FEATURES} && has_version "<${CATEGORY}/${PN}-2.8.10" ; then
		eerror "Upgrade path is broken with FEATURES=unmerge-orphans"
		eerror "Please run: FEATURES=-unmerge-orphans emerge cracklib"
		die "Please run: FEATURES=-unmerge-orphans emerge cracklib"
	fi
}

src_prepare() {
	# Use the dictionary from the build to test
	sed -i 's,util/cracklib-check <,util/cracklib-check $(DESTDIR)/$(DEFAULT_CRACKLIB_DICT) <,' Makefile.in

	eapply_user
	elibtoolize #269003
	do_python
}

multilib_src_configure() {
	local myeconfargs=(
		# use /usr/lib so that the dictionary is shared between ABIs
		--with-pic
		--with-default-dict='/usr/lib/cracklib_dict'
		--without-python
		$(use_enable nls)
		$(use_enable static-libs static)
	)
	export ac_cv_header_zlib_h=$(usex zlib)
	export ac_cv_search_gzopen=$(usex zlib -lz no)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default
	do_python
}

multilib_src_test() {
	# Make sure we load the freshly built library
	LD_LIBRARY_PATH="${BUILD_DIR}/lib/.libs" do_python
}

python_test() {
	${EPYTHON} -m unittest test_cracklib || die "Tests fail with ${EPYTHON}"
}

multilib_src_install() {
	default
	# move shared libs to /
	gen_usr_ldscript -a crack

	do_python
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
	rm -r "${ED}"/usr/share/cracklib || die

	insinto /usr/share/dict
	doins dicts/cracklib-small
}

pkg_postinst() {
	if [[ -z ${ROOT} ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict "${EPREFIX}"/usr/share/dict/* > /dev/null
		eend $?
	fi
}
