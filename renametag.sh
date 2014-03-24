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
	echo "# usage: ./renametag.sh component-directory (current-tag new-tag)"
	exit 1
}

if [ -z "$1" ]; then
	usage
elif [ ! -d $1 ]; then
	usage
fi

if [ -z "$2" ]; then
	echo "# Here are the tags for that componet:"
	cd $1
	git tag
	cd ..
	read -r -p "# Which tag would you like to rename? " OLDTAG
else
	OLDTAG=$2
fi

if [ -z "$3" ]; then
	read -r -p "# What should the new name be? " NEWTAG
else
	NEWTAG=$3
fi

read -r -p "# To rename tag $OLDTAG to $NEWTAG, answer \"yes\" " ANSWER
if [ $ANSWER == "yes" ]; then
	echo "# - renaming..."
	cd $1
	sayAndDo git tag $NEWTAG $OLDTAG
	sayAndDo git tag -d $OLDTAG
	sayAndDo git push origin :refs/tags/$OLDTAG
	sayAndDo git push --tags
else
	echo "# - better safe than sorry, cancelling..."
fi
