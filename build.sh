#!/bin/bash
#
# Copyright 2014 Range Networks, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# See the COPYING file in the main directory for details.
#

source $(dirname $0)/common.source

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo "# - missing $@, installing dependency"
		sudo apt-get install $@ -y
	fi
}


echo "# checking for a compatible build host"
if hash lsb_release 2>/dev/null; then
	ubuntu=`lsb_release -r -s`
	if [ $ubuntu != "12.04" ]; then
		echo "# - WARNING : dev-tools is currently only tested on Ubuntu 12.04, YMMV. Please open an issue if you've used it successfully on another version of Ubuntu."
	else
		echo "# - fully supported host detected: Ubuntu 12.04"
	fi
else
	echo "# - ERROR : Sorry, dev-tools currently only supports Ubuntu as the host OS. Please open an issue for your desired host."
	echo "# - exiting"
	exit 1
fi
echo "#"

echo "# checking build dependencies"
installIfMissing autoconf
installIfMissing automake
installIfMissing libtool
installIfMissing debhelper
installIfMissing sqlite3
installIfMissing libsqlite3-dev
installIfMissing libusb-1.0-0
installIfMissing libusb-1.0-0-dev
installIfMissing libortp-dev
installIfMissing libortp8
installIfMissing libosip2-dev
installIfMissing libreadline-dev
installIfMissing libncurses5
installIfMissing libncurses5-dev
installIfMissing pkg-config
# libsqliteodbc deps
installIfMissing cdbs
installIfMissing libsqlite0-dev
# asterisk deps
installIfMissing unixodbc
installIfMissing unixodbc-dev
installIfMissing libssl-dev
installIfMissing libsrtp0
installIfMissing libsrtp0-dev
echo "# - done"
echo

BUILDNAME="BUILD-`date +"%Y-%m-%d--%H-%M-%S"`"
echo "# make a home for this build"
sayAndDo mkdir $BUILDNAME

echo "# libcoredumper - building Debian package and installing as dependency"
sayAndDo cd libcoredumper
sayAndDo ./build.sh
sayAndDo mv libcoredumper* ../$BUILDNAME
sayAndDo cd ..
sayAndDo sudo dpkg -i $BUILDNAME/libcoredumper*.deb
echo "# - done"
echo

echo "# libsqliteodbc - building Debian package and installing as dependency"
sayAndDo cd libsqliteodbc
sayAndDo ./build.sh
sayAndDo mv range-libsqliteodbc_* ../$BUILDNAME
sayAndDo cd ..
sayAndDo sudo dpkg -i $BUILDNAME/range-libsqliteodbc_*.deb
echo "# - done"
echo

echo "# libzmq - building Debian package and installing as dependency"
sayAndDo cd libzmq
sayAndDo ./build.sh
sayAndDo mv range-libzmq_* ../$BUILDNAME
sayAndDo cd ..
sayAndDo sudo dpkg -i $BUILDNAME/range-libsqliteodbc_*.deb
echo "# - done"
echo

echo "# liba53 - building Debian and installing as dependency"
sayAndDo cd liba53
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv liba53_* $BUILDNAME
sayAndDo sudo dpkg -i $BUILDNAME/liba53_*.deb
echo "# - done"
echo

echo "# subscriberRegistry - building"
sayAndDo cd subscriberRegistry
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv sipauthserve_* $BUILDNAME
echo "# - done"
echo

echo "# smqueue - building Debian package"
sayAndDo cd smqueue
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv smqueue_* $BUILDNAME
echo "# - done"
echo

echo "# openbts - building Debian package"
sayAndDo cd openbts
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv openbts_* $BUILDNAME
echo "# - done"
echo

echo "# asterisk - building Debian package"
sayAndDo cd asterisk
rm -rf range-asterisk* asterisk-*
sayAndDo ./build.sh
sayAndDo mv range-asterisk_* ../$BUILDNAME
sayAndDo cd ..
echo "# - done"
echo

echo "# asterisk-config - building Debian package"
sayAndDo cd asterisk-config
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv range-asterisk-config_* $BUILDNAME
echo "# - done"
echo

echo "# system-config - building Debian package"
sayAndDo cd system-config
sayAndDo dpkg-buildpackage -us -uc
sayAndDo cd ..
sayAndDo mv range-configs_* $BUILDNAME
echo "# - done"
echo
