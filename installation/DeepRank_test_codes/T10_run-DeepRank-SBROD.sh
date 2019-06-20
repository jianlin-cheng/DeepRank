#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_SBROD/
cd /home/jh7x3/DeepRank/test_out/T0980s1_SBROD/


touch /home/jh7x3/DeepRank/test_out/T0980s1_SBROD.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_SBROD/ALL_scores/feature_SBROD.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_SBROD.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_SBROD/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_SBROD.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_SBROD/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_SBROD.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_SBROD.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_SBROD/ALL_scores/feature_SBROD.T0980s1" ]];then 
	printf "!!!!! Failed to run SBROD, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_SBROD.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_SBROD/ALL_scores/feature_SBROD.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_SBROD.running
