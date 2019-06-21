#!/usr/bin/perl -w
 use FileHandle; # use FileHandles instead of open(),close()
 use Cwd;
 use Cwd 'abs_path';

######################## !!! customize settings here !!! ############################
#																					#
# Set directory of DeepRank databases and tools								        #

$DeepRank_db_tools_dir = "/data/commons/DeepRank_db_tools/";							        

######################## !!! End of customize settings !!! ##########################

######################## !!! Don't Change the code below##############


$install_dir = getcwd;
$install_dir=abs_path($install_dir);


if(!-s $install_dir)
{
	die "The DeepRank directory ($install_dir) is not existing, please revise the customize settings part inside the configure.pl, set the path as  your unzipped DeepRank directory\n";
}

if(!-d $DeepRank_db_tools_dir)
{
	die "The DeepRank databases/tools folder ($DeepRank_db_tools_dir) is not existing\n";
}

if ( substr($install_dir, length($install_dir) - 1, 1) ne "/" )
{
        $install_dir .= "/";
}

if ( substr($DeepRank_db_tools_dir, length($DeepRank_db_tools_dir) - 1, 1) ne "/" )
{
        $DeepRank_db_tools_dir .= "/";
}



print "checking whether the configuration file run in the installation folder ...";
$cur_dir = `pwd`;
chomp $cur_dir;
$configure_file = "$cur_dir/configure.pl";
if (! -f $configure_file || $install_dir ne "$cur_dir/")
{
        die "\nPlease check the installation directory setting and run the configure program under the main directory of DeepRank.\n";
}
print " OK!\n";



if (! -d $install_dir)
{
	die "can't find installation directory.\n";
}
if ( substr($install_dir, length($install_dir) - 1, 1) ne "/" )
{
	$install_dir .= "/"; 
}


######### check the DeepRank database and tools

$database_dir = "$DeepRank_db_tools_dir/databases";
$tools_dir = "$DeepRank_db_tools_dir/tools";

if(!(-d $database_dir) or !(-d $tools_dir))
{
	die "Failed to find databases and tools under $DeepRank_db_tools_dir/\n";
}

if($DeepRank_db_tools_dir eq "$cur_dir/")
{
	die "Same directory as DeepRank main folder. Differnt path for original databases/tools folder $DeepRank_db_tools_dir is recommended.\n";
}
#create link for databases and tools
`rm ${install_dir}databases`; 
`rm ${install_dir}tools`; 
`ln -s $database_dir ${install_dir}databases`;
`ln -s $tools_dir ${install_dir}tools`;


if (prompt_yn("DeepRank will be installed into <$install_dir> ")){

}else{
	die "The installation is cancelled!\n";
}
print "Start install DeepRank into <$install_dir>\n"; 



print "\n#########  (1) Configuring tools\n";

$option_list = "$install_dir/installation/DeepRank_configure_files/DeepRank_tools_list";

if (! -f $option_list)
{
        die "\nOption file $option_list not exists.\n";
}
configure_tools($option_list,'tools',$DeepRank_db_tools_dir);

print "\n#########  (2) Configuring scripts\n";

$option_list = "$install_dir/installation/DeepRank_configure_files/DeepRank_scripts_list";

if (! -f $option_list)
{
        die "\nOption file $option_list not exists.\n";
}
configure_file2($option_list,'src');
print "#########  Configuring scripts, done\n\n";



print "#########  (4) Configuring examples\n";

$option_list = "$install_dir/installation/DeepRank_configure_files/DeepRank_examples_list";

if (! -f $option_list)
{
        die "\nOption file $option_list not exists.\n";
}
system("rm $install_dir/installation/DeepRank_test_codes/*.sh");
configure_file2($option_list,'installation');
print "#########  Configuring examples, done\n\n\n";

system("chmod +x $install_dir/installation/DeepRank_test_codes/*sh");



system("cp $install_dir/src/run_DeepRank.sh $install_dir/bin/run_DeepRank.sh");
system("chmod +x $install_dir/bin/run_DeepRank.sh");



