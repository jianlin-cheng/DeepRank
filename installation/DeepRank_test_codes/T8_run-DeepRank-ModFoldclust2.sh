#!/bin/bash
#SBATCH -J  modfoldclust2
#SBATCH -o modfoldclust2-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 1-00:00

mkdir -p /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/
cd /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/


touch /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.running
if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1" ]];then
	echo "perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/\n\n";								
	perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ 2>&1 | tee  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.log
fi


printf "\nFinished.."
printf "\nCheck log file </storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.log>\n\n"


if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1" ]];then 
	printf "!!!!! Failed to run modfoldclust2, check the installation </storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_modfoldclust2.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2/ALL_scores/modfoldclust2.T0980s1\n\n"
fi
rm /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_modfoldclust2.running
