#!/usr/bin/perl -w
 use FileHandle; # use FileHandles instead of open(),close()
 use Cwd;
 use Cwd 'abs_path';

 # perl /home/jh7x3/DeepRank_v1.1/setup_database.pl
 
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

if ( substr($install_dir, length($install_dir) - 1, 1) ne "/" )
{
        $install_dir .= "/";
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


if(!(-d $DeepRank_db_tools_dir))
{
	`mkdir $DeepRank_db_tools_dir`;
}
$DeepRank_db_tools_dir=abs_path($DeepRank_db_tools_dir);



if ( substr($DeepRank_db_tools_dir, length($DeepRank_db_tools_dir) - 1, 1) ne "/" )
{
        $DeepRank_db_tools_dir .= "/";
}

if (prompt_yn("DeepRank database will be installed into <$DeepRank_db_tools_dir> ")){

}else{
	die "The installation is cancelled!\n";
}


print "Start install DeepRank into <$DeepRank_db_tools_dir>\n"; 



chdir($DeepRank_db_tools_dir);

$database_dir = "$DeepRank_db_tools_dir/databases";
$tools_dir = "$DeepRank_db_tools_dir/tools";


if(!-s $database_dir)
{
	`mkdir $database_dir`;
}
if(!-s $tools_dir)
{
	`mkdir $tools_dir`;
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
print OUT "mkdir -p ~/.keras\n\n";
print OUT "cp ~/.keras/keras.json ~/.keras/keras.json.\$NOW.\$RANDOM\n\n";
print OUT "cp $install_dir/installation/DeepRank_configure_files/keras_DeepRank.json ~/.keras/keras.json\n\n";
print OUT "#rm -rf python_virtualenv\n\n";
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



#### (1) Download basic tools
print("\n#### (1) Download basic tools\n\n");

chdir($tools_dir);
$basic_tools_list = "scwrl4.tar.gz;TMscore_32.tar.gz;";
@basic_tools = split(';',$basic_tools_list);
foreach $tool (@basic_tools)
{
	$toolname = substr($tool,0,index($tool,'.tar.gz'));
	if(-d "$tools_dir/$toolname")
	{
		if(-e "$tools_dir/$toolname/download.done")
		{
			print "\t$toolname is done!\n";
			next;
		}
	}elsif(-f "$tools_dir/$toolname")
	{
			print "\t$toolname is done!\n";
			next;
	}
	-e $tool || `rm $tool`;
	`wget http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/tools/$tool`;
	if(-e "$tool")
	{
		print "\n\t$tool is found, start extracting files......\n\n";
		`tar -zxf $tool`;
		if(-d $toolname)
		{
			`echo 'done' > $toolname/download.done`;
		}
		`rm $tool`;
	}else{
		die "Failed to download $tool from http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/tools, please contact chengji\@missouri.edu\n";
	}
}


#### (2) Setting up tools and databases for methods
print("\n#### (2) Setting up tools and databases for methods\n\n");

$method_file = "$install_dir/method.list";
$method_info = "$install_dir/installation/server_info";

if(!(-e $method_file) or !(-e $method_info))
{
	print "\nFailed to find method file ($method_file and $method_info), please contact us!\n\n";
}else{
	
	open(IN,$method_info) || die "Failed to open file $method_info\n";
	@contents = <IN>;
	close IN;
	%method_db_tools=();
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
		$method_db_tools{$tmp[0]} = $tmp[1];
	}
	
	open(IN,$method_file) || die "Failed to open file $method_file\n";
	@contents = <IN>;
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
		if(exists($method_db_tools{"${method}_tools"}) and exists($method_db_tools{"${method}_databases"}))
		{
			print "\n\tSetting for method <$method>\n\n";
			### tools
			chdir($tools_dir);
			$basic_tools_list = $method_db_tools{"${method}_tools"};
			@basic_tools = split(';',$basic_tools_list);
			foreach $tool (@basic_tools)
			{
				$toolname = substr($tool,0,index($tool,'.tar.gz'));
				
				if(-d "$tools_dir/$toolname")
				{
					if(-e "$tools_dir/$toolname/download.done")
					{
						print "\t$toolname is done!\n";
						next;
					}
				}elsif(-f "$tools_dir/$toolname")
				{
						print "\t$toolname is done!\n";
						next;
				}				
				-e $tool || `rm $tool`;
				`wget http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/tools/$tool`;
				if(-e "$tool")
				{
					print "\n\t\t$tool is found, start extracting files......\n\n";
					`tar -zxf $tool`;
					
					chdir($tools_dir);
					if(-d "$tools_dir/$toolname")
					{
						`echo 'done' > $toolname/download.done`;
					}
					`rm $tool`;
				}else{
					die "Failed to download $tool from http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/tools, please contact chengji\@missouri.edu\n";
				}
			}
			
			### databases
			chdir($database_dir);
			$basic_db_list = $method_db_tools{"${method}_databases"};
			@basic_db = split(';',$basic_db_list);
			foreach $db (@basic_db)
			{
				if($db eq 'None')
				{
					next;
				}
				if($db eq 'uniprot20/uniprot20_2016_02')
				{
					
					chdir("$database_dir/$db");
					
					
					$uniprot20_dir = "$DeepRank_db_tools_dir/databases/uniprot20/";
					if(-e "$uniprot20_dir/uniprot20_2016_02/download.done" and -e "$uniprot20_dir/uniprot20_2016_02/uniprot20_2016_02_hhm_db" and -e "$uniprot20_dir/uniprot20_2016_02/uniprot20_2016_02_a3m_db" )
					{
						print "\t\t$db is done!\n";
						next;
					}
					
					-d $uniprot20_dir || `mkdir $uniprot20_dir/`;;
					chdir($uniprot20_dir);
					
					if(-e "uniprot20_2016_02/uniprot20_2016_02_hhm.ffdata")
					{
						print "\t\tuniprot20_2016_02 has been downloaded, skip!\n";
						`echo 'done' > uniprot20_2016_02/download.done`;
					
					}else{
						print("\n\t\t#### Download uniprot20\n\n");
						-e "uniprot20_2016_02.tgz" || `rm uniprot20_2016_02.tgz`;
						`wget http://wwwuser.gwdg.de/~compbiol/data/hhsuite/databases/hhsuite_dbs/old-releases/uniprot20_2016_02.tgz`;
						if(-e "uniprot20_2016_02.tgz")
						{
							print "\t\tuniprot20_2016_02.tgz is found, start extracting files......\n";
							`tar -xf uniprot20_2016_02.tgz`;
							`echo 'done' > uniprot20_2016_02/download.done`;
							`rm uniprot20_2016_02.tgz`;
						}else{
							die "Failed to download uniprot20_2016_02.tgz from http://wwwuser.gwdg.de/~compbiol/data/hhsuite/databases/hhsuite_dbs/old-releases/\n";
						}

					}
					chdir("$uniprot20_dir/uniprot20_2016_02/");
					if(-l "uniprot20_2016_02_a3m_db")
					{
						`rm uniprot20_2016_02_a3m_db`; 
						`rm uniprot20_2016_02_hhm_db`; 
					}
				
					`ln -s uniprot20_2016_02_a3m.ffdata uniprot20_2016_02_a3m_db`;
					`ln -s uniprot20_2016_02_hhm.ffdata uniprot20_2016_02_hhm_db`;
					
					next;
				}
				
				$dbname = substr($db,0,index($db,'.tar.gz'));
				if(-e "$database_dir/$dbname/download.done")
				{
					print "\t\t$dbname is done!\n";
					next;
				}
				
				if($db eq 'uniref.tar.gz')
				{
					$uniref_dir = "$DeepRank_db_tools_dir/databases/uniref";
					if(!(-d "$uniref_dir"))
					{
						`mkdir $uniref_dir`;
					}
					chdir("$DeepRank_db_tools_dir/databases/uniref/");
					if(-e "uniref90.pal")
					{
						print "\t$uniref_dir/uniref90 has been formatted, skip!\n";
					}elsif(-e "uniref90.fasta")
					{
						
						print "\tuniref90.fasta is found, start formating......\n";
						`$tools_dir/DNCON2/blast-2.2.26/bin/formatdb -i uniref90.fasta -o T -t uniref90 -n uniref90`;
					}else{
						-e "uniref90.fasta.gz" || `rm uniref90.fasta.gz`;
						`wget ftp://ftp.uniprot.org/pub/databases/uniprot/uniref/uniref90/uniref90.fasta.gz`;
						if(-e "uniref90.fasta.gz")
						{
							print "\tuniref90.fasta.gz is found, start extracting files\n";
						}else{
							die "Failed to download uniref90.fasta.gz from ftp://ftp.uniprot.org/pub/databases/uniprot/uniref/uniref90/\n";
						}
						`gzip -d uniref90.fasta.gz`;
						`$tools_dir/DNCON2/blast-2.2.26/bin/formatdb -i uniref90.fasta -o T -t uniref90 -n uniref90`;
					}
					next;
				}
				`wget http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/databases/$db`;
				if(-e "$db")
				{
					print "\t\t$db is found, start extracting files......\n\n";
					`tar -zxf $db`;
					
					`echo 'done' > $dbname/download.done`;
					`rm $db`;
				}else{
					die "Failed to download $db from http://sysbio.rnet.missouri.edu/bdm_download/DeepRank_db_tools/databases, please contact chengji\@missouri.edu\n";
				}
			}
			
		}else{
			print "Failed to find database/tool definition for method $method\n";
		}
	}
}




