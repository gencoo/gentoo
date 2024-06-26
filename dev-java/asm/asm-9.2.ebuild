# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.ow2.asm:asm:9.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bytecode manipulation framework for Java"
HOMEPAGE="https://asm.ow2.io"
MY_P="ASM_${PV//./_}"
SRC_URI="https://gitlab.ow2.org/asm/asm/-/archive/${MY_P}/asm-${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="9"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
RESTRICT="test"

CDEPEND=""
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="asm-${MY_P}/${PN}/src/main/java"
