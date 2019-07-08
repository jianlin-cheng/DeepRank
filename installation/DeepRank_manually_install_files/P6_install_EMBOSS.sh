#!/bin/bash -e

echo " Start compile freecontact (will take ~3 min)"

cd /home/casp14/DeepRank_db_tools//tools/EMBOSS-6.6.0

make clean

./configure --prefix=/home/casp14/DeepRank_db_tools//tools/EMBOSS-6.6.0

make

make install

echo "installed" > /home/casp14/DeepRank_db_tools//tools/EMBOSS-6.6.0/install.done