$tooldir = $DeepRank_db_tools_dir.'/tools/DeepQA/';
if(-d $tooldir)
{
	print "\n\n#########  Setting up DeepQA\n";
	chdir $tooldir;
	if(-f 'configure.pl')
	{
		$status = system("perl configure.pl 2>&1 &> /dev/null");
		if($status){
			die "Failed to run perl configure.pl \n";
			exit(-1);
		}
	}else{
		die "The configure.pl file for $tooldir doesn't exist, please contact us(Jie Hou: jh7x3\@mail.missouri.edu)\n";
	}
}

######
$tooldir = $DeepRank_db_tools_dir.'/tools/proq3/';
if(-d $tooldir)
{
	print "\n#########  Setting up proq3\n"; 
	chdir $tooldir;
	if(-f 'configure.pl')
	{
		$status = system("perl configure.pl 2>&1 &> /dev/null");
		if($status){
			die "Failed to run perl configure.pl \n";
			exit(-1);
		}
	}else{
		die "The configure.pl file for $tooldir doesn't exist, please contact us(Jie Hou: jh7x3\@mail.missouri.edu)\n";
	}
}


=pod

my($addr_mod9v15) = $DeepRank_db_tools_dir."/tools/modeller-9.15/bin/mod9.15";
if(-e $addr_mod9v15)
{
	print "\n#########  Setting up MODELLER 9v15 \n";
	if (!-s $addr_mod9v15) {
		die "Please check $addr_mod9v15, you can download the modeller and install it by yourself if the current one in the tool folder is not working well, the key is MODELIRANJE.  please install it to the folder tools/modeller-9.15, with the file mod9v7 in the bin directory\n";
	}

	my($deep_mod9v15) = $DeepRank_db_tools_dir."/tools/modeller-9.15/bin/modeller9v15local";
	$OUT = new FileHandle ">$deep_mod9v15";
	$IN=new FileHandle "$addr_mod9v15";
	while(defined($line=<$IN>))
	{
			chomp($line);
			@ttt = split(/\=/,$line);

			if(@ttt>1 && $ttt[0] eq "MODINSTALL9v15")
			{
					print $OUT "MODINSTALL9v15=\"$DeepRank_db_tools_dir/tools/modeller-9.15\"\n";
			}
			else
			{
					print $OUT $line."\n";
			}
	}
	$IN->close();
	$OUT->close();
	#system("chmod 777 $deep_mod9v16");
	$modeller_conf = $DeepRank_db_tools_dir."/tools/modeller-9.15/modlib/modeller/config.py";
	$OUT = new FileHandle ">$modeller_conf";
	print $OUT "install_dir = r\'$DeepRank_db_tools_dir/tools/modeller-9.15/\'\n";
	print $OUT "license = \'MODELIRANJE\'";
	$OUT->close();
	system("cp $deep_mod9v15 $addr_mod9v15");
	print "Done\n";
}
=cut

my($addr_mod9v16) = $DeepRank_db_tools_dir."/tools/modeller-9.16/bin/mod9.16";
if(-e $addr_mod9v16)
{
	print "\n#########  Setting up MODELLER 9v16 \n";
	if (!-s $addr_mod9v16) {
		die "Please check $addr_mod9v16, you can download the modeller and install it by yourself if the current one in the tool folder is not working well, the key is MODELIRANJE.  please install it to the folder tools/modeller-9.16, with the file mod9v7 in the bin directory\n";
	}

	my($deep_mod9v16) = $DeepRank_db_tools_dir."/tools/modeller-9.16/bin/modeller9v16local";
	$OUT = new FileHandle ">$deep_mod9v16";
	$IN=new FileHandle "$addr_mod9v16";
	while(defined($line=<$IN>))
	{
			chomp($line);
			@ttt = split(/\=/,$line);

			if(@ttt>1 && $ttt[0] eq "MODINSTALL9v16")
			{
					print $OUT "MODINSTALL9v16=\"$DeepRank_db_tools_dir/tools/modeller-9.16\"\n";
			}
			else
			{
					print $OUT $line."\n";
			}
	}
	$IN->close();
	$OUT->close();
	#system("chmod 777 $deep_mod9v16");
	$modeller_conf = $DeepRank_db_tools_dir."/tools/modeller-9.16/modlib/modeller/config.py";
	$OUT = new FileHandle ">$modeller_conf";
	print $OUT "install_dir = r\'$DeepRank_db_tools_dir/tools/modeller-9.16/\'\n";
	print $OUT "license = \'MODELIRANJE\'";
	$OUT->close();
	#system("chmod 777 $modeller_conf");
	system("cp $deep_mod9v16 $addr_mod9v16");
	print "Done\n";
}



