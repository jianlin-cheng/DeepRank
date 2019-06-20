#!/bin/bash -e

echo " Start install python virtual environment (will take ~1 min)"

cd /data/commons/DeepRank_db_tools//tools

rm -rf python_virtualenv

virtualenv python_virtualenv

source /data/commons/DeepRank_db_tools//tools/python_virtualenv/bin/activate

pip install --upgrade pip

pip install --upgrade numpy==1.12.1

pip install --upgrade keras==1.2.2

pip install --upgrade theano==0.9.0

pip install --upgrade h5py

pip install --upgrade matplotlib

pip install --upgrade pandas

pip install --upgrade sklearn

pip install --upgrade plotly

pip install --upgrade np_utils

pip install --upgrade pillow

NOW=$(date +"%m-%d-%Y")

mkdir -p ~/.keras

cp ~/.keras/keras.json ~/.keras/keras.json.$NOW.$RANDOM

cp /home/jh7x3/DeepRank//installation/DeepRank_configure_files/keras_DeepRank.json ~/.keras/keras.json

