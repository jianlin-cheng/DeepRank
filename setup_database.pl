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


if(!-s $DeepRank_db_tools_dir)
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
					if(-e "$uniprot20_dir/uniprot20_2016_02/download.done" and -e "$uniprot20_dir/uniprot20_2016_02/uniprot20_2016_02_hhm_db" )
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





