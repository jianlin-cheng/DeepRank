#!/bin/bash
#SBATCH -J  Apollo
#SBATCH -o Apollo-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time 1-00:00

mkdir -p /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/
cd /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/


touch /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo.running
if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1" ]];then
	echo "perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/\n\n";								
	perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/ 2>&1 | tee  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo.log
fi


printf "\nFinished.."
printf "\nCheck log file </storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo.log>\n\n"


if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1" ]];then 
	printf "!!!!! Failed to run Apollo, check the installation </storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_Apollo.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo/ALL_scores/feature_pairwiseScore.T0980s1\n\n"
fi
rm /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_Apollo.running
