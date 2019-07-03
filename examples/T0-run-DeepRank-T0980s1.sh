#!/bin/bash
#SBATCH -J  DeepRank
#SBATCH -o DeepRank-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 2-00:00
mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/
cd /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/

source /home/jh7x3/DeepRank/tools/python_virtualenv/bin/activate
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/DeepQA/libs:$LD_LIBRARY_PATH
export PATH=/home/jh7x3/DeepRank/tools/EMBOSS-6.6.0/bin/:$PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/EMBOSS-6.6.0/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/external/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/jh7x3/DeepRank/tools/rosetta_2014.16.56682_bundle/main/source/build/src/release/linux/2.6/64/x86/gcc/4.4/default/:$LD_LIBRARY_PATH

if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/DeepRank_gdt_prediction.txt" ]];then 
	echo "perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1 /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1 /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/    2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank.log
fi

printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_DeepRank.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/DeepRank_gdt_prediction.txt" ]];then 
	printf "!!!!! Failed to run DeepRank, check the installation </home/jh7x3/DeepRank/src/>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank/DeepRank_gdt_prediction.txt\n\n"
fi

printf "Validating the results\n\n";
perl /home/jh7x3/DeepRank/installation/scripts/validate_predictions_final.pl T0980s1 /home/jh7x3/DeepRank/test_out/T0980s1_DeepRank /home/jh7x3/DeepRank/installation/benchmark/T0980s1
 
 
