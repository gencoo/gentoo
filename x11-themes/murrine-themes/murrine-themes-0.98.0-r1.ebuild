# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Themes for the Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.cimitan.com/murrine/"
URI_PREFIX="http://www.cimitan.com/murrine/files"
SRC_URI="${URI_PREFIX}/MurrinaAquaIsh.tar.bz2
	${URI_PREFIX}/MurrinaBlu-0.32.tar.gz
	${URI_PREFIX}/MurrinaCandido.tar.gz
	${URI_PREFIX}/MurrinaGilouche.tar.bz2
	${URI_PREFIX}/MurrinaFancyCandy.tar.bz2
	${URI_PREFIX}/MurrinaLoveGray.tar.bz2
	${URI_PREFIX}/MurrineThemePack.tar.bz2
	${URI_PREFIX}/MurrinaVerdeOlivo.tar.bz2
	${URI_PREFIX}/MurrineXfwm.tar.bz2
	${URI_PREFIX}/MurrinaCream.tar.gz
	${URI_PREFIX}/NOX-svn-r22.tar.gz
	http://gnome-look.org/CONTENT/content-files/93558-Murreza.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv x86"

RDEPEND=">=x11-themes/gtk-engines-murrine-0.98.0"

src_install() {
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Murrin* "${WORKDIR}"/NOX*

	cd "${WORKDIR}"/Murreza || die
	doins -r Murreza*
}
