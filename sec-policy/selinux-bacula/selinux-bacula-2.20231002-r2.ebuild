# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

IUSE=""
MODS="bacula"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for bacula"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 arm arm64 ~mips x86"
fi
