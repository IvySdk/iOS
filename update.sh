#!/bin/bash
cp -f IvyiOSSdk.podspec IvyiOSSdk.podspec.bak
cp -f IvyiOSSdk.podspec.update IvyiOSSdk.podspec
./syncpods.sh
cp -f IvyiOSSdk.podspec.bak IvyiOSSdk.podspec
