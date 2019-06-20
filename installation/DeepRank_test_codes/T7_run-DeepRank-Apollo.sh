#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_Apollo/
cd /home/jh7x3/DeepRank/test_out/T0980s1_Apollo/


touch /home/jh7x3/DeepRank/test_out/T0980s1_Apollo.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl $targetid   $fasta  $model_dir  $outputfolder\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_Apollo/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_Apollo.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_Apollo.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1" ]];then 
	printf "!!!!! Failed to run Apollo, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_Apollo.running
