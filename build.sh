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

sayAndDo () {
	echo $@
	eval $@
	if [ $? -ne 0 ]; then
		echo "# ERROR: command failed!"
		exit 1
	fi
}

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo "# - missing $@, installing dependency"
		sudo apt-get install $@
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
echo "# - done"
echo "#"

echo "# a53 - building and installing as dependency"
sayAndDo cd a53
sayAndDo make
sayAndDo sudo make install
sayAndDo cd ..
echo "# - done"
echo "#"

echo "# libzmq - building and installing as dependency"
sayAndDo cd libzmq
sayAndDo ./build.sh
sayAndDo sudo dpkg -i *.deb
sayAndDo cd ..
echo "# - done"
echo "#"

echo "# subscriberRegistry - building Debian package"
sayAndDo cd subscriberRegistry
sayAndDo dpkg-buildpackage
sayAndDo cd ..
echo "# - done"
echo "#"

echo "# smqueue - building Debian package"
sayAndDo cd smqueue
sayAndDo dpkg-buildpackage
sayAndDo cd ..
echo "# - done"
echo "#"

echo "# openbts - building Debian package"
sayAndDo cd openbts
sayAndDo dpkg-buildpackage
sayAndDo cd ..
echo "# - done"
echo "#"
