# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="Lab wraps Git or Hub, making it simple to interact with repositories on GitLab"
HOMEPAGE="https://zaquestion.github.io/lab/"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/DATA-DOG/go-sqlmock v1.3.3/go.mod"
	"github.com/avast/retry-go v0.0.0-20180319101611-5469272a8171"
	"github.com/avast/retry-go v0.0.0-20180319101611-5469272a8171/go.mod"
	"github.com/cpuguy83/go-md2man v1.0.8"
	"github.com/cpuguy83/go-md2man v1.0.8/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/derekparker/delve v1.1.0"
	"github.com/derekparker/delve v1.1.0/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/gdamore/encoding v0.0.0-20151215212835-b23993cbb635"
	"github.com/gdamore/encoding v0.0.0-20151215212835-b23993cbb635/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/gdamore/tcell v0.0.0-20180416163743-2f258105ca8c"
	"github.com/gdamore/tcell v0.0.0-20180416163743-2f258105ca8c/go.mod"
	"github.com/gdamore/tcell v1.1.2"
	"github.com/gdamore/tcell v1.1.2/go.mod"
	"github.com/gdamore/tcell v1.1.4"
	"github.com/gdamore/tcell v1.1.4/go.mod"
	"github.com/gdamore/tcell v1.3.0"
	"github.com/gdamore/tcell v1.3.0/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/google/go-querystring v0.0.0-20170111101155-53e6ce116135"
	"github.com/google/go-querystring v0.0.0-20170111101155-53e6ce116135/go.mod"
	"github.com/google/go-querystring v1.0.0"
	"github.com/google/go-querystring v1.0.0/go.mod"
	"github.com/gopherjs/gopherjs v0.0.0-20181103185306-d547d1d9531e"
	"github.com/gopherjs/gopherjs v0.0.0-20181103185306-d547d1d9531e/go.mod"
	"github.com/hashicorp/hcl v0.0.0-20180404174102-ef8a98b0bbce"
	"github.com/hashicorp/hcl v0.0.0-20180404174102-ef8a98b0bbce/go.mod"
	"github.com/hpcloud/tail v1.0.0"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/jtolds/gls v4.2.1+incompatible"
	"github.com/jtolds/gls v4.2.1+incompatible/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/lucasb-eyer/go-colorful v0.0.0-20170903184257-231272389856"
	"github.com/lucasb-eyer/go-colorful v0.0.0-20170903184257-231272389856/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.2"
	"github.com/lucasb-eyer/go-colorful v1.0.2/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/lunixbochs/vtclean v0.0.0-20180621232353-2d01aacdc34a"
	"github.com/lunixbochs/vtclean v0.0.0-20180621232353-2d01aacdc34a/go.mod"
	"github.com/magiconair/properties v1.7.6"
	"github.com/magiconair/properties v1.7.6/go.mod"
	"github.com/mattn/go-runewidth v0.0.2"
	"github.com/mattn/go-runewidth v0.0.2/go.mod"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mattn/go-runewidth v0.0.4/go.mod"
	"github.com/mattn/go-runewidth v0.0.7"
	"github.com/mattn/go-runewidth v0.0.7/go.mod"
	"github.com/mitchellh/mapstructure v0.0.0-20180220230111-00c29f56e238"
	"github.com/mitchellh/mapstructure v0.0.0-20180220230111-00c29f56e238/go.mod"
	"github.com/onsi/ginkgo v1.6.0"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/gomega v1.4.3"
	"github.com/onsi/gomega v1.4.3/go.mod"
	"github.com/pelletier/go-toml v1.1.0"
	"github.com/pelletier/go-toml v1.1.0/go.mod"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/tview v0.0.0-20180419193403-f855bee0205c"
	"github.com/rivo/tview v0.0.0-20180419193403-f855bee0205c/go.mod"
	"github.com/rivo/tview v0.0.0-20190721135419-23dc8a0944e4"
	"github.com/rivo/tview v0.0.0-20190721135419-23dc8a0944e4/go.mod"
	"github.com/rivo/tview v0.0.0-20191129065140-82b05c9fb329"
	"github.com/rivo/tview v0.0.0-20191129065140-82b05c9fb329/go.mod"
	"github.com/rivo/uniseg v0.0.0-20190513083848-b9f5b9457d44"
	"github.com/rivo/uniseg v0.0.0-20190513083848-b9f5b9457d44/go.mod"
	"github.com/rivo/uniseg v0.1.0"
	"github.com/rivo/uniseg v0.1.0/go.mod"
	"github.com/rsteube/cobra v0.0.1-zsh-completion-custom"
	"github.com/rsteube/cobra v0.0.1-zsh-completion-custom/go.mod"
	"github.com/russross/blackfriday v1.5.1"
	"github.com/russross/blackfriday v1.5.1/go.mod"
	"github.com/sirupsen/logrus v1.2.0"
	"github.com/sirupsen/logrus v1.2.0/go.mod"
	"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d"
	"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d/go.mod"
	"github.com/smartystreets/goconvey v0.0.0-20181108003508-044398e4856c"
	"github.com/smartystreets/goconvey v0.0.0-20181108003508-044398e4856c/go.mod"
	"github.com/spf13/afero v1.1.0"
	"github.com/spf13/afero v1.1.0/go.mod"
	"github.com/spf13/cast v1.2.0"
	"github.com/spf13/cast v1.2.0/go.mod"
	"github.com/spf13/cobra v0.0.0-20180412120829-615425954c3b"
	"github.com/spf13/cobra v0.0.0-20180412120829-615425954c3b/go.mod"
	"github.com/spf13/jwalterweatherman v0.0.0-20180109140146-7c0cea34c8ec"
	"github.com/spf13/jwalterweatherman v0.0.0-20180109140146-7c0cea34c8ec/go.mod"
	"github.com/spf13/pflag v1.0.1"
	"github.com/spf13/pflag v1.0.1/go.mod"
	"github.com/spf13/viper v0.0.0-20180507071007-15738813a09d"
	"github.com/spf13/viper v0.0.0-20180507071007-15738813a09d/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.1"
	"github.com/stretchr/testify v1.2.1/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/tcnksm/go-gitconfig v0.1.2"
	"github.com/tcnksm/go-gitconfig v0.1.2/go.mod"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad/go.mod"
	"github.com/xanzy/go-gitlab v0.0.0-20180921132519-8d21e61ce4a9"
	"github.com/xanzy/go-gitlab v0.0.0-20180921132519-8d21e61ce4a9/go.mod"
	"github.com/xanzy/go-gitlab v0.11.3"
	"github.com/xanzy/go-gitlab v0.11.3/go.mod"
	"github.com/xanzy/go-gitlab v0.12.2"
	"github.com/xanzy/go-gitlab v0.12.2/go.mod"
	"github.com/xanzy/go-gitlab v0.12.3-0.20181228114601-7bc4155e8bf8"
	"github.com/xanzy/go-gitlab v0.12.3-0.20181228114601-7bc4155e8bf8/go.mod"
	"golang.org/x/arch v0.0.0-20181203225421-5a4828bb7045"
	"golang.org/x/arch v0.0.0-20181203225421-5a4828bb7045/go.mod"
	"golang.org/x/crypto v0.0.0-20180420171155-e73bf333ef89"
	"golang.org/x/crypto v0.0.0-20180420171155-e73bf333ef89/go.mod"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20181108082009-03003ca0c849"
	"golang.org/x/net v0.0.0-20181108082009-03003ca0c849/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180724155351-3d292e4d0cdc"
	"golang.org/x/oauth2 v0.0.0-20180724155351-3d292e4d0cdc/go.mod"
	"golang.org/x/oauth2 v0.0.0-20181106182150-f42d05182288"
	"golang.org/x/oauth2 v0.0.0-20181106182150-f42d05182288/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
	"golang.org/x/sys v0.0.0-20191018095205-727590c5006e/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20191210023423-ac6580df4449"
	"golang.org/x/sys v0.0.0-20191210023423-ac6580df4449/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20190107155254-e063def13b29"
	"golang.org/x/tools v0.0.0-20190107155254-e063def13b29/go.mod"
	"golang.org/x/tools v0.0.0-20191212224101-0f69de236bb7"
	"golang.org/x/tools v0.0.0-20191212224101-0f69de236bb7/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"google.golang.org/appengine v1.1.0"
	"google.golang.org/appengine v1.1.0/go.mod"
	"google.golang.org/appengine v1.3.0/go.mod"
	"gopkg.in/DATA-DOG/go-sqlmock.v1 v1.3.0"
	"gopkg.in/DATA-DOG/go-sqlmock.v1 v1.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/zaquestion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="dev-vcs/git"

RESTRICT+=" test" #tries to write to /src and fetch from gitlab

src_compile() {
	emake VERSION="${PV}"
	mkdir -v "${T}/comp" || die
	./lab completion bash > "${T}/comp/lab" || die
	./lab completion zsh > "${T}/comp/_lab" || die
}

src_install() {
	dobin lab
	einstalldocs
	dobashcomp "${T}/comp/lab"
	insinto /usr/share/zsh/site-functions
	doins "${T}/comp/_lab"
}
