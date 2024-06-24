# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.6.2

EAPI=8

CRATES="
	addr2line@0.22.0
	adler@1.0.2
	aead@0.5.2
	aes-gcm@0.10.3
	aes@0.8.4
	ahash@0.8.11
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anyhow@1.0.86
	ascii-canvas@3.0.0
	async-trait@0.1.80
	autocfg@1.3.0
	backtrace@0.3.73
	base64@0.21.7
	base64@0.22.1
	base64ct@1.6.0
	bindgen@0.68.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	block-padding@0.3.3
	botan-sys@0.10.5
	botan@0.10.7
	buffered-reader@1.3.1
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.6.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	capnp-futures@0.19.0
	capnp-rpc@0.19.2
	capnp@0.19.6
	cc@1.0.99
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.38
	cipher@0.4.4
	clang-sys@1.8.1
	cmac@0.7.2
	const-oid@0.9.6
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	cpufeatures@0.2.12
	crc32fast@1.4.2
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.20
	crossbeam@0.8.4
	crunchy@0.2.2
	crypto-common@0.1.6
	ctor@0.2.8
	ctr@0.9.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.2
	daemonize@0.5.0
	darling@0.20.9
	darling_core@0.20.9
	darling_macro@0.20.9
	data-encoding@2.6.0
	dbl@0.3.2
	der@0.7.9
	deranged@0.3.11
	diff@0.1.13
	digest@0.10.7
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.4
	doc-comment@0.3.3
	dyn-clone@1.0.17
	eax@0.5.0
	ed25519-dalek@2.1.1
	ed25519@2.2.3
	editdistancek@1.0.2
	either@1.12.0
	embedded-io@0.6.1
	ena@0.14.3
	encoding_rs@0.8.34
	endian-type@0.1.2
	enum-as-inner@0.6.0
	enumber@0.3.1
	equivalent@1.0.1
	errno@0.3.9
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.1.0
	fd-lock@4.0.2
	fiat-crypto@0.2.9
	filetime@0.2.23
	fixedbitset@0.4.2
	flate2@1.0.30
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fs2@0.4.3
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	futures@0.3.30
	generic-array@0.14.7
	generic-array@1.0.0
	gethostname@0.4.3
	getrandom@0.2.15
	ghash@0.5.1
	gimli@0.29.0
	glob@0.3.1
	h2@0.3.26
	hashbrown@0.12.3
	hashbrown@0.14.5
	hashlink@0.9.1
	heck@0.4.1
	hermit-abi@0.3.9
	hex@0.4.3
	hickory-client@0.24.1
	hickory-proto@0.24.1
	hickory-resolver@0.24.1
	histo@1.0.0
	hostname@0.3.1
	http-body@0.4.6
	http@0.2.12
	httparse@1.9.3
	httpdate@1.0.3
	hyper-tls@0.5.0
	hyper@0.14.29
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.0
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	ident_case@1.0.1
	idna@0.4.0
	idna@0.5.0
	idna@1.0.0
	indexmap@1.9.3
	indexmap@2.2.6
	inout@0.1.3
	interprocess@1.2.1
	ipconfig@0.3.2
	ipnet@2.9.0
	itertools@0.11.0
	itoa@1.0.11
	js-sys@0.3.69
	lalrpop-util@0.20.2
	lalrpop@0.20.2
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.155
	libloading@0.8.3
	libm@0.2.8
	libredox@0.1.3
	libsqlite3-sys@0.28.0
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.14
	litemap@0.7.3
	lock_api@0.4.12
	log@0.4.21
	lru-cache@0.1.2
	match_cfg@0.1.0
	md-5@0.10.6
	memchr@2.7.4
	memsec@0.6.3
	memsec@0.7.0
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.3
	mio@0.8.11
	native-tls@0.2.12
	nettle-sys@2.3.0
	nettle@7.4.0
	new_debug_unreachable@1.0.6
	nibble_vec@0.1.0
	nom@7.1.3
	ntest@0.9.2
	ntest_test_cases@0.9.2
	ntest_timeout@0.9.2
	num-bigint-dig@0.8.4
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.45
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.36.0
	once_cell@1.19.0
	opaque-debug@0.3.1
	openpgp-cert-d@0.3.2
	openssh-keys@0.6.2
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.102
	openssl@0.10.64
	option-ext@0.2.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	peeking_take_while@0.1.2
	percent-encoding@2.3.1
	petgraph@0.6.5
	phf_shared@0.10.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkcs8@0.10.2
	pkg-config@0.3.30
	platforms@3.4.0
	polyval@0.6.2
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	proc-macro-crate@3.1.0
	proc-macro2@1.0.85
	quick-error@1.2.3
	quote@1.0.36
	radix_trie@0.2.1
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.4.1
	redox_syscall@0.5.2
	redox_users@0.4.5
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.5
	reqwest@0.11.27
	resolv-conf@0.7.0
	rpassword@7.3.1
	rtoolbox@0.0.2
	rusqlite@0.31.0
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustc_version@0.4.0
	rustix@0.38.34
	rustls-pemfile@1.0.4
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	schannel@0.1.23
	scopeguard@1.2.0
	security-framework-sys@2.11.0
	security-framework@2.11.0
	semver@1.0.23
	sequoia-cert-store@0.6.0
	sequoia-gpg-agent@0.4.1
	sequoia-ipc@0.35.0
	sequoia-net@0.28.0
	sequoia-openpgp@1.20.0
	sequoia-policy-config@0.6.0
	sequoia-wot@0.12.0
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.117
	serde_urlencoded@0.7.1
	serde_with@3.8.1
	serde_with_macros@3.8.1
	sha1collisiondetection@0.3.4
	sha2@0.10.8
	shellexpand@3.1.0
	shlex@1.3.0
	signal-hook-registry@1.4.2
	signature@2.2.0
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	spin@0.5.2
	spki@0.7.3
	stable_deref_trait@1.2.0
	stfu8@0.2.7
	streaming-stats@0.1.29
	string_cache@0.8.7
	strsim@0.11.1
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.66
	sync_wrapper@0.1.2
	synstructure@0.13.1
	system-configuration-sys@0.5.0
	system-configuration@0.5.1
	tar@0.4.41
	tempfile@3.10.1
	term@0.7.0
	thiserror-impl@1.0.61
	thiserror@1.0.61
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tiny-keccak@2.0.2
	tinystr@0.7.6
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	to_method@1.1.0
	tokio-macros@2.3.0
	tokio-native-tls@0.3.1
	tokio-socks@0.5.1
	tokio-util@0.7.11
	tokio@1.38.0
	toml@0.5.11
	toml_datetime@0.6.6
	toml_edit@0.21.1
	tower-service@0.3.2
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	try-lock@0.2.5
	typenum@1.17.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-xid@0.2.4
	universal-hash@0.5.1
	url@2.5.1
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	vcpkg@0.2.15
	version_check@0.9.4
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	widestring@1.1.0
	win-crypto-ng@0.5.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	winnow@0.5.40
	winreg@0.50.0
	write16@1.0.0
	writeable@0.5.5
	xxhash-rust@0.8.10
	yoke-derive@0.7.4
	yoke@0.7.4
	z-base-32@0.1.4
	zbase32@0.1.2
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
	zerofrom-derive@0.1.4
	zerofrom@0.1.4
	zeroize@1.8.1
	zerovec-derive@0.10.2
	zerovec@0.10.2
