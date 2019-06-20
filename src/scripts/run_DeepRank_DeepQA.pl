#! /usr/bin/perl -w
#
use Cwd;

# use email;
# use MIME::Lite;
require 5.003; # need this version of Perl or newer
use English; # use English names, not cryptic ones
use FileHandle; # use FileHandles instead of open(),close()
use Carp; # get standard error / warning messages
#use strict; # force disciplined use of variables
use Cwd 'abs_path';
use Scalar::Util qw(looks_like_number);
sub filter_score($$);

our %AA3TO1 = qw(ALA A ASN N CYS C GLN Q HIS H LEU L MET M PRO P THR T TYR Y ARG R ASP D GLU E GLY G ILE I LYS K PHE F SER S TRP W VAL V);
our %AA1TO3 = reverse %AA3TO1;


############## Revise the path ########################
$DeepRank_install = "/home/jh7x3/DeepRank/";
$H_script = "$DeepRank_install/src/scripts";
$H_tool = "$DeepRank_install/tools";

########################################################


if(@ARGV <4 or @ARGV >6)
{
die "The number of parameter is not correct!\n";
}

$targetname = $ARGV[0];
$seqfile = abs_path($ARGV[1]);
$dir_models = abs_path($ARGV[2]);
$dir_output = abs_path($ARGV[3]);
$contact_file = $ARGV[4]; # optional
$native_score = $ARGV[5]; # optional

if(!defined($native_score))
{
	$native_score='None';
}
if(!defined($contact_file))
{
	$contact_file='None';
}

$DeepRank_starttime = time();

if(!(-d $dir_output))
{
	`mkdir $dir_output`;
}


##### filter the models according to the fasta sequence 
if(!(-d "$dir_output/mod2"))
{
	`mkdir  $dir_output/mod2`;
}else{
	`rm -rf $dir_output/mod2/*`;
}

open(INPUT, "$seqfile") || die "ERROR! Could not open $seqfile\n";
@fasta_arr = <INPUT>;
close INPUT;
shift @fasta_arr;
$fasta_seq = shift @fasta_arr;
chomp $fasta_seq;

opendir(DIR,$dir_models) || die "Failed to open dir $dir_models\n";
@targets = readdir(DIR);
closedir(DIR);
$model_num = 0;
foreach $model (@targets)
{
	chomp $model;
	if($model eq '.' or $model eq '..')
	{
		next;
	}
	$file_PDB = "$dir_models/$model";
	$seq = "";
	open(INPUTPDB, "$file_PDB") || die "ERROR! Could not open $file_PDB\n";
	while(<INPUTPDB>){
		next if $_ !~ m/^ATOM/;
		next unless (parse_pdb_row($_,"aname") eq "CA");
		confess "ERROR!: ".parse_pdb_row($_,"rname")." residue not defined! \nFile: $file_PDB! \nLine : $_" if (not defined $AA3TO1{parse_pdb_row($_,"rname")});
		my $res = $AA3TO1{parse_pdb_row($_,"rname")};
		$seq .= $res;
	}
	close INPUTPDB;
	if($seq eq $fasta_seq)
	{
		$model_num++;
		$modelnew=$model;
		if(substr($modelnew,length($modelnew)-4) eq '.pdb')  ## for the qa, if the model name is too long, OPUS will fail, like MULTICOM-CONSTRUCT_TS1.pd
		{
			#$modelnew .= '.pdb';
			$modelnew = substr($modelnew,0,length($modelnew)-4);
		}
		### do we need add scwrl here?????
		
		$status=system("$H_tool/scwrl4/Scwrl4 -i $file_PDB -o $dir_output/mod2/$modelnew.tmp");
		if($status!=0)
		{
		  print  "$H_tool/scwrl4/Scwrl4 -i $file_PDB -o $dir_output/mod2/$modelnew.tmp fails !\n";
		}

		if(!-s "$dir_output/mod2/$modelnew.tmp")
		{# scwrl fails in this case, only CA atom is in the pdb, we directly copy it from original
			print("scwrl fails in this case, only CA atom is in the pdb\n");
			next;
		}
		
		
		
		$seq2 = "";
		open(INPUTPDB, "$dir_output/mod2/$modelnew.tmp") || die "ERROR! Could not open $dir_output/mod2/$modelnew.tmp\n";
		while(<INPUTPDB>){
			next if $_ !~ m/^ATOM/;
			next unless (parse_pdb_row($_,"aname") eq "CA");
			confess "ERROR!: ".parse_pdb_row($_,"rname")." residue not defined! \nFile: $file_PDB! \nLine : $_" if (not defined $AA3TO1{parse_pdb_row($_,"rname")});
			my $res = $AA3TO1{parse_pdb_row($_,"rname")};
			$seq2 .= $res;
		}
		close INPUTPDB;
		
		if($seq2 ne $seq)
		{
			`rm $dir_output/mod2/$modelnew.tmp`;
			next;
		}else{
			`mv $dir_output/mod2/$modelnew.tmp $dir_output/mod2/$modelnew`;
		}
	}else{
	
		print "Warning: sequence not match!!!\n$seq\n$fasta_seq\n\n";
	}
}

