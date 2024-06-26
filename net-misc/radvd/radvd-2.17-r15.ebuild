# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 systemd toolchain-funcs rhel8-a

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ~ppc64 sparc x86"
IUSE="kernel_FreeBSD selinux test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
CDEPEND="dev-libs/libdaemon"
DEPEND="
	${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	test? ( dev-libs/check )
"
RDEPEND="
	${CDEPEND}
	acct-group/radvd
	acct-user/radvd
	selinux? ( sec-policy/selinux-radvd )
"

DOCS=( CHANGES README TODO radvd.conf.example )

PATCHES=(
	"${FILESDIR}"/${P}-nd_opt_6co.patch
)

src_configure() {
	econf --with-pidfile=/run/radvd/radvd.pid \
		--with-systemdsystemunitdir=no \
		$(use_with test check)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	docinto html
	dodoc INTRO.html

	newinitd "${FILESDIR}"/${PN}-2.15.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service

	if use kernel_FreeBSD ; then
		sed -e \
			's/^SYSCTL_FORWARD=.*$/SYSCTL_FORWARD=net.inet6.ip6.forwarding/g' \
			-i "${D}"/etc/init.d/${PN} || die
	fi

	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please create a configuration file ${ROOT}/etc/radvd.conf.
See ${ROOT}/usr/share/doc/${PF} for an example.

grsecurity users should allow a specific group to read /proc
and add the radvd user to that group, otherwise radvd may
segfault on startup."
