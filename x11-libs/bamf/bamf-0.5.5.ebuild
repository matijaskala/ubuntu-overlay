# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vala

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV/_p/+16.10.}.orig.tar.gz"
SRC_URI="https://launchpad.net/bamf/0.5/${PV}/+download/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/gobject-introspection
	gnome-base/libgtop:2
	>=x11-libs/libwnck-3.4.7:3"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	gnome-base/gnome-common
	virtual/pkgconfig
	$(vala_depend)"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/disable-python.patch

	vala_src_prepare
	export VALA_API_GEN="${VAPIGEN}"

	eautoreconf
}

src_configure() {
	econf \
		--enable-export-actions-menu \
		--enable-introspection || die
}
