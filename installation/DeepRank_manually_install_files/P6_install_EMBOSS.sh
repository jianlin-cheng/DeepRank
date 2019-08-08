#!/bin/bash -e

echo " Start compile freecontact (will take ~3 min)"

cd /storage/htc/bdm/tools/DeepRank_db_tools//tools/EMBOSS-6.6.0

make clean

./configure --prefix=/storage/htc/bdm/tools/DeepRank_db_tools//tools/EMBOSS-6.6.0

make

make install

echo "installed" > /storage/htc/bdm/tools/DeepRank_db_tools//tools/EMBOSS-6.6.0/install.done

