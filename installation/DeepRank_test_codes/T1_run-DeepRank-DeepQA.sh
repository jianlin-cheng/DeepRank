#!/bin/bash
#SBATCH -J  DeepQA
#SBATCH -o DeepQA-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 2-00:00


mkdir -p /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/
cd /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/


export LD_LIBRARY_PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/DeepQA/libs:$LD_LIBRARY_PATH

touch /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA.running
if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1" ]];then
	echo "perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/\n\n";								
	perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ 2>&1 | tee  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA.log
fi


printf "\nFinished.."
printf "\nCheck log file </storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA.log>\n\n"


if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1" ]];then 
	printf "!!!!! Failed to run DeepQA, check the installation </storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_DeepQA.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA/ALL_scores/feature_DeepQA.T0980s1\n\n"
fi
rm /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_DeepQA.running
