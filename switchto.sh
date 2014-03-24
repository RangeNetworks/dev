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

usage () {
	echo "# usage: ./switchto.sh branch-name"
	exit 1
}

if [ -z "$1" ]; then
	usage
fi

for component in a53 CommonLibs openbts RRLP smqueue sqlite3 subscriberRegistry
do
	if [ -d $component ]; then
		echo "########################################################################"
		echo "# $component"
		cd $component
		sayAndDo git checkout $1
		sayAndDo git submodule foreach --recursive "git checkout $1"
		cd ..
		echo
	fi
done