#!/bin/bash
#
# Copyright 2014-2021 Range Networks, Inc.
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

usage () {
	echo "# usage: ./state.sh (branches, tags)"
	exit 1
}

if [ -z "$1" ]; then
	type=status
elif [ $1 == "branches" ]; then
	type=branch
elif [ $1 == "tags" ]; then
	type=tag
else
	usage
fi

for component in $REPOS
do
	if [ -d $component ]; then
		echo "########################################################################"
		echo "# $component"
		cd $component
		if [ $type == "status" ]; then
			git status
		else
			git $type
		fi
		cd ..
		echo
	fi
done