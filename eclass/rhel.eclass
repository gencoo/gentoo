# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rhel.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: convenience class for extracting Red Hat Enterprise Linux Series RPMs

EXPORT_FUNCTIONS src_unpack

if [[ -z ${_RHEL_ECLASS} ]] ; then
_RHEL_ECLASS=1

inherit macros

if [[ ${PV} == *8888 ]]; then
	inherit git-r3
	CENTOS_GIT_REPO_URI="https://gitlab.com/redhat/centos-stream/src"
	EGIT_REPO_URI="${CENTOS_GIT_REPO_URI}/${PN}.git"
	S="${WORKDIR}/${P}"
else
	inherit rpm
	if [ -z ${MIRROR} ] ; then MIRROR="https://vault.centos.org"; fi
	DIST=".el8"
	RELEASE="8-stream"
	REPO_URI="${MIRROR}/${RELEASE}/${REPO:-BaseOS}/Source/SPackages"

	if [ -z ${MY_PF} ] ; then
		MY_PR=${PVR##*r}

		if [ ${CATEGORY} == "dev-python" ] ; then
			[[ ${PN} == lxml ]] ||  inherit rhel-9
			case ${PN} in
				Babel | pytz | numpy | pyparsing | pyxdg | dbus-python | pycairo \
				) MY_PF=${P,,}-${MY_PR} ;;
				pyyaml ) MY_PF=${P/pyyaml/PyYAML}-${MY_PR} ;;
				cython ) MY_PF=${P/c/C}-${MY_PR} ;;
				jinja ) MY_P=${P/-/2-}; MY_PF=python-${MY_P}-${MY_PR}; S="${WORKDIR}/${MY_P/j/J}" ;;
				pygobject ) MY_P=${P/-/3-}; MY_PF=${MY_P}-${MY_PR} ;;
				publicsuffix ) MY_P=${P/-2./-list-}; MY_PF=${MY_P}-${MY_PR}; S="${WORKDIR}/${MY_P}" ;;
				*) MY_PF=python-${P,,}-${MY_PR} ;;
			esac
		elif [ ${CATEGORY} == "dev-perl" ] || [ ${CATEGORY} == "perl-core" ] ; then
			inherit rhel-9
			[[ -n "${DIST_VERSION}" ]] && MY_PV=${DIST_VERSION}
			[[ -n "${MODULE_VERSION}" ]] && MY_PV=${MODULE_VERSION}
			MY_PF=perl-${PN}-${MY_PV}-${MY_PR}
			[[ ${PN} == Locale-gettext ]] && MY_PF=perl-${PN/Locale-}-${DIST_VERSION}-${MY_PR}
		else
			case ${PN} in
				xz-utils ) MY_P="${PN/-utils}-${PV/_}"; MY_PF=${MY_P}-${MY_PR} ;;
				libpcre* ) MY_P=${P/lib}; MY_PF=${MY_P}-${MY_PR} ;;
				iproute2 ) MY_PF=${P/2}-${MY_PR} ;;
				shadow ) MY_PF=${P/-/-utils-}-${MY_PR} ;;
				thin-provisioning-tools ) MY_PF=device-mapper-persistent-data-${PV}-${MY_PR} ;;
				xorg-proto ) MY_PF=${PN/-/-x11-}-devel-${PV}-${MY_PR} ;;
				webkit-gtk ) MY_PF=${P/-gtk/2gtk3}-${MY_PR} ;;
				ninja) MY_PF=${P/-/-build-}-${MY_PR} ;;
				procps ) MY_P=${P/-/-ng-}; MY_PF=${MY_P}-${MY_PR} ;;
				openssh ) PARCH=${P/_}; MY_PF=${PARCH}-${MY_PR} ;;
				lcms | gnupg | grub | libnl | glib | librsvg) \
				[[ ${PN} == libnl ]] && inherit rhel-9; MY_P=${P/-/$(ver_cut 1)-}; MY_PF=${MY_P}-${MY_PR} ;;
				libnsl ) MY_P=${P/-/2-}; MY_PF=${MY_P}-${MY_PR} ;;
				procps ) MY_P=${P/-/-x11-}; MY_PF=${MY_P}-${MY_PR} ;;
				mpc ) MY_PF=lib${P}-${MY_PR}.1 ;;
				docbook-xsl-stylesheets ) MY_PF=docbook-style-xsl-${PV}-${MY_PR} ;;
				gtk-doc-am ) MY_PF=${P/-am}-${MY_PR} ;;
				e2fsprogs-libs ) MY_PF=${P/-libs}-${MY_PR} ;;
				mit-krb5 ) MY_PF=${P/mit-}-${MY_PR} ;;
				perl | dbus | gpgme | libxcrypt | ipset | jansson | pinentry) inherit rhel-9 ; MY_PF=${P}-${MY_PR} ;;
				go ) MY_PF=${P/-/lang-}-${MY_PR} ;;
				cunit ) MY_PF=${P/cu/CU}-${MY_PR} ;;
				gtk+ ) MY_P=${P/+/$(ver_cut 1)}; MY_PF=${MY_P}-${MY_PR} ;;
				libusb ) MY_PF=${P/-/x-}-${MY_PR} ;;
				python ) MY_PR=${PVR##*p}; MY_P=${P%_p*}; MY_PF=${MY_P/-/3$(ver_cut 2)-}-${MY_PR} ;;
				*) MY_PF=${P}-${MY_PR} ;;
			esac
		fi
	fi

	SRC_URI="${REPO_URI}/${MY_PF}${DIST}.src.rpm"
