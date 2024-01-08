#!/bin/bash
git add .
git commit -ama
git push
cd ios-build-copy-sources
git add .
git commit -ama
git push
path=~/Library/Caches/CocoaPods 
git -C $path add .
git -C $path commit -ama
git -C $path pull
git -C $path push
