#!/usr/bin/env bash
# Termux RootFS Builder

# Params:
# $1 architecture

arch=$1

echo Start building.
echo Create directories.
mkdir -p termux/data/data/com.termux/files/usr termux/build
cp termux-symlink.py termux/data/data/com.termux/files/usr/
cd termux/data/data/com.termux/files
mkdir home
cd usr/
echo Download bootstrap package.
wget -qO bootstrap-${arch}-v${version}.zip https://bintray.com/termux/bootstrap/download_file?file_path=bootstrap-${arch}-v${version}.zip
echo Decompress bootstrap package.
unzip bootstrap-${arch}-v${version}.zip > /dev/null
echo Delete bootstrap package.
rm -f bootstrap-${arch}-v${version}.zip
echo Change file permission.
chmod +x bin/* lib/apt/methods/* lib/bash/* libexec/termux/*
chmod -x lib/bash/Makefile.inc
echo Process symlink.
python3 termux-symlink.py
rm -f termux-symlink.py
cd ../../../../..
echo Build package.
tar -czf build/${arch}.tar.gz data
echo Clean build cache.
rm -rf data
cd ..

