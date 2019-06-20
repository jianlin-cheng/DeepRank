#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_OPUS/
cd /home/jh7x3/DeepRank/test_out/T0980s1_OPUS/


touch /home/jh7x3/DeepRank/test_out/T0980s1_OPUS.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_OPUS/ALL_scores/feature_OPUS.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_OPUS.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_OPUS/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_OPUS.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_OPUS/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_OPUS.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_OPUS.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_OPUS/ALL_scores/feature_OPUS.T0980s1" ]];then 
	printf "!!!!! Failed to run OPUS, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_OPUS.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_OPUS/ALL_scores/feature_OPUS.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_OPUS.running
