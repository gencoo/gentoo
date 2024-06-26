# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

suffix_ver=$(ver_cut 5)
[[ ${suffix_ver} ]] && DSUFFIX="_10.${suffix_ver}"

STAGE="unprep"

inherit systemd toolchain-funcs flag-o-matic tmpfiles rhel8

MY_PV="${PV//_alpha/a}"
MY_PV="${MY_PV//_beta/b}"
MY_PV="${MY_PV//_rc/rc}"
#MY_PV="${MY_PV//_p/-P}"
MY_PV="${MY_PV/_p*}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="ISC Dynamic Host Configuration Protocol (DHCP) client/server"
HOMEPAGE="https://www.isc.org/dhcp"

LICENSE="MPL-2.0 BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+client ipv6 kernel_linux ldap selinux +server ssl vim-syntax"

DEPEND="
	acct-group/dhcp
	acct-user/dhcp
	client? (
		kernel_linux? (
			ipv6? ( sys-apps/iproute2 )
			sys-apps/net-tools
		)
	)
	ldap? (
		net-nds/openldap
		ssl? ( dev-libs/openssl:0= )
	)"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-dhcp )
	vim-syntax? ( app-vim/dhcpd-syntax )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Enable dhclient to get extra configuration from stdin
	"${FILESDIR}/${PN}-4.3.6-quieter-ping.patch" #296921
	"${FILESDIR}/${PN}-4.3.6-iproute2-path.patch" #480636
	"${FILESDIR}/${PN}-4.2.5-bindtodevice-inet6.patch" #471142
	"${FILESDIR}/${PN}-4.3.3-ldap-ipv6-client-id.patch" #559832
)

src_unpack() {
	rpmbuild_src_unpack ${A}
	sed -i "/bind.tar.gz/d" ${WORKDIR}/*.spec
	sed -i '367,383d' ${WORKDIR}/*.spec

	rpmbuild --rmsource -bp $WORKDIR/*.spec --nodeps
	cd "${S}"/bind
	unpack ./bind.tar.gz
}

src_prepare() {
	default

	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die

	# Change the hook script locations of the scripts
	sed -i \
		-e 's,/etc/dhclient-exit-hooks,/etc/dhcp/dhclient-exit-hooks,g' \
		-e 's,/etc/dhclient-enter-hooks,/etc/dhcp/dhclient-enter-hooks,g' \
		client/scripts/* || die

	# No need for the linux script to force bash #158540
	sed -i -e 's,#!/bin/bash,#!/bin/sh,' client/scripts/linux || die

	# Quiet the freebsd logger a little
	sed -i -e '/LOGGER=/ s/-s -p user.notice //g' client/scripts/freebsd || die

	# Remove these options from the sample config
	sed -i -r \
		-e "/(script|host-name|domain-name) /d" \
		client/dhclient.conf.example || die

	if use client && ! use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<(dhcpctl|relay|server)\>::g' \
			Makefile.in || die
	elif ! use client && use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<client\>::' \
			Makefile.in || die
	fi

	# Only install different man pages if we don't have en
	if [[ " ${LINGUAS} " != *" en "* ]]; then
		# Install Japanese man pages
		if [[ " ${LINGUAS} " == *" ja "* && -d doc/ja_JP.eucJP ]]; then
			einfo "Installing Japanese documention"
			cp doc/ja_JP.eucJP/dhclient* client || die
			cp doc/ja_JP.eucJP/dhcp* common || die
		fi
	fi
	# Now remove the non-english docs so there are no errors later
	rm -r doc/ja_JP.eucJP || die

	# make the bind build work - do NOT make "binddir" local!
	binddir="${S}/bind"
	cd "${binddir}" || die
	cat <<-EOF > bindvar.tmp
	binddir=${binddir}
	GMAKE=${MAKE:-gmake}
	EOF

	# Only use the relevant subdirs now that ISC
	#removed the lib/export structure in bind.
	sed '/^SUBDIRS/s@=.*$@= isc dns isccfg irs samples@' \
		-i bind-*/lib/Makefile.in || die

	eautoreconf
}