## redefine dir_models
$dir_models = "$dir_output/mod2";
print "$model_num models are selected for evaluation\n";


##### create folder
my($TMP_output) = $dir_output."/"."TMP";
-s $TMP_output || system("mkdir $TMP_output");

my($ren_dncon2_features)=$TMP_output."/dncon2";
if(!(-d $ren_dncon2_features))
{
	`mkdir $ren_dncon2_features`;
}


$ALL_scores = $dir_output."/"."ALL_scores/";
system("mkdir -p  $ALL_scores");

$ALL_14_scores = $dir_output."/"."ALL_14_scores/";
system("mkdir -p $ALL_14_scores");


if($contact_file ne 'None')
{
	print "Detecting contact file $contact_file, validating......\n\n";
	
	if(-e $contact_file)
	{
		`cp $contact_file $ren_dncon2_features/$targetname.dncon2.rr`;
	}
}

$LGA_model_num=0;
$validate = 1;
if($native_score ne 'None')
{
	print "Detecting native score $native_score, validating......\n\n";
	
	if(-e $native_score)
	{
		open(TMP,$native_score) || die "Failed to open dir $native_score\n";
		@content = <TMP>;
		close TMP;

		foreach $line (@content)
		{
			chomp $line;
			if($line eq '.' or $line eq '..')
			{
				next;
			}
			$LGA_model_num++;
			@tmp = split(/\t/,$line);
		    $LGA_score_list{$tmp[0]} = $tmp[1]; # this is for prediction
		}
		opendir(DIR,$dir_models) || die "Failed to open dir $dir_models\n";
		@targets = readdir(DIR);
		closedir(DIR);
		foreach $model (@targets)
		{
			chomp $model;
			if($model eq '.' or $model eq '..')
			{
				next;
			}
		   if(!exists($LGA_score_list{$model} ))
		   {
				print "Failed to find the model $model in your native score, incorrect native file, ignore\n\n";
				$validate = 0;
				last;
		   }
		}
	}else{
		$validate = 0;
	}
}

if($validate ==0)
{
	$native_score='None';
}else{
	print "Loading native score $native_score\n\n";
}
##### (1) Run feature generation
print "\n\n##### (1) Run feature generation\n\n";
print("perl $H_script/P0_run_DeepQA.pl $targetname $seqfile $dir_models $dir_output\n");
$status = system("perl $H_script/P0_run_DeepQA.pl $targetname $seqfile $dir_models $dir_output");
if($status)# if failed, should we use at least one score?
{
	die "Failed to run the feature generation\n";
}


print "!!!!!! Checking if all features are generated successfully\n\n";

#$all_features_list2 = "feature_DeepQA,feature_pairwiseScore,feature_RF_SRS,feature_pcons,feature_RWplus,feature_voronota,feature_dope,feature_proq2,feature_proq3_lowres,feature_proq3_highres,feature_proq3,modfoldclust2,feature_OPUS,feature_total_surf,feature_ss_sim,feature_solvent,feature_weighted,feature_euclidean,feature_ss_penalty,feature_SBROD,feature_dncon2_short-range,feature_dncon2_medium-range,feature_dncon2_long-range";
$all_features_list2 = "feature_DeepQA";
@all_features = split(',',$all_features_list2);

