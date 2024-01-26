# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=13
PYTHON_COMPAT=( python3_{9..11} )

# Auto-Generated by cargo-ebuild 0.5.4
CRATES="
	adler-1.0.2
	aho-corasick-0.7.20
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.21.0
	bindgen-0.59.2
	bit_field-0.10.2
	bitflags-1.3.2
	block-buffer-0.10.4
	bumpalo-3.12.0
	bytemuck-1.13.1
	byteorder-1.4.3
	cbindgen-0.24.3
	cc-1.0.79
	cexpr-0.6.0
	cfg-if-1.0.0
	clang-sys-1.6.1
	clap-2.34.0
	clap-3.2.23
	clap_lex-0.2.4
	color_quant-1.1.0
	cpufeatures-0.2.6
	crc32fast-1.3.2
	crossbeam-channel-0.5.8
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.14
	crossbeam-utils-0.8.15
	crunchy-0.2.2
	crypto-common-0.1.6
	digest-0.10.6
	either-1.8.1
	env_logger-0.9.3
	errno-0.3.1
	errno-dragonfly-0.1.2
	exr-1.6.3
	fastrand-1.9.0
	fdeflate-0.3.0
	flate2-1.0.25
	flume-0.10.14
	futures-core-0.3.28
	futures-sink-0.3.28
	generic-array-0.14.7
	getrandom-0.2.9
	gif-0.12.0
	glob-0.3.1
	half-2.2.1
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hex-0.4.3
	humantime-2.1.0
	image-0.24.6
	indexmap-1.9.3
	instant-0.1.12
	io-lifetimes-1.0.10
	itoa-1.0.6
	jpeg-decoder-0.3.0
	js-sys-0.3.61
	lazy_static-1.4.0
	lazycell-1.3.0
	lebe-0.5.2
	libc-0.2.141
	libloading-0.7.4
	linux-raw-sys-0.3.1
	lock_api-0.4.9
	log-0.4.17
	memchr-2.5.0
	memoffset-0.8.0
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	miniz_oxide-0.7.1
	nanorand-0.7.0
	nom-7.1.3
	num-complex-0.4.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.15.0
	once_cell-1.17.1
	os_str_bytes-6.5.0
	peeking_take_while-0.1.2
	pin-project-1.0.12
	pin-project-internal-1.0.12
	png-0.17.8
	primal-check-0.3.3
	proc-macro2-1.0.56
	qoi-0.4.1
	quote-1.0.26
	rayon-1.7.0
	rayon-core-1.11.0
	redox_syscall-0.3.5
	regex-1.7.3
	regex-syntax-0.6.29
	rustc-hash-1.1.0
	rustdct-0.7.1
	rustfft-6.1.0
	rustix-0.37.11
	ryu-1.0.13
	scopeguard-1.1.0
	serde-1.0.160
	serde_derive-1.0.160
	serde_json-1.0.96
	sha1-0.10.5
	sha2-0.10.6
	shlex-1.1.0
	simd-adler32-0.3.5
	smallvec-1.10.0
	spin-0.9.8
	strength_reduce-0.2.4
	strsim-0.8.0
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.15
	tempfile-3.5.0
	termcolor-1.2.0
	textwrap-0.11.0
	textwrap-0.16.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	tiff-0.8.1
	toml-0.5.11
	transpose-0.2.2
	typenum-1.16.0
	unicode-ident-1.0.8
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	vec_map-0.8.2
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	weezl-0.1.7
	which-4.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	zune-inflate-0.2.53"

inherit cargo cmake flag-o-matic llvm python-any-r1 systemd tmpfiles

