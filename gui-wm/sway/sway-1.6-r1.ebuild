# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc64 x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="elogind +man +swaybar +swaybg +swayidle +swaylock +swaymsg +swaynag seatd systemd tray wallpapers X"
REQUIRED_USE="?? ( elogind systemd )
	tray? ( || ( elogind seatd systemd ) )"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	dev-libs/libpcre
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	media-libs/mesa[gles2,libglvnd(+)]
	elogind? ( >=sys-auth/elogind-239 )
	swaybar? ( x11-libs/gdk-pixbuf:2 )
	swaybg? ( gui-apps/swaybg )
	swayidle? ( gui-apps/swayidle )
	swaylock? ( gui-apps/swaylock )
	systemd? ( >=sys-apps/systemd-239[policykit] )
	wallpapers? ( x11-libs/gdk-pixbuf:2[jpeg] )
	X? ( x11-libs/libxcb:0= )
"
if [[ ${PV} == 9999 ]]; then
	DEPEND+="~gui-libs/wlroots-9999:=[elogind=,seatd=,systemd=,X=]"
else
	DEPEND+="
		>=gui-libs/wlroots-0.13:=[elogind=,seatd=,systemd=,X=]
		<gui-libs/wlroots-0.14:=[elogind=,seatd=,systemd=,X=]
	"
fi
RDEPEND="
	x11-misc/xkeyboard-config
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.53.0
	virtual/pkgconfig
"
if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( >=app-text/scdoc-1.9.3 )"
fi

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -e "/sway-bar.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaybar/d" -i meson.build || die
	use swaymsg || sed -e "s/subdir('swaymsg')//g" -e "/swaymsg.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaymsg/d" -i meson.build || die
	use swaynag || sed -e "s/subdir('swaynag')//g" -e "/swaynag.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaynag/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		-Dtray=$(usex tray enabled disabled)
		-Dxwayland=$(usex X enabled disabled)
		$(meson_use wallpapers default-wallpaper)
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
		-Dwerror=false
	)

	if use swaybar; then
		emesonargs+=( -Dgdk-pixbuf=enabled )
	else
		emesonargs+=( -Dgdk-pixbuf=disabled )
	fi

	meson_src_configure
}

pkg_preinst() {
	if ! use systemd && ! use elogind && ! use seatd; then
		fowners root:0 /usr/bin/sway
		fperms 4511 /usr/bin/sway
	fi
}

pkg_postinst() {
	if ! use systemd && ! use elogind && ! use seatd; then
		elog ""
		elog "If your system does not set the XDG_RUNTIME_DIR environment"
		elog "variable, you must set it manually to run Sway. See wiki"
		elog "for details: https://wiki.gentoo.org/wiki/Sway"
	fi
}
