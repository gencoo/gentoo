# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam rhel8

DESCRIPTION="Utilities to deal with user accounts"
HOMEPAGE="https://github.com/shadow-maint/shadow"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="acl +audit cracklib nls pam selinux +su skey split-usr xattr"
# Taken from the man/Makefile.am file.
LANGS=( cs da de es fi fr hu id it ja ko pl pt_BR ru sv tr zh_CN zh_TW )

REQUIRED_USE="?? ( cracklib pam )"

BDEPEND="
	app-arch/xz-utils
	sys-devel/gettext
"
COMMON_DEPEND="
	dev-util/itstool
	virtual/libcrypt:=
	acl? ( sys-apps/acl:0= )
	audit? ( >=sys-process/audit-2.6:0= )
	cracklib? ( >=sys-libs/cracklib-2.7-r3:0= )
	nls? ( virtual/libintl )
	pam? ( sys-libs/pam:0= )
	skey? ( sys-auth/skey:0= )
	selinux? (
		>=sys-libs/libselinux-1.28:0=
		sys-libs/libsemanage:0=
	)
	xattr? ( sys-apps/attr:0= )
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-4.14
"
RDEPEND="${COMMON_DEPEND}
	pam? ( >=sys-auth/pambase-20150213 )
	su? ( !sys-apps/util-linux[su(-)] )
"

src_prepare() {
	default
	eautoreconf
	#elibtoolize
}

src_configure() {
	export CFLAGS="$CFLAGS -fpie"
	export LDFLAGS="-pie -Wl,-z,relro -Wl,-z,now"
	local myeconfargs=(
		--disable-account-tools-setuid
		--enable-shared=no
		--enable-static=yes
		--enable-shadowgrp
		--enable-man
		--with-sha-crypt
		--with-group-name-max-length=32
		--without-tcb
		$(use_enable nls)
		$(use_with acl)
		$(use_with audit)
		$(use_with cracklib libcrack)
		$(use_with elibc_glibc nscd)
		$(use_with pam libpam)
		$(use_with selinux)
		$(use_with skey)
		$(use_with xattr attr)
	)
	econf "${myeconfargs[@]}"

	has_version 'sys-libs/uclibc[-rpc]' && sed -i '/RLOGIN/d' config.h #425052

	if use nls ; then
		local l langs="po" # These are the pot files.
		for l in ${LANGS[*]} ; do
			has ${l} ${LINGUAS-${l}} && langs+=" ${l}"
		done
		sed -i "/^SUBDIRS = /s:=.*:= ${langs}:" man/Makefile || die
	fi
}

set_login_opt() {
	local comment="" opt=${1} val=${2}
	if [[ -z ${val} ]]; then
		comment="#"
		sed -i \
			-e "/^${opt}\>/s:^:#:" \
			"${ED}"/etc/login.defs || die
	else
		sed -i -r \
			-e "/^#?${opt}\>/s:.*:${opt} ${val}:" \
			"${ED}"/etc/login.defs
	fi
	local res=$(grep "^${comment}${opt}\>" "${ED}"/etc/login.defs)
	einfo "${res:-Unable to find ${opt} in /etc/login.defs}"
}

