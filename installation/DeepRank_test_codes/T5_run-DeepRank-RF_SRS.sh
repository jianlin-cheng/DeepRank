#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/
cd /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/


touch /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/ALL_scores/feature_RF_SRS.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_RF_SRS.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_RF_SRS.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/ALL_scores/feature_RF_SRS.T0980s1" ]];then 
	printf "!!!!! Failed to run RF_SRS, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_RF_SRS.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS/ALL_scores/feature_RF_SRS.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_RF_SRS.running
