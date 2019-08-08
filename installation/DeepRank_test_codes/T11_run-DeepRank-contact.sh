#!/bin/bash
#SBATCH -J  contact
#SBATCH -o contact-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 2-00:00

mkdir -p /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/
cd /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/


touch /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact.running
if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1" ]];then
	echo " /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/\n\n";								
	perl /storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl T0980s1  /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1.fasta /storage/htc/bdm/jh7x3/DeepRank/examples/T0980s1  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ 2>&1 | tee  /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact.log
fi


printf "\nFinished.."
printf "\nCheck log file </storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact.log>\n\n"


if [[ ! -f "/storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1" ]];then 
	printf "!!!!! Failed to run contact, check the installation </storage/htc/bdm/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1\n"
	printf "\nShort-range Results: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_short-range.T0980s1\n"
	printf "Medium-range Results: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_medium-range.T0980s1\n"
	printf "Long-range Results: /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_long-range.T0980s1\n\n"
fi
rm /storage/htc/bdm/jh7x3/DeepRank/test_out/T0980s1_contact.running
