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
	echo "# usage: ./delete.sh component-directory (tag/branch current-tag new-tag)"
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

# Are we deleting a tag or branch?
if [ -z "$2" ]; then
	read -r -p "# Do you want to delete a tag or branch? " TYPE
elif [ $2 == "tag" ]; then
	TYPE="tag"
elif [ $2 == "branch" ]; then
	TYPE="branch"
else
	usage
fi

# Which one should be deleted?
if [ -z "$3" ]; then
	echo "# Here are the valid choices for that component:"
	cd $COMPONENT
	if [ $TYPE == "tag" ]; then
		git tag
	elif [ $TYPE == "branch" ]; then
		git branch -a
	fi
	cd ..
	read -r -p "# Which $TYPE would you like to delete? " NAME
else
	NAME=$3
fi

# Really, truly? Alrighty, execute.
read -r -p "# To delete $TYPE $NAME, answer \"yes\" " ANSWER
if [ $ANSWER == "yes" ]; then
	cd $COMPONENT
	if [ $TYPE == "tag" ]; then
		echo "# - deleting..."
		sayAndDo git tag -d $NAME
		echo "# - pushing to origin..."
		sayAndDo git push origin :refs/tags/$NAME
	elif [ $TYPE == "branch" ]; then
		echo "# - Sorry, branch deletes haven't been tested. Bailing."
		exit 1
		#echo "# - deleting..."
		#sayAndDo git branch -d $NAME
		#echo "# - pushing to origin..."
		#sayAndDo git push origin :$NAME
	fi
else
	echo "# - better safe than sorry, cancelling..."
fi
