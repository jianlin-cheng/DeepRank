#!/bin/bash
#SBATCH -J  contact
#SBATCH -o contact-%j.out
#SBATCH --partition Lewis,hpc5,hpc4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time 2-00:00

mkdir -p /home/jh7x3/DeepRank/test_out/T0980s1_contact/
cd /home/jh7x3/DeepRank/test_out/T0980s1_contact/


touch /home/jh7x3/DeepRank/test_out/T0980s1_contact.running
if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1" ]];then
	echo " /home/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_contact/\n\n";								
	perl /home/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl T0980s1  /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1  /home/jh7x3/DeepRank/test_out/T0980s1_contact/ 2>&1 | tee  /home/jh7x3/DeepRank/test_out/T0980s1_contact.log
fi


printf "\nFinished.."
printf "\nCheck log file </home/jh7x3/DeepRank/test_out/T0980s1_contact.log>\n\n"


if [[ ! -f "/home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1" ]];then 
	printf "!!!!! Failed to run contact, check the installation </home/jh7x3/DeepRank/src/scripts/run_DeepRank_contact.pl>\n\n"
else
	printf "\nJob successfully completed!"
	printf "\nResults: /home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/feature_dncon2_long-range.T0980s1\n"
	printf "\nShort-range Results: /home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_short-range.T0980s1\n"
	printf "Medium-range Results: /home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_medium-range.T0980s1\n"
	printf "Long-range Results: /home/jh7x3/DeepRank/test_out/T0980s1_contact/ALL_scores/contact_prediction_long-range.T0980s1\n\n"
fi
rm /home/jh7x3/DeepRank/test_out/T0980s1_contact.running
