#!/bin/bash -e

echo " Start compile boost (will take ~20 min)"

cd /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools

cd boost_1_55_0

./bootstrap.sh  --prefix=/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0

./b2

./b2 install

echo "installed" > /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0/install.done