fi

rpm_clean() {
	# delete everything
	rm -f *.patch
	local a
	for a in *.tar.{gz,bz2,xz} *.t{gz,bz2,xz,pxz} *.zip *.ZIP ; do
		rm -f "${a}"
	done
}

# @FUNCTION: rhel_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified Red Hat Enterprise Linux Series rpms like the unpack() function.
rhel_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}

	local a
	for a in ${A} ; do
		case ${a} in
		*.rpm) [[ ${a} =~ ".rpm" ]] && 	rpm_unpack "${a}" ;;
		*)     unpack "${a}" ;;
		esac
	done

	RPMBUILD=$HOME/rpmbuild
	mkdir -p $RPMBUILD
	ln -s $WORKDIR $RPMBUILD/SOURCES
	ln -s $WORKDIR $RPMBUILD/BUILD
}

# @FUNCTION: srcrhel_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified rpms like the unpack() function as well
# as any archives that it might contain.  Note that the secondary archive
# unpack isn't perfect in that it simply unpacks all archives in the working
# directory (with the assumption that there weren't any to start with).
srcrhel_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}
	rhel_unpack "$@"

	# no .src.rpm files, then nothing to do
	[[ "$* " != *".src.rpm " ]] && return 0

	FIND_FILE="${WORKDIR}/*.spec"
	FIND_STR="pypi_source"
	if [ `grep -c "$FIND_STR" $FIND_FILE` -ne '0' ] ;then
		echo -e "The spec File Has\c"
		echo -e "\033[33m $FIND_STR \033[0m\c"
		echo "Skipp rpm build through %prep..."
		unpack ${WORKDIR}/*.tar.*
		return 0
	fi

	eshopts_push -s nullglob

	sed -i "/%{gpgverify}/d" ${WORKDIR}/*.spec
	sed -i "/#!%{__python3}/d" ${WORKDIR}/*.spec
	sed -i "/@exec_prefix@/d" ${WORKDIR}/*.spec
	sed -i "/py_provides/d" ${WORKDIR}/*.spec
 
	rpmbuild -bp $WORKDIR/*.spec --nodeps

	eshopts_pop

	return 0
}

# @FUNCTION: rhel_src_unpack
# @DESCRIPTION:
# Automatically unpack all archives in ${A} including rpms.  If one of the
# archives in a source rpm, then the sub archives will be unpacked as well.
rhel_src_unpack() {
	if [[ ${PV} == *8888 ]]; then
		git-r3_src_unpack
		return 0
	fi
	local a
	for a in ${A} ; do
		case ${a} in
		*.rpm) [[ ${a} =~ ".rpm" ]] && srcrhel_unpack "${a}" ;;
		*)     unpack "${a}" ;;
		esac
	done
}

# @FUNCTION: rhel_src_install
# @DESCRIPTION:

rhel_src_install() {
	sed -i '/rm -rf $RPM_BUILD_ROOT/d' ${WORKDIR}/*.spec

	rpmbuild --short-circuit -bi $WORKDIR/*.spec --nodeps --rmsource --nocheck --nodebuginfo --buildroot=$D
}

fi
