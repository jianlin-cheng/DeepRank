#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_dope/
cd /home/jh7x3/DeepRank/test_out/T0980s1_dope/


touch /home/jh7x3/DeepRank/test_out/T0980s1_dope.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_dope/ALL_scores/feature_dope.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_dope.pl $targetid   $fasta  $model_dir  $outputfolder\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_dope.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_dope/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_dope.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_dope.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_dope/ALL_scores/feature_dope.T0980s1" ]];then 
	printf "!!!!! Failed to run dope, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_dope.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_dope/ALL_scores/feature_dope.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_dope.running
