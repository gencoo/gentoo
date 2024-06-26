# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#suffix_ver=$(ver_cut 4).$(ver_cut 6)
#[[ ${suffix_ver} ]] && DSUFFIX="_${suffix_ver}"

inherit flag-o-matic rhel8

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="https://www.gnu.org/software/tar/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE="acl elibc_glibc minimal nls selinux userland_GNU xattr"

RDEPEND="acl? ( virtual/acl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.35 )
	xattr? ( elibc_glibc? ( sys-apps/attr ) )"

src_prepare() {
	default

	if ! use userland_GNU ; then
		sed -i \
			-e 's:/backup\.sh:/gbackup.sh:' \
			scripts/{backup,dump-remind,restore}.in \
			|| die "sed non-GNU"
	fi
}

src_configure() {
	local myeconfargs=(
		--with-lzma="xz --format=lzma"
		DEFAULT_RMT_DIR=/etc
		RSH=/usr/bin/ssh
		--bindir="${EPREFIX%/}"/bin
		--enable-backup-scripts
		--libexecdir="${EPREFIX%/}"/usr/sbin
		$(usex userland_GNU "" "--program-prefix=g")
		$(use_with acl posix-acls)
		$(use_enable nls)
		$(use_with selinux)
		$(use_with xattr xattrs)
	)
	FORCE_UNSAFE_CONFIGURE=1 econf "${myeconfargs[@]}"
}

src_test() {
	rm -f $D/test/testsuite
	emake check || (
    	# get the error log
	set +x
		find -name testsuite.log | while read line; do
        	echo "=== $line ==="
        	cat "$line"
        	echo
	done
	false
	)
}

src_install() {
	default

	local p=$(usex userland_GNU "" "g")
	if [[ -z ${p} ]] ; then
		# a nasty yet required piece of baggage
		exeinto /etc
		doexe "${FILESDIR}"/rmt
	fi

	# autoconf looks for gtar before tar (in configure scripts), hence
	# in Prefix it is important that it is there, otherwise, a gtar from
	# the host system (FreeBSD, Solaris, Darwin) will be found instead
	# of the Prefix provided (GNU) tar
	if use prefix ; then
		dosym tar /bin/gtar
	fi

	mv "${ED%/}"/usr/sbin/${p}backup{,-tar} || die
	mv "${ED%/}"/usr/sbin/${p}restore{,-tar} || die

	if use minimal ; then
		find "${ED%/}"/etc "${ED%/}"/*bin/ "${ED%/}"/usr/*bin/ \
			-type f -a '!' '(' -name tar -o -name ${p}tar ')' \
			-delete || die
	fi
}