print "\n#########  (1) Configuring tools\n";

$option_list = "$install_dir/installation/DeepRank_configure_files/DeepRank_tools_list";

if (! -f $option_list)
{
        die "\nOption file $option_list not exists.\n";
}
configure_tools($option_list,'tools',$DeepRank_db_tools_dir);



$tooldir = $DeepRank_db_tools_dir.'/tools/DeepQA/';
if(-d $tooldir)
{
	print "\n\n#########  Setting up DeepQA\n";
	chdir $tooldir;
	if(-f 'configure.pl')
	{
		$status = system("perl configure.pl 2>&1 &> /dev/null");
		if($status){
			die "Failed to run perl configure.pl, possible reason is the permission conflict or incorrect software installation.\nIf the database and tools have already been configured, repeated configuration is not necessary.\n";
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
			die "Failed to run perl configure.pl, possible reason is the permission conflict or incorrect software installation.\nIf the database and tools have already been configured, repeated configuration is not necessary.\n";
			exit(-1);
		}
	}else{
		die "The configure.pl file for $tooldir doesn't exist, please contact us(Jie Hou: jh7x3\@mail.missouri.edu)\n";
	}
}


print "#########  Setting up sspro4\n";
$tooldir = $DeepRank_db_tools_dir.'/tools/sspro4/';
chdir $tooldir;
if(-f 'configure.pl')
{
	$status = system("perl configure.pl");
	if($status){
		die "Failed to run perl configure.pl \n";
		exit(-1);
	}
}else{
	die "The configure.pl file for $tooldir doesn't exist, please contact us(Jie Hou: jh7x3\@mail.missouri.edu)\n";
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


=pod
if(-d "$DeepRank_db_tools_dir/tools/DeepQA/tools/spine_X")
{
	if(-l "$DeepRank_db_tools_dir/tools/spine_X")
	{	
		`rm $DeepRank_db_tools_dir/tools/spine_X`;
	}
	`cp $DeepRank_db_tools_dir/tools/DeepQA/tools/spine_X/DeepQA_spX.pl $DeepRank_db_tools_dir/tools/DeepQA/tools/spine_X/spX.pl`;
	`ln -s $DeepRank_db_tools_dir/tools/DeepQA/tools/spine_X $DeepRank_db_tools_dir/tools/spine_X`;
}

if(-d "$DeepRank_db_tools_dir/tools/DeepQA/tools/sspro4")
{
	if(-l "$DeepRank_db_tools_dir/tools/sspro4")
	{
		`rm $DeepRank_db_tools_dir/tools/sspro4`;
	}
	`ln -s $DeepRank_db_tools_dir/tools/DeepQA/tools/sspro4 $DeepRank_db_tools_dir/tools/sspro4`; 
}
=cut
`chmod -R 755 $DeepRank_db_tools_dir/tools/spine_X`;
`chmod -R 755 $DeepRank_db_tools_dir/tools/sspro4`;
`chmod -R 755 $DeepRank_db_tools_dir/tools/DNCON2`; 




print "\n\n";




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



