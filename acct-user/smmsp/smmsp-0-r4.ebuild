# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for sendmail daemon"
ACCT_USER_ID=209
ACCT_USER_GROUPS=( smmsp )

acct-user_add_deps
