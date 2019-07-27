#!/bin/bash -e

echo " Start compile boost (will take ~20 min)"

cd /home/casp14/DeepRank_db_tools//tools

cd boost_1_38_0

./configure  --prefix=/home/casp14/DeepRank_db_tools//tools/boost_1_38_0

make

make install

echo "installed" > /home/casp14/DeepRank_db_tools//tools/boost_1_38_0/install.done

