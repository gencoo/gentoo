# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

: ${CMAKE_MAKEFILE_GENERATOR:=emake}
inherit cmake flag-o-matic

MY_PV="${PV/_rc/-rc.}"
MY_P="SuperTux-v${MY_PV}-Source"

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="https://supertux.org/"
SRC_URI="https://github.com/SuperTux/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug"

# =media-libs/libsdl2-2.0.14-r0 can cause supertux binary to move entire
# content of ${HOME} to ${HOME}/.local/share/supertux2/
# DO NOT REMOVE THIS BLOCKER!!! See bug #764959
RDEPEND="
	!=media-libs/libsdl2-2.0.14-r0
	>=dev-games/physfs-3.0
	dev-libs/boost:=[nls]
	media-libs/freetype
	media-libs/glew:=
	media-libs/libpng:0=
	>=media-libs/libsdl2-2.0.1[joystick,video]
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-tinygettext.patch
	"${FILESDIR}"/${PN}-0.6.0-{license,icon,obstack}.patch
)

src_prepare() {
	cmake_src_prepare

	# This is not a developer release so switch the logo to the non-dev one.
	sed -e 's@logo_dev@logo@' \
		-i data/images/objects/logo/logo.sprite || die
}

src_configure() {
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DWERROR=OFF
		-DINSTALL_SUBDIR_BIN=bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		-DINSTALL_SUBDIR_SHARE=share/${PN}2
		-DENABLE_SQDBG="$(usex debug)"
		-DUSE_SYSTEM_PHYSFS=ON
	)
	cmake_src_configure
}