%LGA_score_list = ();
$LGA_model_num=0;

opendir(DIR,$dir_models) || die "Failed to open dir $dir_models\n";
@targets = readdir(DIR);
closedir(DIR);
foreach $model (@targets)
{
	chomp $model;
	if($model eq '.' or $model eq '..')
	{
		next;
	}
	$LGA_model_num++;
	$LGA_score_list{$model} = 0; # this is for prediction
}


### 2. check if all methods have generated score for models as LGA
$check_iteration=0;
while($check_iteration<4)
{
	sleep(10);
	$check_iteration++;
	$incomplete=0;
	foreach $method (@all_features)
	{
	  $method_score = "$dir_output/ALL_scores/$method.$targetname";
	  if(!(-e $method_score))
	  {
		 print "$targetname incomplete (missing $method_score)\n";
		 $incomplete=1;
	  }
	  
	  ## check if model number match 
	  open(IN,"$method_score") || die "Failed to open file $method_score\n";
	  $model_num = 0;
	  @score_prediction = ();
	  while(<IN>)
	  {
		$line=$_;
		chomp $line;
		$line =~ s/^\s+|\s+$//g;
		
		
		
		@tmp = split(/\s++/,$line);
		$model = $tmp[0];
		$score = $tmp[1];
		
		
		if($method eq 'feature_SBROD')
		{
		  @tmp2 = split(/\//,$model);
		  $model = pop @tmp2;
		  chomp $model;
		  
		}
		
		#if(substr($model,length($model)-4) ne '.pdb') ## proq will report no subfix
		#{
		#	$model .= '.pdb';
		#}
		if(!exists($LGA_score_list{$model}))
		{
		  next;
		}
		push @score_prediction, {
                name => $model,
                score => $score 
        }
		
		$model_num++;
	  }
	  close IN; 
	  
	#rank all the models by max score
	@score_prediction = sort { $b->{"score"} <=> $a->{"score"}} @model_info; 


	open(OUTTMP, ">$method_score.sorted") || die "can't create file $method_score.sorted.\n";
	for ($i = 0; $i < @score_prediction; $i++)
	{
		print OUTTMP $model_info[$i]->{"name"}, "\t", $model_info[$i]->{"score"}, "\n";  		
	}
	close OUTTMP; 

	  if($model_num!=$LGA_model_num)
	  {
		 print "The model number in $method_score ($model_num) not match model number ($LGA_model_num), removing it\n";
		 `mv $method_score $method_score.old_$check_iteration`;
		 $incomplete=1;
	  }
	}
	if($incomplete == 0)
	{
		print "\n\n!!!!!!!!!! All features are generated correctly\n\n";
		last;
	}
	print "\n\n##### (1) Re-Run feature generation with iteration $check_iteration\n\n";
	print("perl $H_script/P0_run_DeepQA.pl $targetname $seqfile $dir_models $dir_output\n");
	$status = system("perl $H_script/P0_run_DeepQA.pl $targetname $seqfile $dir_models $dir_output");
	if($status)# if failed, should we use at least one score?
	{
		die "Failed to run the feature generation\n";
	}
}

$DeepRank_finishtime = time();
$method_diff_hrs = ($DeepRank_finishtime - $DeepRank_starttime)/3600;

print "\n\n####### DeepRank prediction done within $method_diff_hrs hr!!!!!\n\n";




sub parse_pdb_row{
	my $row = shift;
	my $param = shift;
	my $result;
	$result = substr($row,6,5) if ($param eq "anum");
	$result = substr($row,12,4) if ($param eq "aname");
	$result = substr($row,16,1) if ($param eq "altloc");
	$result = substr($row,17,3) if ($param eq "rname");
	$result = substr($row,22,5) if ($param eq "rnum");
	$result = substr($row,21,1) if ($param eq "chain");
	$result = substr($row,30,8) if ($param eq "x");
	$result = substr($row,38,8) if ($param eq "y");
	$result = substr($row,46,8) if ($param eq "z");
	print "Invalid row[$row] or parameter[$param]" if (not defined $result);
	$result =~ s/\s+//g;
	return $result;
}
