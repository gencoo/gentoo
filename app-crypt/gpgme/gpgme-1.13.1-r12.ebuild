# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,8,9} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 flag-o-matic libtool qmake-utils toolchain-funcs rhel8

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/related_software/gpgme"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1/11" # subslot = soname major version
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE="common-lisp static-libs +cxx python qt5"

COMMON_DEPEND=">=app-crypt/gnupg-2
	app-admin/chrpath
	>=dev-libs/libassuan-2.5.1:=
	>=dev-libs/libgpg-error-1.29:=
	python? ( ${PYTHON_DEPS} )
	qt5? ( dev-qt/qtcore:5 )"
	#doc? ( app-doc/doxygen[dot] )
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/qttest:5 )"
RDEPEND="${COMMON_DEPEND}
	cxx? (
		!<kde-apps/gpgmepp-4.14.11_pre20160611:4
		!kde-apps/gpgmepp:5
		!<kde-apps/kdepimlibs-4.14.10_p20160611:4
		!=kde-apps/kdepimlibs-4.14.11_pre20160211*:4
	)"
BDEPEND="python? ( dev-lang/swig )"

REQUIRED_USE="qt5? ( cxx ) python? ( ${PYTHON_REQUIRED_USE} )"

do_python() {
	if use python; then
		pushd "lang/python" > /dev/null || die
		top_builddir="../.." srcdir="." CPP=$(tc-getCPP) distutils-r1_src_${EBUILD_PHASE}
		popd > /dev/null
	fi
}

pkg_setup() {
	addpredict /run/user/$(id -u)/gnupg

	local MAX_WORKDIR=66
	if [[ "${#WORKDIR}" -gt "${MAX_WORKDIR}" ]]; then
		ewarn "Disabling tests as WORKDIR '${WORKDIR}' is longer than ${MAX_WORKDIR} which will fail tests"
		SKIP_TESTS=1
	fi
}

src_prepare() {
	default
	elibtoolize
	# Make best effort to allow longer PORTAGE_TMPDIR
	# as usock limitation fails build/tests
	ln -s "${P}" "${WORKDIR}/b"
	S="${WORKDIR}/b"
}

src_configure() {
	local languages=()
	use common-lisp && languages+=( "cl" )
	use cxx && languages+=( "cpp" )
	if use qt5; then
		languages+=( "qt" )
		#use doc ||
		export DOXYGEN=true
		export MOC="$(qt5_get_bindir)/moc"
	fi

	econf \
		$([[ -n "${SKIP_TESTS}" ]] && echo "--disable-gpg-test --disable-gpgsm-test") \
		--disable-silent-rules \
		--enable-languages="${languages[*]}" \
		$(use_enable static-libs static)

	use python && make -C lang/python prepare

	do_python
}

src_compile() {
	default
	do_python
}

src_test() {
	[[ -z "${SKIP_TESTS}" ]] || return

	default
	if use python; then
		test_python() {
			emake -C lang/python/tests check \
				PYTHON=${EPYTHON} \
				PYTHONS=${EPYTHON} \
				TESTFLAGS="--python-libdir=${BUILD_DIR}/lib"
		}
		python_foreach_impl test_python
	fi
}

src_install() {
	default
	do_python

	# unpackaged files
	rm -fv ${ED}${_infodir}/dir

	find "${ED}" -type f -name '*.la' -delete || die

	# backward compatibility for gentoo
	# in the past we had slots
	dodir /usr/include/gpgme
	dosym ../gpgme.h /usr/include/gpgme/gpgme.h

	chrpath -d ${D}/usr/bin/gpgme-tool
	chrpath -d ${D}/usr/lib64/libgpgmepp.so*
	chrpath -d ${D}/usr/lib64/libqgpgme.so*
}
