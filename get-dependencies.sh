#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm gtk3 alsa-lib wget

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

case "$ARCH" in
    x86_64)
        DEB_URL="https://www.eeo.cn/download/client/classin_6.0.8.2737_amd64.deb"
        VERSION="6.0.8.2737"
        ;;
    aarch64)
        DEB_URL="https://www.eeo.cn/download/client/classin_6.0.8.2738_arm64.deb"
        VERSION="6.0.8.2738"
        ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

echo "$VERSION" > ~/version

echo "Downloading and extracting ClassIn .deb package..."
echo "---------------------------------------------------------------"
TMP_DIR=$(mktemp -d)
wget -q --show-progress -O "$TMP_DIR/classin.deb" "$DEB_URL"

bsdtar -xf "$TMP_DIR/classin.deb" -C "$TMP_DIR"
if [ -f "$TMP_DIR/data.tar.xz" ]; then
    tar -xf "$TMP_DIR/data.tar.xz" -C /
elif [ -f "$TMP_DIR/data.tar.zst" ]; then
    tar --zstd -xf "$TMP_DIR/data.tar.zst" -C /
elif [ -f "$TMP_DIR/data.tar.gz" ]; then
    tar -xf "$TMP_DIR/data.tar.gz" -C /
fi

rm -rf "$TMP_DIR"
