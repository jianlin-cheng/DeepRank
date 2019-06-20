#!/bin/bash

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/
cd /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/


touch /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1" ]];then
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl $targetid   $fasta  $model_dir  $outputfolder\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1" ]];then 
	printf "!!!!! Failed to run modfoldclust2, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.running