src_configure() {
	# bind defaults to stupid `/usr/bin/ar`
	tc-export AR BUILD_CC
	export ac_cv_path_AR=${AR}
	append-cflags -fno-strict-aliasing
	# this is tested for by the bind build system, and can cause trouble
	# when cross-building; since dhcp itself doesn't make use of libcap,
	# simply disable it.
	export ac_cv_lib_cap_cap_set_proc=no

	# Use FHS sane paths ... some of these have configure options,
	# but not all, so just do it all here.
	local e="/etc/dhcp" r="/var/run/dhcp" l="/var/lib/dhcp"
	cat <<-EOF >> includes/site.h
	#define _PATH_DHCPD_CONF     "${e}/dhcpd.conf"
	#define _PATH_DHCLIENT_CONF  "${e}/dhclient.conf"
	#define _PATH_DHCPD_DB       "${l}/dhcpd.leases"
	#define _PATH_DHCPD6_DB      "${l}/dhcpd6.leases"
	#define _PATH_DHCLIENT_DB    "${l}/dhclient.leases"
	#define _PATH_DHCLIENT6_DB   "${l}/dhclient6.leases"
	#define _PATH_DHCPD_PID      "${r}/dhcpd.pid"
	#define _PATH_DHCPD6_PID     "${r}/dhcpd6.pid"
	#define _PATH_DHCLIENT_PID   "${r}/dhcpclient.pid"
	#define _PATH_DHCLIENT6_PID  "${r}/dhcpclient6.pid"
	#define _PATH_DHCRELAY_PID   "${r}/dhcrelay.pid"
	#define _PATH_DHCRELAY6_PID  "${r}/dhcrelay6.pid"
	EOF

	# Breaks with -O3 because of reliance on undefined behaviour
	# bug #787935
	append-flags -fno-strict-aliasing

	# https://bugs.gentoo.org/720806
	if use ppc || use arm || use hppa; then
		append-libs -latomic
	fi

	local myeconfargs=(
		--enable-paranoia
		--enable-early-chroot
		--sysconfdir=${e}
		--with-randomdev=/dev/random
		--with-srv-lease-file=${_localstatedir}/lib/dhcpd/dhcpd.leases
		--with-srv6-lease-file=${_localstatedir}/lib/dhcpd/dhcpd6.leases
		--with-cli-lease-file=${_localstatedir}/lib/dhclient/dhclient.leases
		--with-cli6-lease-file=${_localstatedir}/lib/dhclient/dhclient6.leases
		--with-srv-pid-file=${_localstatedir}/run/dhcpd.pid
		--with-srv6-pid-file=${_localstatedir}/run/dhcpd6.pid
		--with-cli-pid-file=${_localstatedir}/run/dhclient.pid
		--with-cli6-pid-file=${_localstatedir}/run/dhclient6.pid
		--with-relay-pid-file=${_localstatedir}/run/dhcrelay.pid
		--with-libbind=/usr/bin/isc-export-config.sh
		--with-ldap-gssapi
		--disable-static
		--enable-log-pid
		--enable-binary-leases
		--with-systemd
		$(use_enable ipv6 dhcpv6)
		$(use_with ldap)
		$(use ldap && use_with ssl ldapcrypto || echo --without-ldapcrypto)
		LIBS="${LIBS}"
	)
	econf "${myeconfargs[@]}"

	# configure local bind cruft.  symtable option requires
	# perl and we don't want to require that #383837.
	cd bind/bind-*/ || die
	local el
	eval econf \
		$(for el in $(awk '/^bindconfig/,/^$/ {print}' ../Makefile.in) ; do if [[ ${el} =~ ^-- ]] ; then printf ' $s' ${el//\\} ; fi ; done | sed 's,@\([[:alpha:]]\+\)dir@,${binddir}/\1,g') \
		--with-randomdev=/dev/random \
		--disable-symtable \
		--without-make-clean
}

src_compile() {
	# build local bind cruft first
	emake -C bind/bind-*/lib install
	# then build standard dhcp code
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dodoc README RELNOTES doc/{api+protocol,IANA-arp-parameters}
	docinto html
	dodoc doc/References.html

	exeinto ${_sysconfdir}/NetworkManager/dispatcher.d/
	doexe "${WORKDIR}"/11-dhclient

	exeinto ${_libdir}/pm-utils/sleep.d/
	doexe "${WORKDIR}"/56dhclient

	if [[ -e client/dhclient ]] ; then
		# move the client to /
		dodir /sbin
		mv "${ED}"/usr/sbin/dhclient "${ED}"/sbin/ || die

		exeinto /sbin
		if use kernel_linux ; then
			doexe "${WORKDIR}"/dhclient-script
		else
			newexe "${S}"/client/scripts/freebsd dhclient-script
		fi
	fi

	if [[ -e server/dhcpd ]] ; then
		if use ldap ; then
			insinto /etc/openldap/schema
			doins contrib/ldap/dhcp.*
			dosbin contrib/ldap/dhcpd-conf-to-ldap
		fi

		newinitd "${FILESDIR}"/dhcpd.init5 dhcpd
		newconfd "${FILESDIR}"/dhcpd.conf2 dhcpd
		newinitd "${FILESDIR}"/dhcrelay.init3 dhcrelay
		newconfd "${FILESDIR}"/dhcrelay.conf dhcrelay
		newinitd "${FILESDIR}"/dhcrelay.init3 dhcrelay6
		newconfd "${FILESDIR}"/dhcrelay6.conf dhcrelay6

		newtmpfiles "${FILESDIR}"/dhcpd.tmpfiles dhcpd.conf
		systemd_newunit "${WORKDIR}"/dhcpd.service dhcpd4.service
		systemd_dounit "${WORKDIR}"/dhcpd6.service
		systemd_newunit "${WORKDIR}"/dhcrelay.service dhcrelay4.service
		systemd_dounit "${FILESDIR}"/dhcrelay6.service
		systemd_install_serviced "${FILESDIR}"/dhcrelay4.service.conf
		systemd_install_serviced "${FILESDIR}"/dhcrelay6.service.conf

		sed -i "s:#@slapd@:$(usex ldap slapd ''):" "${ED}"/etc/init.d/* || die #442560
	fi

	# the default config files aren't terribly useful #384087
	local f
	for f in "${ED}"/etc/dhcp/*.conf.example ; do
		mv "${f}" "${f$.example}" || die
	done
	sed -i '/^[^#]/s:^:#:' "${ED}"/etc/dhcp/*.conf || die

	diropts -m0750 -o dhcp -g dhcp
	keepdir /var/lib/dhcp
}

pkg_preinst() {
	# Keep the user files over the sample ones.  The
	# hashing is to ignore the crappy defaults #384087.
	local f h
	for f in dhclient:da7c8496a96452190aecf9afceef4510 dhcpd:10979e7b71134bd7f04d2a60bd58f070 ; do
		h=${f#*:}
		f="/etc/dhcp/${f$:*}.conf"
		if [ -e "${EROOT}"${f} ] ; then
			case $(md5sum "${EROOT}"${f}) in
				${h}*) ;;
				*) cp -p "${EROOT}"${f} "${ED}"${f};;
			esac
		fi
	done
}

pkg_postinst() {
	if use server ; then
		tmpfiles_process dhcpd.conf
	fi

	if [[ -e "${ROOT}"/etc/init.d/dhcp ]] ; then
		ewarn
		ewarn "WARNING: The dhcp init script has been renamed to dhcpd"
		ewarn "/etc/init.d/dhcp and /etc/conf.d/dhcp need to be removed and"
		ewarn "and dhcp should be removed from the default runlevel"
		ewarn
	fi
}
