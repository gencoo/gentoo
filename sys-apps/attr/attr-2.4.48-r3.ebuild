# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic libtool toolchain-funcs multilib-minimal usr-ldscript rhel8

DESCRIPTION="Extended attributes tools"
HOMEPAGE="https://savannah.nongnu.org/projects/attr"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug nls static-libs"

BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-switch-back-to-syscall.patch"
)

pkg_setup() {
	# Remove -flto* from flags as this breaks binaries (bug #644048)
	filter-flags -flto*
	append-ldflags "-Wl,--no-gc-sections" #700116
}

src_prepare() {
	default
	elibtoolize #580792
}

multilib_src_configure() {
	unset PLATFORM #184564
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	tc-ld-disable-gold #644048

	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable nls)
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable debug)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Sanity check until we track down why this is happening. #644048
	local lib="${ED}/usr/$(get_libdir)/libattr.so.1"

	if multilib_is_native_abi; then
		# we install attr into /bin, so we need the shared lib with it
		gen_usr_ldscript -a attr
	fi

	# Add a wrapper until people upgrade.
	insinto /usr/include/attr
	newins "${FILESDIR}"/xattr-shim.h xattr.h
}

multilib_src_install_all() {
	rm -f ${ED}/lib64/libattr.{l,}a
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	einstalldocs
}
