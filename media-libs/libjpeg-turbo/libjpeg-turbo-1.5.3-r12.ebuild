# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools java-pkg-opt-2 toolchain-funcs multilib-minimal rhel8-a

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="${SRC_URI}
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"
LICENSE="BSD IJG ZLIB"
SLOT="0/0.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

BDEPEND="amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.5 )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.5 )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-x32.patch #420239
)

src_prepare() {
	default

	eautoreconf -vif

	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	export NAFLAGS="-g -Fdwarf"
	export CCASFLAGS="-Wa,--generate-missing-build-notes=yes"

	local myconf=()
	if multilib_is_native_abi; then
		myconf+=( $(use_with java) )
		if use java; then
			export JAVACFLAGS="$(java-pkg_javac-args)"
			export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
		fi
	else
		myconf+=( --without-java )
	fi
	[[ ${ABI} == "x32" ]] && myconf+=( --without-simd ) #420239

	# Force /bin/bash until upstream generates a new version. #533902
	CONFIG_SHELL="${EPREFIX}"/bin/bash \
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--with-mem-srcdst \
		"${myconf[@]}"
}

multilib_src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1"
	emake ${_java_makeopts}

	if multilib_is_native_abi; then
		pushd ../debian/extra >/dev/null
		emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
		popd >/dev/null
	fi
}

multilib_src_test() {
	emake test
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		exampledir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if multilib_is_native_abi; then
		pushd "${WORKDIR}"/debian/extra >/dev/null
		emake \
			DESTDIR="${D}" prefix="${EPREFIX}"/usr \
			INSTALL="install -m755" INSTALLDIR="install -d -m755" \
			install
		popd >/dev/null

		if use java; then
			rm -rf "${ED}"/usr/classes
			java-pkg_dojar java/turbojpeg.jar
		fi
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	docinto html
	dodoc -r "${S}"/doc/html/*
	newdoc "${WORKDIR}"/debian/changelog changelog.debian
	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/*
		newdoc "${S}"/java/README README.java
	fi
}
