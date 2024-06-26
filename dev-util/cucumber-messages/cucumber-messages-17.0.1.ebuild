# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffer messages for Cucumber's inter-process communication"
HOMEPAGE="https://github.com/cucumber/cucumber-messages-ruby#readme"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
SLOT="$(ver_cut 1)"
