# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit optfeature python-single-r1 toolchain-funcs xdg

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"
else
	SRC_URI="https://github.com/kovidgoyal/kitty/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Fast, feature-rich, GPU-based terminal"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+X debug test transfer wayland"
REQUIRED_USE="
	|| ( X wayland )
	${PYTHON_REQUIRED_USE}"
RESTRICT="!X? ( test ) !test? ( test ) !transfer? ( test ) !wayland? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libglvnd[X?]
	media-libs/libpng:=
	sys-apps/dbus
	sys-libs/zlib:=
	x11-libs/libxkbcommon[X?]
	x11-misc/xkeyboard-config
	~x11-terms/kitty-shell-integration-${PV}
	~x11-terms/kitty-terminfo-${PV}
	X? ( x11-libs/libX11 )
	transfer? ( net-libs/librsync:= )
	wayland? ( dev-libs/wayland )"
DEPEND="
	${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
	)
	wayland? ( dev-libs/wayland-protocols )"
BDEPEND="
	${PYTHON_DEPS}
	sys-libs/ncurses
	virtual/pkgconfig
	test? ( $(python_gen_cond_dep 'dev-python/pillow[${PYTHON_USEDEP}]') )
	wayland? ( dev-util/wayland-scanner )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.23.1-flags.patch
)

src_prepare() {
	default

	sed -i "s/'x11 wayland'/'$(usev X x11) $(usev wayland)'/" setup.py || die

	if use !transfer; then
		sed -i 's/rs_cflag =/& []#/;/files.*rsync/d' setup.py || die
		rm -r kittens/transfer || die
	fi

	# --shell-integration="enabled no-rc" is the intended way to set
	# no-rc by default, but setup.py's replacer currently fails
	# https://github.com/kovidgoyal/kitty/issues/4434
	sed -i "/shell_integration:/s/'enabled'/&,'no-rc'/" kitty/options/types.py || die

	# test relies on 'who' command which typically works but have 1 VM
	# where it didn't only under portage/sandbox, needs investigation but
	# disable for now
	rm kitty_tests/utmp.py || die

	# skip docs for live version
	[[ ${PV} != 9999 ]] || sed -i '/exists.*_build/,/docs(ddir)/d' setup.py || die
}

src_compile() {
	tc-export CC
	export PKGCONFIG_EXE=$(tc-getPKG_CONFIG)

	local setup=(
		${EPYTHON} setup.py linux-package
		--disable-link-time-optimization
		--ignore-compiler-warnings
		--libdir-name=$(get_libdir)
		--update-check-interval=0
		--verbose
		$(usev debug --debug)
	)

	echo "${setup[*]}"
	"${setup[@]}" || die "setup.py failed to compile ${PN}"

	[[ ${PV} == 9999 ]] || mv linux-package/share/doc/{${PN},${PF}} || die
	rm -r linux-package/share/terminfo || die
}

src_test() {
	PATH=linux-package/bin:${PATH} KITTY_CONFIG_DIRECTORY=${T} \
		${EPYTHON} test.py || die
}

src_install() {
	insinto /usr
	doins -r linux-package/.

	fperms +x /usr/bin/kitty
}

pkg_postinst() {
	xdg_icon_cache_update

	optfeature "in-terminal image display with kitty icat" media-gfx/imagemagick
	optfeature "audio-based terminal bell support" media-libs/libcanberra
}
