# Copyright 2012-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools rhel9-a

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/libpinyin/libpinyin"
fi

LIBPINYIN_MODEL_VERSION="19"

DESCRIPTION="Libraries for handling of Hanyu Pinyin and Zhuyin Fuhao"
HOMEPAGE="https://github.com/libpinyin/libpinyin https://sourceforge.net/projects/libpinyin/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
fi
SRC_URI+=" mirror://sourceforge/${PN}/models/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz -> ${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz"

LICENSE="GPL-3+"
SLOT="0/13"
KEYWORDS="amd64 arm64 ppc ppc64 x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/glib:2
	sys-libs/db:="
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e "/^\twget .*\/model${LIBPINYIN_MODEL_VERSION}\.text\.tar\.gz$/d" -i data/Makefile.am || die
	ln -s "${DISTDIR}/${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" "data/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-libzhuyin \
		--with-dbm=BerkeleyDB \
		--disable-static
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
