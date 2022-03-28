# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	aho-corasick-0.7.18
	ansi_term-0.12.1
	arrayref-0.3.6
	arrayvec-0.5.2
	async-broadcast-0.3.4
	async-channel-1.6.1
	async-executor-1.4.1
	async-io-1.6.0
	async-lock-2.5.0
	async-recursion-0.3.2
	async-task-4.2.0
	async-trait-0.1.52
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	blake2b_simd-0.5.11
	block-0.1.6
	block-buffer-0.7.3
	block-buffer-0.10.2
	block-padding-0.1.5
	byte-tools-0.3.1
	byte-unit-4.0.14
	byteorder-1.4.3
	bytes-1.1.0
	cache-padded-1.2.0
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.19
	clap-3.1.6
	clap_complete-3.1.1
	clap_derive-3.1.4
	combine-4.6.3
	concurrent-queue-1.2.2
	constant_time_eq-0.1.5
	core-foundation-0.7.0
	core-foundation-sys-0.7.0
	cpufeatures-0.2.1
	crossbeam-channel-0.5.2
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.7
	crossbeam-utils-0.8.7
	crypto-common-0.1.3
	derivative-2.2.0
	difflib-0.4.0
	digest-0.8.1
	digest-0.10.3
	directories-next-2.0.0
	dirs-1.0.5
	dirs-sys-next-0.1.2
	dlv-list-0.3.0
	downcast-0.11.0
	dunce-1.0.2
	easy-parallel-3.2.0
	either-1.6.1
	enumflags2-0.7.3
	enumflags2_derive-0.7.3
	event-listener-2.5.2
	fake-simd-0.1.2
	fastrand-1.7.0
	float-cmp-0.9.0
	form_urlencoded-1.0.1
	fragile-1.1.0
	futures-core-0.3.21
	futures-io-0.3.21
	futures-lite-1.12.0
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.12.4
	generic-array-0.14.5
	gethostname-0.2.2
	getrandom-0.1.16
	getrandom-0.2.5
	git2-0.13.25
	hashbrown-0.11.2
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.1.19
	hex-0.4.3
	idna-0.2.3
	indexmap-1.8.0
	instant-0.1.12
	is_debug-1.0.1
	itertools-0.10.3
	itoa-1.0.1
	jobserver-0.1.24
	kstring-1.0.6
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.119
	libgit2-sys-0.12.26+1.3.0
	libz-sys-1.1.5
	linked-hash-map-0.5.4
	local_ipaddress-0.1.3
	log-0.4.14
	mac-notification-sys-0.3.0
	mach-0.3.2
	malloc_buf-0.0.6
	maplit-1.0.2
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.5
	minimal-lexical-0.2.1
	mockall-0.11.0
	mockall_derive-0.11.0
	nix-0.23.1
	nom-7.1.0
	normalize-line-endings-0.3.0
	notify-rust-4.5.6
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.1
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.10.0
	opaque-debug-0.2.3
	open-2.1.1
	ordered-multimap-0.4.2
	ordered-stream-0.0.1
	os_info-3.2.0
	os_str_bytes-6.0.0
	parking-2.0.0
	path-slash-0.1.4
	pathdiff-0.2.1
	percent-encoding-2.1.0
	pest-2.1.3
	pest_derive-2.1.0
	pest_generator-2.1.3
	pest_meta-2.1.3
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.24
	polling-2.2.0
	ppv-lite86-0.2.16
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro-crate-1.1.3
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	process_control-3.2.1
	quick-xml-0.22.0
	quote-1.0.15
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.1.57
	redox_syscall-0.2.11
	redox_users-0.3.5
	redox_users-0.4.0
	regex-1.5.5
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	rust-argon2-0.8.3
	rust-ini-0.18.0
	ryu-1.0.9
	scopeguard-1.1.0
	semver-1.0.6
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_repr-0.1.7
	sha-1-0.8.2
	sha-1-0.10.0
	sha1-0.6.1
	sha1_smol-1.0.0
	shadow-rs-0.9.0
	shell-words-1.1.0
	slab-0.4.5
	socket2-0.4.4
	starship-1.4.2
	starship-battery-0.7.9
	starship_module_config_derive-0.2.1
	static_assertions-1.1.0
	strsim-0.10.0
	strum-0.22.0
	strum_macros-0.22.0
	syn-1.0.86
	sys-info-0.9.1
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.1.17
	termtree-0.2.4
	textwrap-0.15.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	time-0.1.44
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	toml-0.5.8
	toml_edit-0.13.4
	typenum-1.15.0
	ucd-trie-0.1.3
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	uom-0.30.0
	url-2.2.2
	urlencoding-2.1.0
	utf8-width-0.1.5
	vcpkg-0.2.15
	version_check-0.9.4
	versions-4.0.0
	waker-fn-1.1.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	wepoll-ffi-0.1.2
	which-4.2.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.24.0
	windows-sys-0.30.0
	windows_aarch64_msvc-0.30.0
	windows_i686_gnu-0.24.0
	windows_i686_gnu-0.30.0
	windows_i686_msvc-0.24.0
	windows_i686_msvc-0.30.0
	windows_x86_64_gnu-0.24.0
	windows_x86_64_gnu-0.30.0
	windows_x86_64_msvc-0.24.0
	windows_x86_64_msvc-0.30.0
	winres-0.1.12
	winrt-notification-0.5.1
	xml-rs-0.8.4
	yaml-rust-0.4.5
	zbus-2.1.1
	zbus_macros-2.1.1
	zbus_names-2.1.0
	zvariant-3.1.2
	zvariant_derive-3.1.2
"

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell!"
HOMEPAGE="https://starship.rs/"
SRC_URI="$(cargo_crate_uris)"

LICENSE="
	|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT )
	|| ( Apache-2.0 MIT ZLIB )
	|| ( MIT Unlicense )
	Apache-2.0
	BSD
	BSD-2
	CC0-1.0
	ISC
	MIT
	MPL-2.0
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=virtual/rust-1.59"
DEPEND=">=dev-libs/libgit2-1.2.0:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/starship"

src_configure() {
	export PKG_CONFIG_ALLOW_CROSS=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export OPENSSL_NO_VENDOR=true

	cargo_src_configure
}

src_install() {
	cargo_src_install

	einstalldocs
}
