#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake glu sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building stable version of CroMagRally..."
echo "---------------------------------------------------------------"
REPO="https://github.com/jorio/CroMagRally"
VERSION="$(git ls-remote --tags --refs --sort="v:refname" "$REPO" | awk -F'/' '{print $NF}' | grep -E '^[0-9]+(\.[0-9]+)*$' | tail -n1)"
git clone --recursive --depth 1 --branch "$VERSION" "$REPO" ./CroMagRally
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -B build -S ./CroMagRally -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
mv -v ./build/CroMagRally ./build/Data ./AppDir/bin
