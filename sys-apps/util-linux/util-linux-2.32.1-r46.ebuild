# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,8,9} )

suffix_ver=$(ver_cut 5)
[[ ${suffix_ver} ]] && DSUFFIX="_10.${suffix_ver}"

inherit toolchain-funcs libtool flag-o-matic bash-completion-r1 usr-ldscript \
	pam python-r1 multilib-minimal multiprocessing systemd rhel8

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/ https://github.com/karelzak/util-linux"

LICENSE="GPL-2 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="build caps cramfs fdformat +kill ncurses nls pam +python readline +selinux slang static-libs +suid systemd test tty-helpers +udev unicode userland_GNU"

# Most lib deps here are related to programs rather than our libs,
# so we rarely need to specify ${MULTILIB_USEDEP}.
RDEPEND="caps? ( sys-libs/libcap-ng )
	cramfs? ( sys-libs/zlib:= )
	ncurses? ( >=sys-libs/ncurses-5.2-r2:0=[unicode?] )
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	selinux? ( >=sys-libs/libselinux-2.2.2-r4[${MULTILIB_USEDEP}] )
	slang? ( sys-libs/slang )
	!build? ( systemd? ( sys-apps/systemd ) )
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( sys-devel/bc )
	virtual/os-headers
	sys-libs/libutempter"
RDEPEND+="
	kill? (
		!sys-apps/coreutils[kill]
		!sys-process/procps[kill]
	)
	!net-wireless/rfkill
	!<app-shells/bash-completion-2.7-r1"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

src_prepare() {
	default

	if ! use userland_GNU; then
		# test runner is using GNU-specific xargs call
		sed -i -e 's:xargs:gxargs:' tests/run.sh || die
		# test requires util-linux uuidgen (which we don't build)
		rm tests/ts/uuid/oids || die
	fi

	if [[ ${PV} == 9999 ]] ; then
		po/update-potfiles
		eautoreconf
	fi

	elibtoolize
}

lfs_fallocate_test() {
	# Make sure we can use fallocate with LFS #300307
	cat <<-EOF > "${T}"/fallocate.${ABI}.c
		#define _GNU_SOURCE
		#include <fcntl.h>
		main() { return fallocate(0, 0, 0, 0); }
	EOF
	append-lfs-flags
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${T}"/fallocate.${ABI}.c -o /dev/null >/dev/null 2>&1 \
		|| export ac_cv_func_fallocate=no
	rm -f "${T}"/fallocate.${ABI}.c
}

python_configure() {
	local myeconfargs=(
		--disable-all-programs
		--disable-bash-completion
		--without-systemdsystemunitdir
		--with-python
	)
	if use userland_GNU; then
		myeconfargs+=(
			--enable-libblkid
			--enable-libmount
			--enable-pylibmount
		)
	fi
	mkdir "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
	popd >/dev/null || die
}

