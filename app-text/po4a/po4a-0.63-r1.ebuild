# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PLOCALES="af ar ca cs da de eo es et eu fr hr hu id it ja kn ko nb nl pl pt pt_BR ru sl sr_Cyrl sv uk vi zh_CN zh_HK"

inherit perl-module plocale rhel8-p

DESCRIPTION="Tools to ease the translation of documentation"
HOMEPAGE="https://po4a.org/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/opensp
	dev-libs/libxslt
	dev-perl/Locale-gettext
	dev-perl/Pod-Parser
	dev-perl/SGMLSpm
	dev-perl/TermReadKey
	dev-perl/Text-WrapI18N
	dev-perl/Unicode-LineBreak
	dev-perl/YAML-Tiny
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-perl/Module-Build
	test? (
		app-text/docbook-sgml-dtd:4.1
		dev-perl/Test-Pod
		virtual/latex-base
	)"

PATCHES=( "${FILESDIR}"/${PN}-man.patch )

DIST_TEST="do"

src_prepare() {
	plocale_find_changes "${S}/po/bin" '' '.po'

	rm_locale() {
		PERL_RM_FILES+=( po/{bin,pod}/${1}.po )
	}
	plocale_for_each_disabled_locale rm_locale

	perl-module_src_prepare

	export PO4AFLAGS="-v -v -v"
	LANG=C.utf8
}