MY_P=${P//_/-}

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="https://www.clamav.net/"
SRC_URI="https://github.com/Cisco-Talos/clamav/archive/refs/tags/${MY_P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
S=${WORKDIR}/clamav-${MY_P}

LICENSE="Apache-2.0 BSD GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
# 0/sts (short term support) if not an LTS release
SLOT="0/sts"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 ~arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi
IUSE="doc clamonacc +clamapp experimental jit libclamav-only milter rar selinux systemd test"

REQUIRED_USE="libclamav-only? ( !clamonacc !clamapp !milter )
	clamonacc? ( clamapp )
	milter? ( clamapp )
	test? ( !libclamav-only )"

RESTRICT="!test? ( test )"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/clamav in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
CDEPEND="
	acct-group/clamav
	acct-user/clamav
	app-arch/bzip2
	dev-libs/json-c:=
	dev-libs/libltdl
	dev-libs/libmspack
	dev-libs/libpcre2:=
	dev-libs/libxml2
	dev-libs/openssl:=
	>=sys-libs/zlib-1.2.2:=
	virtual/libiconv
	!libclamav-only? ( net-misc/curl )
	clamapp? ( sys-libs/ncurses:= net-misc/curl )
	elibc_musl? ( sys-libs/fts-standalone )
	jit? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
	milter? ( mail-filter/libmilter:= )
	rar? ( app-arch/unrar )
	test? ( dev-python/pytest )
"

BDEPEND="
	virtual/pkgconfig
	>=virtual/rust-1.61
	doc? ( app-text/doxygen )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)
"

DEPEND="${CDEPEND}
	test? ( dev-libs/check )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use jit && llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

#PATCHES=(
#)

