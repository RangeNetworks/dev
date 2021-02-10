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
	echo "# usage: ./create.sh component-directory (tag/branch name)"
	exit 1
}

# What component do we want to manipulate?
if [ -z "$1" ]; then
	usage
elif [ ! -d $1 ]; then
	usage
else
	COMPONENT=$1
fi

# Are we adding a creating or branch?
if [ -z "$2" ]; then
	read -r -p "# Do you want to create a tag or branch? " TYPE
elif [ $2 == "tag" ]; then
	TYPE="tag"
elif [ $2 == "branch" ]; then
	TYPE="branch"
else
	usage
fi

# Which one should be created?
if [ -z "$3" ]; then
	read -r -p "# What new $TYPE would you like to create? " NAME
else
	NAME=$3
fi

# Really, truly? Alrighty, execute.
read -r -p "# To create a new $TYPE named $NAME, answer \"yes\" " ANSWER
if [ $ANSWER == "yes" ]; then
	cd $COMPONENT
	if [ $TYPE == "tag" ]; then
		echo "# Sorry, tag creations haven't been implemented. Bailing."
		exit 1
	elif [ $TYPE == "branch" ]; then
		echo "# - creating..."
		sayAndDo git checkout -b $NAME
		echo "# - pushing to origin..."
		sayAndDo git push -u origin $NAME
	fi
else
	echo "# - better safe than sorry, cancelling..."
fi