$addr_scwrl4 = $DeepRank_db_tools_dir."/tools/scwrl4";
if(-d $addr_scwrl4)
{
	print "\n#########  Setting up scwrl4 \n";
	$addr_scwrl_orig = $addr_scwrl4."/"."Scwrl4.ini";
	$addr_scwrl_back = $addr_scwrl4."/"."Scwrl4.ini.back";
	system("cp $addr_scwrl_orig $addr_scwrl_back");
	@ttt = ();
	$OUT = new FileHandle ">$addr_scwrl_orig";
	$IN=new FileHandle "$addr_scwrl_back";
	while(defined($line=<$IN>))
	{
		chomp($line);
		@ttt = split(/\s+/,$line);
		
		if(@ttt>1 && $ttt[1] eq "FilePath")
		{
			print $OUT "\tFilePath\t=\t$addr_scwrl4/bbDepRotLib.bin\n"; 
		}
		else
		{
			print $OUT $line."\n";
		}
	}
	$IN->close();
	$OUT->close();
	print "Done\n";
}

####### tools compilation 

### install boost-1.55 
open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P1_install_boost.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P1_install_boost.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start compile boost (will take ~20 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools\n\n";
print OUT "cd boost_1_55_0\n\n";
print OUT "./bootstrap.sh  --prefix=$DeepRank_db_tools_dir/tools/boost_1_55_0\n\n";
print OUT "./b2\n\n";
print OUT "./b2 install\n\n";
close OUT;

#### install OpenBlas
open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P2_install_OpenBlas.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P2_install_OpenBlas.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start compile OpenBlas (will take ~5 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools\n\n";
print OUT "cd OpenBLAS\n\n";
print OUT "make clean\n\n";
print OUT "make\n\n";
print OUT "make PREFIX=$DeepRank_db_tools_dir/tools/OpenBLAS install\n\n";
close OUT;


#### install freecontact

open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P3_install_freecontact.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P3_install_freecontact.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start compile freecontact (will take ~1 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools/DNCON2\n\n";
print OUT "cd freecontact-1.0.21\n\n";
print OUT "autoreconf -f -i\n\n";
print OUT "make clean\n\n";
print OUT "./configure --prefix=$DeepRank_db_tools_dir/tools/DNCON2/freecontact-1.0.21 LDFLAGS=\"-L$DeepRank_db_tools_dir/tools/OpenBLAS/lib -L$DeepRank_db_tools_dir/tools/boost_1_55_0/lib\" CFLAGS=\"-I$DeepRank_db_tools_dir/tools/OpenBLAS/include -I$DeepRank_db_tools_dir/tools/boost_1_55_0/include\"  CPPFLAGS=\"-I$DeepRank_db_tools_dir/tools/OpenBLAS/include -I$DeepRank_db_tools_dir/tools/boost_1_55_0/include\" --with-boost=$DeepRank_db_tools_dir/tools/boost_1_55_0/\n\n";
print OUT "make\n\n";
print OUT "make install\n\n";
close OUT;


#### create python virtual environment

open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P4_python_virtual.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P5_python_virtual.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start install python virtual environment (will take ~1 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools\n\n";
print OUT "rm -rf python_virtualenv\n\n";
print OUT "virtualenv python_virtualenv\n\n";
print OUT "source $DeepRank_db_tools_dir/tools/python_virtualenv/bin/activate\n\n";
print OUT "pip install --upgrade pip\n\n";
print OUT "pip install --upgrade numpy==1.12.1\n\n";
print OUT "pip install --upgrade keras==1.2.2\n\n";
print OUT "pip install --upgrade theano==0.9.0\n\n";
print OUT "pip install --upgrade h5py\n\n";
print OUT "pip install --upgrade matplotlib\n\n";
print OUT "pip install --upgrade pandas\n\n";
print OUT "pip install --upgrade sklearn\n\n";
print OUT "pip install --upgrade plotly\n\n";
print OUT "pip install --upgrade np_utils\n\n";
print OUT "pip install --upgrade pillow\n\n";
print OUT "NOW=\$(date +\"%m-%d-%Y\")\n\n";
print OUT "mkdir -p ~/.keras\n\n";
print OUT "cp ~/.keras/keras.json ~/.keras/keras.json.\$NOW.\$RANDOM\n\n";
print OUT "cp $install_dir/installation/DeepRank_configure_files/keras_DeepRank.json ~/.keras/keras.json\n\n";
close OUT;

open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P5_python_virtual_keras2.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P5_python_virtual.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start install python virtual environment for keras2 (will take ~1 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools\n\n";
print OUT "rm -rf python_virtualenv_keras2\n\n";
print OUT "virtualenv python_virtualenv_keras2\n\n";
print OUT "source $DeepRank_db_tools_dir/tools/python_virtualenv_keras2/bin/activate\n\n";
print OUT "pip install --upgrade pip\n\n";
print OUT "pip install --upgrade numpy\n\n";
print OUT "pip install --upgrade keras\n\n";
print OUT "pip install --upgrade Theano\n\n";
print OUT "pip install --upgrade h5py\n\n";
close OUT;

#### install EMBOSS-6.6.0

open(OUT,">$install_dir/installation/DeepRank_manually_install_files/P6_install_EMBOSS.sh") || die "Failed to open file $install_dir/installation/DeepRank_manually_install_files/P4_install_scwrl4.sh\n";
print OUT "#!/bin/bash -e\n\n";
print OUT "echo \" Start compile freecontact (will take ~3 min)\"\n\n";
print OUT "cd $DeepRank_db_tools_dir/tools/EMBOSS-6.6.0\n\n";
print OUT "make clean\n\n";
print OUT "./configure --prefix=$DeepRank_db_tools_dir/tools/EMBOSS-6.6.0\n\n";
print OUT "make\n\n";
print OUT "make install\n\n";
close OUT;


### compress benchmark dataset
chdir("$install_dir/installation");
`tar -zxf benchmark.tar.gz`;
chdir("$install_dir/examples");
`tar -zxf T0980s1.tar.gz`;


print "#########  (7) Configuring DeepRank programs\n";
$method_file = "$install_dir/method.list";
$option_list = "$install_dir/installation/DeepRank_configure_files/DeepRank_programs_list";

`rm $install_dir/installation/DeepRank_programs/*sh`;
`rm $install_dir/bin/*sh`;

$python_env = 0;
$boost_enable = 0;

open(OUT,">$install_dir/Method_tutorial.txt") || die "Failed to open file $install_dir/Method_tutorial.txt\n";
if(!(-e $method_file) or !(-e $option_list))
{
	print "\nFailed to find method file ($method_file and $option_list), please contact us!\n\n";
}else{
	open(IN,$option_list) || die "Failed to open file $option_list\n";
	@contents = <IN>;
	close IN;
	%method_programs=();
	foreach $line (@contents)
	{
		chomp $line;
		if(substr($line,0,1) eq '#')
		{
			next;
		}
		$line =~ s/^\s+|\s+$//g;
		if($line eq '')
		{
			next;
		}
		@tmp = split(':',$line);
		$method_programs{$tmp[0]} = $tmp[1];
	}
	
	open(IN,$method_file) || die "Failed to open file $method_file\n";
	@contents = <IN>;
	open(TMP,">$install_dir/installation/DeepRank_configure_files/option.tmp");
	foreach $method (@contents)
	{
		chomp $method;
		if(substr($method,0,1) eq '#')
		{
			next;
		}
		$method =~ s/^\s+|\s+$//g;
		if($method eq '')
		{
			next;
		}
		if(exists($method_programs{"${method}"}))
		{
			$file = $method_programs{"${method}"};
			print TMP "$file\n";
		}
	}
	close TMP;
	configure_file2("$install_dir/installation/DeepRank_configure_files/option.tmp",'installation');
	`rm $install_dir/installation/DeepRank_configure_files/option.tmp`;
	`cp $install_dir/installation/DeepRank_programs/*sh $install_dir/bin/`;
	
	print "#########  Configuring examples, done\n\n\n";
	
	$method_indx = 0;
	foreach $method (@contents)
	{
		chomp $method;
		if(substr($method,0,1) eq '#')
		{
			next;
		}
		$method =~ s/^\s+|\s+$//g;
		if($method eq '')
		{
			next;
		}
		$method_indx++;
		
		print  "\n################################################################# Method $method_indx: $method  #################################################################\n\n";
		print  OUT "\n################################################################# Method $method_indx: $method  #################################################################\n\n";
		if(exists($method_programs{"${method}"}))
		{
			$file = $method_programs{"${method}"};
			@tmp = split(/\//,$file);
			$program_file = pop @tmp;
			if(-e "$install_dir/bin/$program_file")
			{
				print OUT "Usage: $install_dir/bin/$program_file <target id> <fasta> <model directory> <output-directory>\n\n";
				print "Usage: $install_dir/bin/$program_file <target id> <fasta> <model directory> <output-directory>\n\n";
				print OUT "\t** Example: $install_dir/bin/$program_file T0980s1 $install_dir/examples/T0980s1.fasta $install_dir/examples/T0980s1 $install_dir/test_out/T0980s1_$method\n\n";
				print "\t** Example: $install_dir/bin/$program_file T0980s1 $install_dir/examples/T0980s1.fasta $install_dir/examples/T0980s1 $install_dir/test_out/T0980s1_$method\n\n";
			}
			
		}
		
		if($method eq 'dncon2')
		{
			$python_env = 1;
			$boost_enable = 1;
		}
	}
	

}
close OUT;

if(-d "$install_dir/tools/DeepQA/tools/spine_X")
{
	if(-l "$install_dir/tools/spine_X")
	{	
		`rm $install_dir/tools/spine_X`;
	}
	`cp $install_dir/tools/DeepQA/tools/spine_X/DeepQA_spX.pl $install_dir/tools/DeepQA/tools/spine_X/spX.pl`;
	`ln -s $install_dir/tools/DeepQA/tools/spine_X $install_dir/tools/spine_X`;
}

if(-d "$install_dir/tools/DeepQA/tools/sspro4")
{
	if(-l "$install_dir/tools/sspro4")
	{
		`rm $install_dir/tools/sspro4`;
	}
	`ln -s $install_dir/tools/DeepQA/tools/sspro4 $install_dir/tools/sspro4`; 
}

system("chmod +x $install_dir/installation/DeepRank_test_codes/*sh");

system("cp $install_dir/src/run_DeepRank.sh $install_dir/bin/run_DeepRank.sh");
system("chmod +x $install_dir/bin/*.sh");


system("mv $install_dir/installation/DeepRank_test_codes/T0-run-DeepRank-*.sh $install_dir/examples");
system("chmod +x $install_dir/examples/*.sh");



sub prompt_yn {
  my ($query) = @_;
  my $answer = prompt("$query (Y/N): ");
  return lc($answer) eq 'y';
}
sub prompt {
  my ($query) = @_; # take a prompt string as argument
  local $| = 1; # activate autoflush to immediately show the prompt
  print $query;
  chomp(my $answer = <STDIN>);
  return $answer;
}


sub configure_file{
	my ($option_list,$prefix) = @_;
	open(IN,$option_list) || die "Failed to open file $option_list\n";
	$file_indx=0;
	while(<IN>)
	{
		$file = $_;
		chomp $file;
		if ($file =~ /^$prefix/)
		{
			$option_default = $install_dir.$file.'.default';
			$option_new = $install_dir.$file;
			$file_indx++;
			print "$file_indx: Configuring $option_new\n";
			if (! -f $option_default)
			{
					die "\nOption file $option_default not exists.\n";
			}	
			
			open(IN1,$option_default) || die "Failed to open file $option_default\n";
			open(OUT1,">$option_new") || die "Failed to open file $option_new\n";
			while(<IN1>)
			{
				$line = $_;
				chomp $line;

				if(index($line,'SOFTWARE_PATH')>=0)
				{
					$line =~ s/SOFTWARE_PATH/$install_dir/g;
					$line =~ s/\/\//\//g;
					print OUT1 $line."\n";
				}else{
					print OUT1 $line."\n";
				}
			}
			close IN1;
			close OUT1;
		}
	}
	close IN;
}


sub configure_tools{
	my ($option_list,$prefix,$DBtool_path) = @_;
	open(IN,$option_list) || die "Failed to open file $option_list\n";
	$file_indx=0;
	while(<IN>)
	{
		$file = $_;
		chomp $file;
		if ($file =~ /^$prefix/)
		{
			$option_default = $DBtool_path.$file.'.default';
			$option_new = $DBtool_path.$file;
			$file_indx++;
			print "$file_indx: Configuring $option_new\n";
			if (! -f $option_default)
			{
					next;
					#die "\nOption file $option_default not exists.\n";
			}	
			
			open(IN1,$option_default) || die "Failed to open file $option_default\n";
			open(OUT1,">$option_new") || die "Failed to open file $option_new\n";
			while(<IN1>)
			{
				$line = $_;
				chomp $line;

				if(index($line,'SOFTWARE_PATH')>=0)
				{
					$line =~ s/SOFTWARE_PATH/$DBtool_path/g;
					$line =~ s/\/\//\//g;
					print OUT1 $line."\n";
				}else{
					print OUT1 $line."\n";
				}
			}
			close IN1;
			close OUT1;
		}
	}
	close IN;
}



sub configure_file2{
	my ($option_list,$prefix) = @_;
	open(IN,$option_list) || die "Failed to open file $option_list\n";
	$file_indx=0;
	while(<IN>)
	{
		$file = $_;
		chomp $file;
		if ($file =~ /^$prefix/)
		{
			@tmparr = split('/',$file);
			$filename = pop @tmparr;
			chomp $filename;
			$filepath = join('/',@tmparr);
			$option_default = $install_dir.$filepath.'/.'.$filename.'.default';
			$option_new = $install_dir.$file;
			$file_indx++;
			print "$file_indx: Configuring $option_new\n";
			if (! -f $option_default)
			{
					die "\nOption file $option_default not exists.\n";
			}	
			
			open(IN1,$option_default) || die "Failed to open file $option_default\n";
			open(OUT1,">$option_new") || die "Failed to open file $option_new\n";
			while(<IN1>)
			{
				$line = $_;
				chomp $line;

				if(index($line,'SOFTWARE_PATH')>=0)
				{
					$line =~ s/SOFTWARE_PATH/$install_dir/g;
					$line =~ s/\/\//\//g;
					print OUT1 $line."\n";
				}else{
					print OUT1 $line."\n";
				}
			}
			close IN1;
			close OUT1;
		}
	}
	close IN;
}





=pod
database downloading 


/home/casp13/DeepRank_package/software/prosys_database/cm_lib/chain_stx_info
/home/casp13/DeepRank_package/software/prosys_database/cm_lib/pdb_cm
/home/casp13/DeepRank_package/software/prosys_database/cm_lib/pdb_cm.phr
/home/casp13/DeepRank_package/software/prosys_database/cm_lib/pdb_cm.pin
/home/casp13/DeepRank_package/software/prosys_database/cm_lib/pdb_cm.psq
/home/casp13/DeepRank_package/software/prosys_database/cm_lib/pdb_cm_all_sel.fasta 


/home/casp13/DeepRank_package/software/prosys_database/atom.tar.gz

/home/casp13/DeepRank_package/software/prosys_database/nr_latest/



=cut
