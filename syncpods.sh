#!/bin/bash
#path=~/Library/Caches/CocoaPods
#giturl="git@10.80.1.11:cocoapods/cocoapods.git"
#branch='1.11.2'
#if [ -d "$path/Pods/Specs" ]; then
#	if [ -d "$path/.git" ]; then
#		git -C $path add .
#		git -C $path checkout -f
#		git -C $path pull
#	else
#		git -C $path init
#		git -C $path remote add origin $giturl
#		git -C $path fetch
#		git -C $path checkout -fb $branch origin/$branch
#	fi
#else
#	rm -fr $path
#	git clone $giturl $path
#fi
cd Example
rm -fr Pods
rm -f Podfile.lock
if [ "$1" = "fast" ];then
pod update --verbose --no-repo-update
elif [ "$1" = "update" ];then  
rm -fr Pods
rm -fr Podfile.lock
cp -f ../IvyiOSSdk.podspec ../IvyiOSSdk.podspec.bak
cp -f ../IvyiOSSdk.podspec.update ../IvyiOSSdk.podspec
pod update 
cp -f ../IvyiOSSdk.podspec.bak ../IvyiOSSdk.podspec
else
pod update --verbose --repo-update
fi