src_configure() {
	use elibc_musl && append-ldflags -lfts
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DAPP_CONFIG_DIRECTORY="${EPREFIX}"/etc/clamav
		-DBYTECODE_RUNTIME=$(usex jit llvm interpreter)
		-DCLAMAV_GROUP="clamav"
		-DCLAMAV_USER="clamav"
		-DDATABASE_DIRECTORY="${EPREFIX}"/var/lib/clamav
		-DENABLE_APP=$(usex clamapp ON OFF)
		-DENABLE_CLAMONACC=$(usex clamonacc ON OFF)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_EXPERIMENTAL=$(usex experimental ON OFF)
		-DENABLE_EXTERNAL_MSPACK=ON
		-DENABLE_JSON_SHARED=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MILTER=$(usex milter ON OFF)
		-DENABLE_SHARED_LIB=ON
		-DENABLE_STATIC_LIB=OFF
		-DENABLE_SYSTEMD=$(usex systemd ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_UNRAR=$(usex rar ON OFF)
		-DOPTIMIZE=ON
	)

	if use test ; then
		# https://bugs.gentoo.org/818673
		# Used to enable some more tests but doesn't behave well in
		# sandbox necessarily(?) + needs certain debug symbols present
		# in e.g. glibc.
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Valgrind=ON
			-DPYTHON_FIND_VERSION="${EPYTHON#python}"
		)
	fi

	if use jit ; then
		# Suppress CMake warnings that variables aren't consumed if we aren't using LLVM
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#llvm-optional-see-bytecode-runtime-section
		# https://github.com/Cisco-Talos/clamav/blob/main/INSTALL.md#bytecode-runtime
		mycmakeargs+=(
			-DLLVM_ROOT_DIR="$(get_llvm_prefix -d ${LLVM_MAX_SLOT})"
			-DLLVM_FIND_VERSION="$(best_version sys-devel/llvm:${LLVM_MAX_SLOT} | cut -c 16-)"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# init scripts
	newinitd "${FILESDIR}/clamd.initd" clamd
	newinitd "${FILESDIR}/freshclam.initd" freshclam
	use clamonacc && \
		newinitd "${FILESDIR}/clamonacc.initd" clamonacc
	use milter && \
		newinitd "${FILESDIR}/clamav-milter.initd" clamav-milter

	rm -rf "${ED}"/var/lib/clamav || die

	if ! use libclamav-only ; then
		if use systemd ; then
			# The tmpfiles entry is behind USE=systemd because the
			# upstream OpenRC service files should (and do) ensure that
			# the directories they need exist and have the correct
			# permissions without the help of opentmpfiles. There are
			# years-old root exploits in opentmpfiles, the design is
			# fundamentally flawed, and the maintainer is not up to
			# the task of fixing it.
			dotmpfiles "${FILESDIR}/tmpfiles.d/clamav.conf"
			systemd_newunit "${FILESDIR}/clamd_at.service-0.104.0" "clamd@.service"
			systemd_dounit "${FILESDIR}/clamd.service"
			systemd_newunit "${FILESDIR}/freshclamd.service-r1" \
							"freshclamd.service"
		fi

		if use clamapp ; then
			# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
			sed -e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(LocalSocket .*\)/\1/" \
				-e "s/^#\(User .*\)/\1/" \
				-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamd.log:" \
				-e "s:^\#\(LogTime\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/clamd.conf.sample > \
				"${ED}"/etc/clamav/clamd.conf || die

			sed -e "s:^\(Example\):\# \1:" \
				-e "s/^#\(PidFile .*\)/\1/" \
				-e "s/^#\(DatabaseOwner .*\)/\1/" \
				-e "s:^\#\(UpdateLogFile\) .*:\1 ${EPREFIX}/var/log/clamav/freshclam.log:" \
				-e "s:^\#\(NotifyClamd\).*:\1 ${EPREFIX}/etc/clamav/clamd.conf:" \
				-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
				-e "s/^#\(DatabaseDirectory .*\)/\1/" \
				"${ED}"/etc/clamav/freshclam.conf.sample > \
				"${ED}"/etc/clamav/freshclam.conf || die

			if use milter ; then
				# Note: only keep the "unix" ClamdSocket and MilterSocket!
				sed -e "s:^\(Example\):\# \1:" \
					-e "s/^#\(PidFile .*\)/\1/" \
					-e "s/^#\(ClamdSocket unix:.*\)/\1/" \
					-e "s/^#\(User .*\)/\1/" \
					-e "s/^#\(MilterSocket unix:.*\)/\1/" \
					-e "s:^\#\(LogFile\) .*:\1 ${EPREFIX}/var/log/clamav/clamav-milter.log:" \
					"${ED}"/etc/clamav/clamav-milter.conf.sample > \
					"${ED}"/etc/clamav/clamav-milter.conf || die

				systemd_newunit "${FILESDIR}/clamav-milter.service-0.104.0" clamav-milter.service
			fi

			local i
			for i in clamd freshclam clamav-milter
			do
				if [[ -f "${ED}"/etc/"${i}".conf.sample ]] ; then
					mv "${ED}"/etc/"${i}".conf{.sample,} || die
				fi
			done

			# These both need to be writable by the clamav user.
			# TODO: use syslog by default; that's what it's for.
			diropts -o clamav -g clamav
			keepdir /var/lib/clamav
			keepdir /var/log/clamav
		fi
	fi

	if use doc ; then
		local HTML_DOCS=( docs/html/. )
		einstalldocs
	fi

	# Don't install man pages for utilities we didn't install
	if use libclamav-only ; then
		rm -r "${ED}"/usr/share/man || die
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use libclamav-only ; then
		if use systemd ; then
			tmpfiles_process clamav.conf
		fi
	fi

	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi

	local databases=( "${EROOT}"/var/lib/clamav/main.c[lv]d )
	if [[ ! -f "${databases}" ]] ; then
		ewarn "You must run freshclam manually to populate the virus database"
		ewarn "before starting clamav for the first time."
	fi

	 if ! systemd_is_booted ; then
		ewarn "This version of ClamAV provides separate OpenRC services"
		ewarn "for clamd, freshclam, clamav-milter, and clamonacc. The"
		ewarn "clamd service now starts only the clamd daemon itself. You"
		ewarn "should add freshclam (and perhaps clamav-milter) to any"
		ewarn "runlevels that previously contained clamd."
	fi
}