"

LLVM_COMPAT=( {17..18} )
inherit cargo llvm-r1 xdg-utils

DESCRIPTION="Sequoia's reimplementation of the GnuPG interface"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/"
SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v${PV}/${P}-v${PV}.tar.bz2
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}"/${PN}-v${PV}-ff7ef2c893283c6fcdeab971de19593c239d2f5f

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ LGPL-3+ MIT MPL-2.0
	Unicode-3.0 Unicode-DFS-2016
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
# Still some issue to do with columns?
RESTRICT="test"

DEPEND="
	dev-db/sqlite:3
	dev-libs/gmp:=
	dev-libs/nettle:=
	dev-libs/openssl:=
"
RDEPEND="${DEPEND}"
# Clang needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
	')
	>=virtual/rust-1.70
"

QA_FLAGS_IGNORED="usr/bin/gpg-sq usr/bin/gpgv-sq"

src_test() {
	local -x GNUPGHOME="${T}"/.gnupg
	local -x REAL_GPG_BIN="${BROOT}"/usr/bin/gpg
	local -x REAL_GPGV_BIN="${BROOT}"/usr/bin/gpgv

	mkdir "${GNUPGHOME}" || die
	chmod 700 "${GNUPGHOME}" || die

	xdg_environment_reset
	RUST_BACKTRACE=full cargo_src_test -vv
}