multilib_src_configure() {
	unset LINGUAS || :

	# unfortunately, we did changes to build-system
	./autogen.sh

	# if we modify .po files by RHEL patches
	rm -f po/stamp*

	append-cflags -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
	export SUID_CFLAGS="-fpie"
	export SUID_LDFLAGS="-pie -Wl,-z,relro -Wl,-z,now"
	export DAEMON_CFLAGS="$SUID_CFLAGS"
	export DAEMON_LDFLAGS="$SUID_LDFLAGS"

	lfs_fallocate_test
	# The scanf test in a run-time test which fails while cross-compiling.
	# Blindly assume a POSIX setup since we require libmount, and libmount
	# itself fails when the scanf test fails. #531856
	tc-is-cross-compiler && export scanf_cv_alloc_modifier=ms
	export ac_cv_header_security_pam_misc_h=$(multilib_native_usex pam) #485486
	export ac_cv_header_security_pam_appl_h=$(multilib_native_usex pam) #545042

	# Undo bad ncurses handling by upstream. Fall back to pkg-config. #601530
	export NCURSES6_CONFIG=false NCURSES5_CONFIG=false
	export NCURSESW6_CONFIG=false NCURSESW5_CONFIG=false

	local myeconfargs=(
		--disable-assert
		--disable-bfs
		--disable-pg
		--with-audit
		--with-utempter
		--enable-write
		--enable-usrdir-path
		--enable-fs-paths-extra="${EPREFIX}/usr/sbin:${EPREFIX}/bin:${EPREFIX}/usr/bin"
		--with-bashcompletiondir="$(get_bashcompdir)"
		--without-python
		$(multilib_native_use_enable suid makeinstall-chown)
		$(multilib_native_use_enable suid makeinstall-setuid)
		$(multilib_native_use_with readline)
		$(multilib_native_use_with slang)
		$(multilib_native_use_with systemd)
		$(multilib_native_use_with udev)
		$(multilib_native_usex ncurses "$(use_with unicode ncursesw)" '--without-ncursesw')
		$(multilib_native_usex ncurses "$(use_with !unicode ncurses)" '--without-ncurses')
		$(tc-has-tls || echo --disable-tls)
		$(use_enable nls)
		$(use_enable unicode widechar)
		$(use_enable static-libs static)
		$(use_with selinux)
		$(use_with ncurses tinfo)
	)
	# build programs only on GNU, on *BSD we want libraries only
	if multilib_is_native_abi && use userland_GNU; then
		myeconfargs+=(
			--enable-chfn-chsh
			--disable-login
			--disable-nologin
			--disable-pylibmount
			--disable-su
			--enable-agetty
			--enable-bash-completion
			--enable-line
			--enable-partx
			--enable-raw
			--enable-rename
			--enable-rfkill
			--enable-schedutils
			--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
			$(use_enable caps setpriv)
			$(use_enable cramfs)
			$(use_enable fdformat)
			$(use_enable tty-helpers mesg)
			$(use_enable tty-helpers wall)
			$(use_enable tty-helpers write)
			$(use_enable kill)
		)
	else
		myeconfargs+=(
			--disable-all-programs
			--disable-bash-completion
			--without-systemdsystemunitdir
			# build libraries
			--enable-libuuid
			--enable-libblkid
			--enable-libsmartcols
			--enable-libfdisk
		)
		if use userland_GNU; then
			# those libraries don't work on *BSD
			myeconfargs+=(
				--enable-libmount
			)
		fi
	fi
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if multilib_is_native_abi && use python; then
		python_foreach_impl python_configure
	fi
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake all
	popd >/dev/null || die
}

multilib_src_compile() {
	emake all

	if multilib_is_native_abi && use python; then
		python_foreach_impl python_compile
	fi
}

python_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake check TS_OPTS="--parallel=$(makeopts_jobs) --nonroot"
	popd >/dev/null || die
}

multilib_src_test() {
	emake check TS_OPTS="--parallel=$(makeopts_jobs) --nonroot"
	if multilib_is_native_abi && use python; then
		python_foreach_impl python_test
	fi
}

python_install() {
	pushd "${BUILD_DIR}" >/dev/null || die
	emake DESTDIR="${D}" install
	python_optimize
	popd >/dev/null || die
}

multilib_src_install() {
	if multilib_is_native_abi && use python; then
		python_foreach_impl python_install
	fi

	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use userland_GNU; then
		# need the libs in /
		gen_usr_ldscript -a blkid fdisk mount smartcols uuid
	fi
}

multilib_src_install_all() {
	dodoc AUTHORS NEWS README* Documentation/{TODO,*.txt,releases/*}

	# e2fsprogs-libs didnt install .la files, and .pc work fine
	find "${ED}" -name "*.la" -delete || die

	if ! use userland_GNU; then
		# manpage collisions
		# TODO: figure out a good way to keep them
		rm "${ED%/}"/usr/share/man/man3/uuid* || die
	fi

	if use pam; then
		newpamd "${FILESDIR}/runuser.pamd" runuser
		newpamd "${FILESDIR}/runuser-l.pamd" runuser-l
	fi

	# Note:
	# Bash completion for "runuser" command is provided by same file which
	# would also provide bash completion for "su" command. However, we don't
	# use "su" command from this package.
	# This triggers a known QA warning which we ignore for now to magically
	# keep bash completion for "su" command which shadow package does not
	# provide.
}

pkg_postinst() {
	if ! use tty-helpers; then
		elog "The mesg/wall/write tools have been disabled due to USE=-tty-helpers."
	fi

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The agetty util now clears the terminal by default. You"
		elog "might want to add --noclear to your /etc/inittab lines."
	fi
}
