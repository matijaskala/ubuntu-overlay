# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils gnome2-utils

DESCRIPTION="Indicator showing session management, status and user switching used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-session"
MY_PV="${PV/_pre/+15.04.}"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+help"
S=${WORKDIR}/${PN}-${MY_PV}
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	app-admin/system-config-printer-gnome
	dev-cpp/gtest
	>=dev-libs/glib-2.36
	dev-libs/libappindicator
	dev-libs/libindicate-qt
	help? ( gnome-extra/yelp
		gnome-extra/gnome-user-docs )"
DEPEND="$RDEPEND"

src_prepare() {
	# Fix schema errors and sandbox violations #
	epatch "${FILESDIR}/sandbox_violations_fix.diff"

	if ! use help || has nodoc ${FEATURES}; then
		sed -n '/indicator.help/{s|^|//|};p' \
			-i src/service.c
	else
		sed -e 's:menu, help_label:menu, _("Unity Help"):g' \
			-i src/service.c
		sed -e 's:yelp:yelp help\:ubuntu-help:g' \
			-i src/backend-dbus/actions.c
	fi

	# Make indicator start using XDG autostart #
	sed -e '/NotShowIn=/d' \
		-i data/indicator-session.desktop.in
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove upstart jobs as we use XDG autostart desktop files to spawn indicators #
	rm -rf "${ED}usr/share/upstart"
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
