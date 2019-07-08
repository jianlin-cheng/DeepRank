#!/bin/bash -e

echo " Start compile OpenBlas (will take ~5 min)"

cd /home/casp14/DeepRank_db_tools//tools

cd OpenBLAS

make clean

make

make PREFIX=/home/casp14/DeepRank_db_tools//tools/OpenBLAS install

echo "installed" > /home/casp14/DeepRank_db_tools//tools/OpenBLAS/install.done