src_install() {
	emake DESTDIR="${D}" gnulocaledir=${D}/var/locale MKINSTALLDIRS=`pwd`/mkinstalldirs suidperms=4711 install

	ln -s useradd.8 ${D}/usr/share/man/man8/adduser.8
	for subdir in ${D}/usr/share/man/{??,??_??,??_??.*}/man* ; do
        	test -d $subdir && test -e $subdir/useradd.8 && echo ".so man8/useradd.8" > $subdir/adduser.8
	done

	# Remove binaries we don't use.
	rm ${D}/usr/bin/chfn
	rm ${D}/usr/bin/chsh
	rm ${D}/usr/bin/expiry
	rm ${D}/usr/bin/faillog
	rm ${D}/usr/sbin/logoutd
	rm ${D}/usr/share/man/man1/chfn.*
	rm ${D}/usr/share/man/*/man1/chfn.*
	rm ${D}/usr/share/man/man1/chsh.*
	rm ${D}/usr/share/man/*/man1/chsh.*
	rm ${D}/usr/share/man/man1/expiry.*
	rm ${D}/usr/share/man/*/man1/expiry.*
	rm ${D}/usr/share/man/man1/groups.*
	rm ${D}/usr/share/man/*/man1/groups.*
	rm ${D}/usr/share/man/man1/login.*
	rm ${D}/usr/share/man/*/man1/login.*
	rm ${D}/usr/share/man/man1/passwd.*
	rm ${D}/usr/share/man/*/man1/passwd.*
	rm ${D}/usr/share/man/man1/su.*
	rm ${D}/usr/share/man/*/man1/su.*
	rm ${D}/usr/share/man/man5/passwd.*
	rm ${D}/usr/share/man/*/man5/passwd.*
	rm ${D}/usr/share/man/man5/suauth.*
	rm ${D}/usr/share/man/*/man5/suauth.*
	rm ${D}/usr/share/man/man8/logoutd.*
	rm ${D}/usr/share/man/*/man8/logoutd.*
	rm ${D}/usr/share/man/man8/nologin.*
	rm ${D}/usr/share/man/*/man8/nologin.*
	rm ${D}/usr/share/man/man3/getspnam.*
	rm ${D}/usr/share/man/*/man3/getspnam.*
	rm ${D}/usr/share/man/man5/faillog.*
	rm ${D}/usr/share/man/*/man5/faillog.*
	rm ${D}/usr/share/man/man8/faillog.*
	rm ${D}/usr/share/man/*/man8/faillog.*

	find ${D}/usr/share/man -depth -type d -empty -delete

	# Remove libshadow and libmisc; see bug 37725 and the following
	# comment from shadow's README.linux:
	#   Currently, libshadow.a is for internal use only, so if you see
	#   -lshadow in a Makefile of some other package, it is safe to
	#   remove it.
	rm -f "${ED}"/{,usr/}$(get_libdir)/lib{misc,shadow}.{a,la}

	insinto /etc
	if ! use pam ; then
		insopts -m0600
		doins etc/login.access etc/limits
	fi

	# needed for 'useradd -D'
	insinto /etc/default
	insopts -m0600
	doins "${FILESDIR}"/default/useradd

	if use split-usr ; then
		# move passwd to / to help recover broke systems #64441
		# We cannot simply remove this or else net-misc/scponly
		# and other tools will break because of hardcoded passwd
		# location
		dodir /bin
		mv "${ED}"/usr/bin/passwd "${ED}"/bin/ || die
		dosym ../../bin/passwd /usr/bin/passwd
	fi

	cd "${S}" || die
	insinto /etc
	insopts -m0644
	newins etc/login.defs login.defs

	set_login_opt CREATE_HOME yes
	if ! use pam ; then
		set_login_opt MAIL_CHECK_ENAB no
		set_login_opt SU_WHEEL_ONLY yes
		set_login_opt CRACKLIB_DICTPATH /usr/lib/cracklib_dict
		set_login_opt LOGIN_RETRIES 3
		set_login_opt ENCRYPT_METHOD SHA512
		set_login_opt CONSOLE
	else
		dopamd "${FILESDIR}"/pam.d-include/shadow

		for x in chsh shfn ; do
			newpamd "${FILESDIR}"/pam.d-include/passwd ${x}
		done

		for x in chpasswd newusers ; do
			newpamd "${FILESDIR}"/pam.d-include/chpasswd ${x}
		done

		newpamd "${FILESDIR}"/pam.d-include/shadow-r1 groupmems

		# comment out login.defs options that pam hates
		local opt sed_args=()
		for opt in \
			CHFN_AUTH \
			CONSOLE \
			CRACKLIB_DICTPATH \
			ENV_HZ \
			ENVIRON_FILE \
			FAILLOG_ENAB \
			FTMP_FILE \
			LASTLOG_ENAB \
			MAIL_CHECK_ENAB \
			MOTD_FILE \
			NOLOGINS_FILE \
			OBSCURE_CHECKS_ENAB \
			PASS_ALWAYS_WARN \
			PASS_CHANGE_TRIES \
			PASS_MIN_LEN \
			PORTTIME_CHECKS_ENAB \
			QUOTAS_ENAB \
			SU_WHEEL_ONLY
		do
			set_login_opt ${opt}
			sed_args+=( -e "/^#${opt}\>/b pamnote" )
		done
		sed -i "${sed_args[@]}" \
			-e 'b exit' \
			-e ': pamnote; i# NOTE: This setting should be configured via /etc/pam.d/ and not in this file.' \
			-e ': exit' \
			"${ED}"/etc/login.defs || die

		# remove manpages that pam will install for us
		# and/or don't apply when using pam
		find "${ED}"/usr/share/man -type f \
			'(' -name 'limits.5*' -o -name 'suauth.5*' ')' \
			-delete

		# Remove pam.d files provided by pambase.
		rm "${ED}"/etc/pam.d/{login,passwd} || die
		if use su ; then
			rm "${ED}"/etc/pam.d/su || die
		fi
	fi

	# Remove manpages that are handled by other packages
	find "${ED}"/usr/share/man \
		'(' -name id.1 -o -name passwd.5 -o -name getspnam.3 ')' \
		-delete

	cd "${S}" || die
	dodoc ChangeLog NEWS TODO
	newdoc README README.download
	cd doc || die
	dodoc HOWTO README* WISHLIST *.txt
}

pkg_preinst() {
	rm -f "${EROOT}"/etc/pam.d/system-auth.new \
		"${EROOT}/etc/login.defs.new"
}

pkg_postinst() {
	# Enable shadow groups.
	if [ ! -f "${EROOT}"/etc/gshadow ] ; then
		if grpck -r -R "${EROOT}" 2>/dev/null ; then
			grpconv -R "${EROOT}"
		else
			ewarn "Running 'grpck' returned errors.  Please run it by hand, and then"
			ewarn "run 'grpconv' afterwards!"
		fi
	fi

	[[ ! -f "${EROOT}"/etc/subgid ]] &&
		touch "${EROOT}"/etc/subgid
	[[ ! -f "${EROOT}"/etc/subuid ]] &&
		touch "${EROOT}"/etc/subuid

	einfo "The 'adduser' symlink to 'useradd' has been dropped."
}
