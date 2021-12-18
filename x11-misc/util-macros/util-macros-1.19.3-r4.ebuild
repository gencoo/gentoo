# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rhel9-c

DESCRIPTION="X.Org autotools utility macros"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/util/macros"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
src_compile() { true; }
