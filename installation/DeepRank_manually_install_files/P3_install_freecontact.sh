#!/bin/bash -e

echo " Start compile freecontact (will take ~1 min)"

cd /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/DNCON2

cd freecontact-1.0.21

autoreconf -f -i

make clean

./configure --prefix=/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/DNCON2/freecontact-1.0.21 LDFLAGS="-L/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/OpenBLAS/lib -L/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0/lib" CFLAGS="-I/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/OpenBLAS/include -I/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0/include"  CPPFLAGS="-I/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/OpenBLAS/include -I/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0/include" --with-boost=/home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/boost_1_55_0/

make

make install

echo "installed" > /home/casp13/tmpwork/DeepRank_db/DeepRank_db_tools//tools/DNCON2/freecontact-1.0.21/install.done

