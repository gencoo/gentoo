# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6,8,9} )
inherit autotools multilib-minimal python-single-r1 rhel8-a

DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="alisp debug doc python +thread-safety"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="doc? ( >=app-doc/doxygen-1.2.6 )"
RDEPEND="python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-missing_files.patch" # bug #652422
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	find . -name Makefile.am -exec sed -i -e '/CFLAGS/s:-g -O2::' {} + || die
	# https://bugs.gentoo.org/545950
	sed -i -e '5s:^$:\nAM_CPPFLAGS = -I$(top_srcdir)/include:' test/lsb/Makefile.am || die
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-maintainer-mode
		--disable-resmgr
		--enable-aload
		--enable-rawmidi
		--enable-seq
		--enable-shared
		--with-plugindir=${_libdir}/alsa-lib
		# enable Python only on final ABI
		$(multilib_native_use_enable python)
		$(use_enable alisp)
		$(use_enable thread-safety)
		$(use_with debug)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	# Remove useless /usr/lib64 rpath on 64bit archs
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool

	emake

	if multilib_is_native_abi && use doc; then
		emake doc
		grep -FZrl "${S}" doc/doxygen/html | \
			xargs -0 sed -i -e "s:${S}::" || die
	fi
}

multilib_src_install() {
	multilib_is_native_abi && use doc && local HTML_DOCS=( doc/doxygen/html/. )
	default

	# Install global configuration files
	insopts -m0755
	insinto /etc/
	doins "${WORKDIR}"/asound.conf

	# Install the modprobe files for ALSA
	insopts -m0755
	insinto ${_prefix}/lib/modprobe.d/
	newins "${WORKDIR}"/modprobe-dist-alsa.conf dist-alsa.conf

	dodir ${_datadir}/alsa/{ucm,ucm2,topology}

	# Unpack UCMs
	tar xvjf ${WORKDIR}/alsa-ucm-conf-1.2.6.3.tar.bz2 -C ${ED}${_datadir}/alsa --strip-components=1 "*/ucm" "*/ucm2"
	patch -d ${ED}${_datadir}/alsa -p1 < ${WORKDIR}/alsa-ucm-git.patch

	# Unpack topologies
	tar xvjf ${WORKDIR}/alsa-topology-conf-1.2.5.tar.bz2 -C ${ED}${_datadir}/alsa --strip-components=1 "*/topology"
}

multilib_src_install_all() {
	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
	dodoc ChangeLog doc/asoundrc.txt NOTES TODO
}
