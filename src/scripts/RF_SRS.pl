#! /usr/bin/perl -w
=pod
You may freely copy and distribute this document so long as the copyright is left intact. You may freely copy and post unaltered versions of this document in HTML and Postscript formats on a web site or ftp site. Lastly, if you do something injurious or stupid
because of this document, I don't want to know about it. Unless it's amusing.
=cut
 require 5.003; # need this version of Perl or newer
 use English; # use English names, not cryptic ones
 use FileHandle; # use FileHandles instead of open(),close()
 use Carp; # get standard error / warning messages
 use strict; # force disciplined use of variables

 if(@ARGV<8)
 {
	 print "For CASP11\n";
	 print "This script calculate the RF_SRS score!\n";
	 print "perl $0 addr_CASP11_cal_not_norm_RF_SRS_score.pl addr_CASP11_norm_RF_SRS_score.pl addr_RF_SRS_folder addr_RF_SRS_energy dir_target_folder addr_seq addr_output addr_res";
	 print "for example:\n";
	 print "perl $0 CASP11_cal_not_norm_RF_SRS_score.pl CASP11_norm_RF_SRS_score.pl /home/rcrg4/tool/Energy_function_RF_SRS/calc_energy /home/rcrg4/tool/Energy_function_RF_SRS/RF_CB_SRS_OD ../../test/test_target_prediction/T0516_test ../../test/casp9_seq/T0516.fasta ../../test/test_RF_SRS_final 123\n";
	 exit(0);
 }
 
 my($cal_script)=$ARGV[0];
 my($norm_script)=$ARGV[1];
 my($tool_folder)=$ARGV[2];
 my($tool_energy)=$ARGV[3];
 my($dir_input)=$ARGV[4];
 my($addr_seq)=$ARGV[5];
 my($addr_output)=$ARGV[6];
 my($res)=$ARGV[7];

 my($return_val);
 my($addr_output_orig)=$addr_output."_orig";
 ##### first calculate the not normed score  ##########
 $return_val = system("perl $cal_script $tool_folder $tool_energy $dir_input $addr_output_orig");
 if($return_val!=0)
 {
	 print "Calculating not normed score fails: perl $cal_script $tool_folder $tool_energy $dir_input $addr_output_orig\n";
	 exit(0);
 }
 ###### norm the score ##########
 $return_val = system("perl $norm_script $addr_seq $addr_output_orig $addr_output");
 if($return_val!=0)
 {
	 print "Normalize score fails: perl $norm_script $addr_seq $addr_output_orig $addr_output\n";
	 exit(0);
 }
 system("rm $res");