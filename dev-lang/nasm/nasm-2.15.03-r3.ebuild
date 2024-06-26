# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic rhel8-p

DESCRIPTION="groovy little assembler"
HOMEPAGE="https://www.nasm.us/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE="doc"

RDEPEND=""
DEPEND=""
# [fonts note] doc/psfonts.ph defines ordered list of font preference.
# Currently 'media-fonts/source-pro' is most preferred and is able to
# satisfy all 6 font flavours: tilt, chapter, head, etc.
BDEPEND="
	dev-lang/perl
	doc? (
		app-text/ghostscript-gpl
		dev-perl/Font-TTF
		dev-perl/Sort-Versions
		media-fonts/source-code-pro
		media-fonts/source-sans:3
		virtual/perl-File-Spec
	)
"

S=${WORKDIR}/${P/_}

PATCHES=(
	"${FILESDIR}"/${PN}-2.15-bsd-cp-doc.patch
)

src_prepare() {
	default

	# https://bugs.gentoo.org/870214
	# During the split of media-fonts/source-pro, the source-sans files
	# were renamed. Currently depend on media-fonts/source-sans:3 which works
	# with this sed.
	sed -i 's/SourceSansPro/SourceSans3/g' doc/psfonts.ph || die
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default
	emake DESTDIR="${D}" install_rdf $(usex doc install_doc '')
}
