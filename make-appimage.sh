#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:wayland-is-broken.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/jorio/CroMagRally/refs/heads/master/packaging/io.jor.cromagrally.png
export DESKTOP=https://raw.githubusercontent.com/jorio/CroMagRally/refs/heads/master/packaging/io.jor.cromagrally.desktop
export STARTUPWMCLASS=CroMagRally
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/CroMagRally
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
