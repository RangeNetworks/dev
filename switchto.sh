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

usage () {
	echo "# usage: ./switchto.sh branch-or-tag-name"
	exit 1
}

if [ -z "$1" ]; then
	usage
fi

for component in $REPOS
do
	if [ -d $component ]; then
		echo "########################################################################"
		echo "# $component"
		cd $component
		git checkout $1
		git submodule update --recursive
		git submodule foreach 'git checkout `git config -f $toplevel/.gitmodules submodule.$name.branch`'	
		cd ..
		echo
	fi
done
