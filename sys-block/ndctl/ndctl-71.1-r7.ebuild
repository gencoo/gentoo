# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 rhel8

DESCRIPTION="Helper tools and libraries for managing non-volatile memory on Linux"
HOMEPAGE="https://github.com/pmem/ndctl"

LICENSE="GPL-2 LGPL-2.1 MIT CC0-1.0"
SLOT="0/6"
KEYWORDS="amd64 ~x86"
IUSE="bash-completion systemd test"

DEPEND="
	dev-libs/json-c:=
	sys-apps/keyutils:=
	sys-apps/kmod:=
	sys-apps/util-linux:=
	virtual/libudev:=
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	sys-devel/libtool
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

# tests require root access
RESTRICT+=" test"

DOCS=(
	README.md
	CONTRIBUTING.md
)

src_prepare() {
	default
	printf 'm4_define([GIT_VERSION], [%s])' "${PV}" > version.m4 || die
	sed -e '/git-version-gen/ d' -i Makefile.am || die
	eautoreconf
	./autogen.sh
}

src_configure() {
	econf \
		$(use_with bash-completion bash) \
		$(use_with systemd) \
		--disable-asciidoctor \
		--disable-static \
		--disable-silent-rules
}

src_test() {
	emake check
}

src_install() {
	default

	bashcomp_alias ndctl daxctl
}
