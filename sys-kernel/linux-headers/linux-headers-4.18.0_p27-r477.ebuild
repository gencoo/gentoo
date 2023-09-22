# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

subrelease="$(ver_cut 5).1"
DPREFIX="${subrelease}."
DSUFFIX="_8"

inherit unpacker rhel8

SRC_URI="amd64? ( ${BIN_URI} )
	arm64? (
		https://dl.rockylinux.org/pub/rocky/8/BaseOS/aarch64/os/Packages/${DIST_PRE_SUF_CATEGORY}.aarch64.rpm
	)"

KEYWORDS="amd64 arm64 ~ppc64 ~s390"
SLOT="0"

src_install() {
	rhel_bin_install
}
