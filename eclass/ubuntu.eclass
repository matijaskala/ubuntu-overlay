# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

: ${UPN:="${PN}"}
: ${UPV:="${PV}"}
: ${SRC_SUFFIX:="orig.tar.gz"}

if [[ -z ${UVER_PREFIX} ]]
then
	UVER_PREFIX=${UPV##*_p}
	[[ ${UVER_PREFIX} == ${UPV} ]] && UVER_PREFIX=
	if [[ -n ${UVER_PREFIX} ]]
	then
		UPV=${UPV%_p*}
		[[ ${UPV} == *14.04* ]] && UVER_RELEASE=14.04
		[[ ${UPV} == *14.10* ]] && UVER_RELEASE=14.10
		[[ ${UPV} == *15.04* ]] && UVER_RELEASE=15.04
		[[ ${UPV} == *15.10* ]] && UVER_RELEASE=15.10
		[[ ${UPV} == *16.04* ]] && UVER_RELEASE=16.04
		[[ ${UPV} == *.14.04 ]] && UPV=${UPV%.14.04}
		[[ ${UPV} == *.14.10 ]] && UPV=${UPV%.14.10}
		[[ ${UPV} == *.15.04 ]] && UPV=${UPV%.15.04}
		[[ ${UPV} == *.15.10 ]] && UPV=${UPV%.15.10}
		[[ ${UPV} == *.16.04 ]] && UPV=${UPV%.16.04}
		if [[ -n ${UVER_RELEASE} ]]
		then
			UVER_PREFIX="+${UVER_RELEASE}.${UVER_PREFIX}"
		else
			UVER_PREFIX="+${UVER_PREFIX}"
		fi
	fi
fi

UURL="https://launchpad.net/ubuntu/+archive/primary/+files/"
SRC_URI="${UURL}${UPN}_${UPV}${UVER_PREFIX}.${SRC_SUFFIX}"
RESTRICT="mirror"

S="${WORKDIR}/${UPN}-${UPV}${UVER_PREFIX}"