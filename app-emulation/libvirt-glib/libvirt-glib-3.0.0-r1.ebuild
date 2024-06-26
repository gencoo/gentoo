# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_LA_PUNT="yes"

inherit gnome2 vala rhel8-a

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="http://libvirt.org/git/?p=libvirt-glib.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="+introspection nls vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-1.2.6:=
	>=dev-libs/glib-2.38.0:2
	introspection? ( >=dev-libs/gobject-introspection-1.36.0:= )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-test-coverage \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable vala)
}
