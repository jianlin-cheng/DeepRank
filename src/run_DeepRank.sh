#!/bin/sh
# DeepRank prediction file for protein quality assessment #
if [ $# -lt 4 ]
then
	echo "need four parameters : target id, path of fasta sequence, directory of input pdbs, directory of output"
	exit 1
fi

targetid=$1 
fasta=$2 
model_dir=$3 
outputfolder=$4 

if [ $# -eq 5 ]
then
	contact_file=$5
	nativefile='None'
fi

if [ $# -eq 6 ]
then
	contact_file=$5
	nativefile=$6
fi


if [[ "$fasta" != /* ]]
then
   echo "Please provide absolute path for $fasta"
   exit
fi

if [[ "$outputfolder" != /* ]]
then
   echo "Please provide absolute path for $outputdir"
   exit
fi


mkdir -p $outputfolder
cd $outputfolder

source /home/jh7x3/DeepRank/tools/python_virtualenv/bin/activate
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/DeepQA/libs:$LD_LIBRARY_PATH
export PATH=/home/jh7x3/DeepRank/tools/EMBOSS-6.6.0/bin/:$PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/EMBOSS-6.6.0/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/external/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/src/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH

echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank.pl $targetid   $fasta  $model_dir  $outputfolder $contact_file $nativefile\n\n";								
perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank.pl $targetid   $fasta  $model_dir  $outputfolder $contact_file $nativefile

