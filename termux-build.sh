#!/usr/bin/env bash
# Termux RootFS Builder

# Params:
# $1 architecture [aarch64 / arm / i686 / x86_64]
# $2 Android API level [21 / 24]

set -e

arch=$1
api=$2

echo Start building.
echo Create directories.
mkdir -p termux/data/data/com.termux/files/usr termux/build termux/root
cp termux-start.sh termux/
cp termux-symlink.py termux/data/data/com.termux/files/usr/
cd termux/data/data/com.termux/files
mkdir -p home
cd usr/
echo Download bootstrap package.
case ${arch} in
    aarch64|arm|i686|x86_64)
        case ${api} in
            21)
                wget -O bootstrap-${arch}.zip http://termux.net/bootstrap/new/bootstrap-${arch}.zip
                ;;
            24)
                wget -O bootstrap-${arch}.zip https://bintray.com/termux/bootstrap/download_file?file_path=bootstrap-${arch}-v${version}.zip
                ;;
            *)
                echo "Bad API level."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Bad architecture."
        exit 1
        ;;
esac
echo Decompress bootstrap package.
unzip bootstrap-${arch}.zip > /dev/null
echo Delete bootstrap package.
rm -f bootstrap-${arch}.zip
echo Change file permission.
chmod +x bin/* lib/apt/methods/* lib/bash/* libexec/termux/*
chmod -x lib/bash/Makefile.inc
echo Process symlink.
python3 termux-symlink.py
rm -f termux-symlink.py
cd ../../../../..
echo Build package.
tar -czf build/rootfs-termux${api}-${arch}.tar.gz data termux-start.sh root
echo Clean build cache.
rm -rf data
cd ..

