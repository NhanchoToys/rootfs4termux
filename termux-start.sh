#!/data/data/com.termux/files/usr/bin/bash

unset LD_PRELOAD
export RFSML="$(realpath "$(dirname "$0")")"
export TLANG=C
export SHLX="bash"

id="$1"
if test -z "$id"; then
    id=$(id -u):$(id -g)
fi
command="proot --kill-on-exit --link2symlink -i $id \
-r $RFSML -b /system -b /dev -b /proc -b /sdcard -b /vendor \
-b $RFSML/root:/dev/shm -b /data:/adata \
-w /data/data/com.termux/files/home \
/data/data/com.termux/files/usr/bin/env -i \
HOME=/data/data/com.termux/files/home PREFIX=/data/data/com.termux/files/usr \
PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets \
LD_PRELOAD=/data/data/com.termux/files/usr/lib/libandroid-support.so \
LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib \
ANDROID_DATA=$ANDROID_DATA ANDROID_ROOT=$ANDROID_ROOT \
TERM=$TERM LANG=$TLANG /data/data/com.termux/files/usr/bin/$SHLX -l"

test -z "$2" && exec $command || exec $command -c "$2"

