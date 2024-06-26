# Copyright 2003-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal systemd rhel8

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://sourceware.org/elfutils/"

LICENSE="|| ( GPL-2+ LGPL-3+ ) utils? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 lzma nls static-libs test +utils valgrind zstd"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[static-libs?,${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[static-libs?,${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[static-libs?,${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[static-libs?,${MULTILIB_USEDEP}] )
	elibc_musl? (
		dev-libs/libbsd
		sys-libs/argp-standalone
		sys-libs/fts-standalone
		sys-libs/obstack-standalone
	)
	!dev-libs/libelf"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"
BDEPEND=">=sys-devel/flex-2.5.4a
	sys-devel/m4
	nls? ( sys-devel/gettext )"
RESTRICT="!test? ( test )"

src_prepare() {
	default

	if use elibc_musl; then
		eapply "${WORKDIR}"/${PN}-0.187-patches/musl/
	fi

	if ! use static-libs; then
		sed -i -e '/^lib_LIBRARIES/s:=.*:=:' -e '/^%.os/s:%.o$::' lib{asm,dw,elf}/Makefile.in || die
	fi

	# https://sourceware.org/PR23914
	sed -i 's:-Werror::' */Makefile.in || die
}

src_configure() {
	# bug #407135
	use test && append-flags -g

	# Remove -Wall from default flags.  The makefiles enable enough warnings
	# themselves, and they use -Werror.  Appending -Wall defeats the cases where
	# the makefiles disable some specific warnings for specific code.
	# But add -Wformat explicitly for use with -Werror=format-security which
	# doesn't work without -Wformat (enabled by -Wall).
	replace-flags -Wall -Wformat

	# Symbol aliases are implemented as asm statements.
	# Will require porting: https://gcc.gnu.org/PR48200
	filter-flags '-flto*'

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--disable-debuginfod
		--disable-libdebuginfod

		# explicitly disable thread safety, it's not recommended by upstream
		# doesn't build either on musl.
		--disable-thread-safety

		# Valgrind option is just for running tests under it; dodgy under sandbox
		# and indeed even w/ glibc with newer instructions.
		--disable-valgrind
		--program-prefix="eu-"
		--with-zlib
		$(use_with bzip2 bzlib)
		$(use_with lzma)
		$(use_with zstd)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# Record some build root versions in build.log
	uname -r; rpm -q binutils gcc glibc || true

	env	LD_LIBRARY_PATH="${BUILD_DIR}/libelf:${BUILD_DIR}/libebl:${BUILD_DIR}/libdw:${BUILD_DIR}/libasm" \
		LC_ALL="C" \
		emake check VERBOSE=1
}

multilib_src_install_all() {
	einstalldocs
	dodoc NOTES
	# These build quick, and are needed for most tests, so don't
	# disable their building when the USE flag is disabled.
	if ! use utils; then
		rm -rf "${ED}"/usr/bin || die
	fi

	chmod +x "${ED}"/usr/lib64/lib*.so*

	systemd_dounit config/debuginfod.service

	insinto /etc/sysconfig
	newins config/debuginfod.sysconfig debuginfod

	dodir /var/cache/debuginfod
	touch "${ED}"/var/cache/debuginfod/debuginfod.sqlite
}
