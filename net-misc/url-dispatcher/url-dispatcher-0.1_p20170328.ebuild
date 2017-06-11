# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Service to allow sending of URLs and get handlers started, used by the Unity desktop"
HOMEPAGE="https://launchpad.net/url-dispatcher"
MY_PV="${PV/_p/+17.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
S=${WORKDIR}
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:="
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/ubuntu-app-launch
	sys-apps/dbus
	test? ( dev-util/dbus-test-runner )"

src_configure() {
	! use test && \
		mycmakeargs+=(-Denable_tests=OFF)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Remove upstart jobs as we use xsession based scripts in /etc/X11/xinit/xinitrc.d/ #
	rm -rf "${ED}usr/share/upstart"

	insinto /etc/xdg/autostart
	doins "${FILESDIR}/url-dispatcher.desktop"
	insinto /usr/share/dbus-1/services/
	doins "${FILESDIR}/com.canonical.URLDispatcher.service"
}