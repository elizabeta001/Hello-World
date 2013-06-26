#!/bin/bash

CURRENT_HEAD=`git rev-parse HEAD`
CURRENT_DATE=`date +"%Y%m%d-%H%M"`

# back to master
git checkout master
git pull

# fail if repository is dirty
CHECK_STATUS=`git status | grep 'nothing to commit, working directory clean'`
if [ -z "$CHECK_STATUS" ]; then
    echo "Your master repository has uncommitted changes. Exiting ...."
    exit 1
fi

echo 'Switching to the release branch ....'

# tag release branch with the current date stamp
git checkout release
git pull
git tag -a 'release-'$CURRENT_DATE $CURRENT_HEAD -m 'tagged release branch'
git push --tags

# back to master
git checkout master
git pull

# delete release branch
git branch -D release
git push origin --delete release

# create release branch from current master
git branch release
git push --set-upstream origin release
git push

echo "Finished creating 'release' branch from master at "$CURRENT_HEAD