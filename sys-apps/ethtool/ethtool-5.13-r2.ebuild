# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rhel8

DESCRIPTION="Utility for examining and tuning ethernet-based network interfaces"
HOMEPAGE="https://www.kernel.org/pub/software/network/ethtool/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="+netlink"

BDEPEND="app-arch/xz-utils"
RDEPEND="netlink? ( net-libs/libmnl )"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable netlink)
}
