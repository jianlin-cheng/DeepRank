#!/bin/bash -e

echo " Start compile freecontact (will take ~3 min)"

cd /data/commons/DeepRank_db_tools//tools/EMBOSS-6.6.0

make clean

./configure --prefix=/data/commons/DeepRank_db_tools//tools/EMBOSS-6.6.0

make

make install

