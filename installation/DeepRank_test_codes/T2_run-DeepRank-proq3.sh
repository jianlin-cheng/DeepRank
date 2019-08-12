#!/bin/bash
#SBATCH -J  proq3
#SBATCH -o proq3-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 2-00:00

mkdir -p /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/
cd /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/

source /storage/htc/bdm/jh7x3/DeepRank/tools/python_virtualenv/bin/activate
export PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/EMBOSS-6.6.0/bin/:$PATH
export LD_LIBRARY_PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/EMBOSS-6.6.0/lib/:$LD_LIBRARY_PATH
export PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/R-3.2.0/bin/:$PATH
export LD_LIBRARY_PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/external/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/storage/htc/bdm/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/src/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH


touch /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3.running
if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/ALL_scores/feature_proq3.T0980s1" ]];then
	echo "perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_proq3.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/\n\n";								
	perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_proq3.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/ 2>&1 | tee  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3.log
fi


printf "\nFinished.."
printf "\nCheck log file </storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3.log>\n\n"


if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/ALL_scores/feature_proq3.T0980s1" ]];then 
	printf "!!!!! Failed to run proq3, check the installation </storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_proq3.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3/ALL_scores/feature_proq3.T0980s1\n\n"
fi
rm /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_proq3.running
