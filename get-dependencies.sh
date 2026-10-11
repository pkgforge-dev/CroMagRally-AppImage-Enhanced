#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake       \
    gcc-libs    \
    glu         \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package cro-mag-rally

# If the application needs to be manually built that has to be done down here
echo "Building stable version of CroMagRally..."
echo "---------------------------------------------------------------"
REPO="https://github.com/jorio/CroMagRally"
VERSION="$(git ls-remote --tags --refs --sort="v:refname" "$REPO" | sed 's|.*refs/tags/||' | grep -E '^v?[0-9]+(\.[0-9]+)*$' | tail -n1 | sed 's/^v//')"
git clone --depth 1 --branch v"$VERSION" "$REPO" ./CroMagRally
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -B build -S ./CroMagRally -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v ./build/CroMagRally ./build/Data ./AppDir/bin
