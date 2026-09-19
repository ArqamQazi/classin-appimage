#!/bin/sh
set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/classin.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/classin.svg

# Allow ldd to resolve ClassIn's private libraries during deployment
export LD_LIBRARY_PATH="/opt/apps/classin/lib:${LD_LIBRARY_PATH:-}"

# Deploy dependencies
quick-sharun /opt/apps/classin/ClassIn /usr/lib/libgtk-3.so*

# Copy application assets and plugins into AppDir (without overwriting AppRun)
cp -rn /opt/apps/classin/* ./AppDir/

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage
quick-sharun --test ./dist/*.AppImage
