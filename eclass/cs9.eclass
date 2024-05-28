# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

if [[ -z ${_CS_ECLASS} ]] ; then
_CS_ECLASS=1
DEPEND="dev-util/rpmdevtools"

	EGIT_BRANCH=c9s
	EGIT_CHECKOUT_DIR=${EGIT_CHECKOUT_DIR:-${EGIT_BRANCH}}
	CENTOS_GIT_REPO_URI="https://gitlab.com/redhat/centos-stream/rpms"
	EGIT_REPO_URI="${CENTOS_GIT_REPO_URI}/${MY_PN:-${PN}}.git"

if [[ -z ${_RPMBUILD_ECLASS} ]] ; then
	inherit git-r3 rpmbuild
fi

fi
