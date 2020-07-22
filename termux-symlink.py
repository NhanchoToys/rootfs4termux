#!/usr/bin/env python3

import os

with open("SYMLINKS.txt") as symlist:
    data = symlist.read()

datas = data.splitlines()
for lns in datas:
    lnk = lns.split("←")
    os.symlink(*lnk)

os.remove("SYMLINKS.txt")
