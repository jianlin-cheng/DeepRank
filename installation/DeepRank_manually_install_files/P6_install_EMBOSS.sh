#!/bin/bash -e

echo " Start compile freecontact (will take ~3 min)"

cd /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/EMBOSS-6.6.0

make clean

./configure --prefix=/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/EMBOSS-6.6.0

make

make install

echo "installed" > /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/EMBOSS-6.6.0/install.done

