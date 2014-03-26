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
	echo "# usage: ./rename.sh component-directory (tag/branch current-name new-name)"
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

# Are we manipulating a tag or branch?
if [ -z "$2" ]; then
	read -r -p "# Do you want to rename a tag or branch? " TYPE
elif [ $2 == "tag" ]; then
	TYPE="tag"
elif [ $2 == "branch" ]; then
	TYPE="branch"
else
	usage
fi

# Which one should be renamed?
if [ -z "$3" ]; then
	echo "# Here are the valid choices for that component:"
	cd $COMPONENT
	if [ $TYPE == "tag" ]; then
		git tag
	elif [ $TYPE == "branch" ]; then
		git branch -a
	fi
	cd ..
	read -r -p "# Which $TYPE would you like to rename? " OLDNAME
else
	OLDNAME=$3
fi

# What should it be renamed to?
if [ -z "$4" ]; then
	read -r -p "# What should the new name be? " NEWNAME
else
	NEWNAME=$4
fi

# Really, truly? Alrighty, execute.
read -r -p "# To rename $TYPE $OLDNAME to $NEWNAME, answer \"yes\" " ANSWER
if [ $ANSWER == "yes" ]; then
	cd $COMPONENT
	if [ $TYPE == "tag" ]; then
		echo "# - renaming..."
		sayAndDo git tag $NEWNAME $OLDNAME
		sayAndDo git tag -d $OLDNAME
		echo "# - pushing to origin..."
		sayAndDo git push origin :refs/tags/$OLDNAME
		sayAndDo git push --tags
	elif [ $TYPE == "branch" ]; then
		BOOKMARK=`git rev-parse --abbrev-ref HEAD`
		echo "# - saving bookmark for current workspace branch..."
		echo "# - renaming..."
		sayAndDo git branch -m $OLDNAME $NEWNAME
		echo "# - pushing to origin..."
		sayAndDo git push origin --delete $OLDNAME
		sayAndDo git push origin $NEWNAME
		sayAndDo git branch -D $NEWNAME
		sayAndDo git checkout -b $NEWNAME --track origin/$NEWNAME
		echo "# - restoring workspace branch..."
		sayAndDo git checkout $BOOKMARK
	fi
else
	echo "# - better safe than sorry, cancelling..."
fi
