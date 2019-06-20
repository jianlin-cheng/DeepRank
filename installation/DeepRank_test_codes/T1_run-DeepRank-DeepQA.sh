#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/
cd /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/


export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/DeepQA/libs:$LD_LIBRARY_PATH

touch /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_DeepQA.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1" ]];then 
	printf "!!!!! Failed to run DeepQA, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_DeepQA.running
