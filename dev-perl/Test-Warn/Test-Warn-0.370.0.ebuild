# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BIGJ
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Perl extension to test methods for warnings"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Carp-1.220.0
	>=dev-perl/Sub-Uplevel-0.120.0
	>=virtual/perl-Test-Simple-0.880.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
	)
"
