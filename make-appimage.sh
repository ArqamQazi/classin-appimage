#!/bin/sh
set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/classin.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/classin.svg

# Deploy dependencies
quick-sharun /opt/apps/classin/ClassIn /opt/apps/classin/html/lib/* /opt/apps/classin/lib/* /usr/lib/libgtk-3.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage
quick-sharun --test ./dist/*.AppImage
