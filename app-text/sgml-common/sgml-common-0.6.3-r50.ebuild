# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix sgml-catalog-r1 rhel8

DESCRIPTION="Base ISO character entities and utilities for SGML"
HOMEPAGE="https://www.iso.org/standard/16387.html"

# install-catalog is GPL
LICENSE="FDL-1.1+ GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~s390"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-prefix.patch )

src_prepare() {
	# We use a hacked version of install-catalog that supports the ROOT
	# variable, puts quotes around the CATALOG files, and can be prefixed.
	cp "${FILESDIR}/${P}-install-catalog.in" "${S}/bin/install-catalog.in" \
		|| die "Copy of install-catalog.in failed"

	default
	eprefixify bin/install-catalog.in bin/sgmlwhich config/sgml.conf
}

src_install() {
	rhel_src_install

	# own /etc/sgml/catalog
	insinto /etc/sgml
	newins - catalog <<<''
	newins - sgml-ent.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/sgml-iso-entities-8879.1986/catalog"
	EOF
	newins - sgml-docbook.cat <<-EOF
		CATALOG "${EPREFIX}/etc/sgml/sgml-ent.cat"
	EOF
}

pkg_preinst() {
	# preserve old files
	local f
	for f in /etc/sgml/{catalog,sgml-docbook.cat}; do
		if [[ -s ${EROOT}${f} ]]; then
			cp "${EROOT}${f}" "${ED}${f}" || die
		fi
	done

	# and back them up in case postrm killed them
	for f in sgml-ent.cat sgml-docbook.cat; do
		cp "${ED}/etc/sgml/${f}" "${T}" || die
	done
}

pkg_postinst() {
	# restore backed up files if necessary
	for f in sgml-ent.cat sgml-docbook.cat; do
		if ! cmp -s "${T}/${f}" "${EROOT}/etc/sgml/${f}"; then
			cp "${T}/${f}" "${EROOT}"/etc/sgml/ || die
		fi
	done

	# re-append sgml-ent.cat if necessary
	if ! grep -q -s sgml-ent.cat "${EROOT}/etc/sgml/sgml-docbook.cat"; then
		ebegin "Adding sgml-ent.cat to /etc/sgml/sgml-docbook.cat"
		cat >> "${EROOT}/etc/sgml/sgml-docbook.cat" <<-EOF
			CATALOG "${EPREFIX}/etc/sgml/sgml-ent.cat"
		EOF
		eend ${?}
	fi

	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		ebegin "Removing sgml-ent.cat from /etc/sgml/sgml-docbook.cat"
		sed -i -e '/sgml-ent\.cat/d' \
			"${EROOT}"/etc/sgml/sgml-docbook.cat
		eend ${?}
		if [[ ! -s ${EROOT}/etc/sgml/sgml-docbook.cat ]]; then
			rm -f "${EROOT}"/etc/sgml/sgml-docbook.cat
		fi
	fi

	sgml-catalog-r1_pkg_postrm
}
