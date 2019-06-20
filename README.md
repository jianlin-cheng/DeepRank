# DeepRank
The deep learning method for ranking protein structural models


**(1) Download DeepRank package (short path is recommended)**

```
cd /home/DeepRank
git clone https://github.com/jianlin-cheng/DeepRank.git
cd DeepRank
```

**(2) Setup the tools and download the database (required)**

```
a. edit method.list

    uncomment the methods that you would like to run in DeepRank method (i.e., DeepQA, Contact) 

b. edit setup_database.pl

    set the path of variable '$DeepRank_db_tools_dir' for multicom databases and tools (i.e., /home/DeepRank_db_tools/).

c. perl setup_database.pl
```

Please refer to 'cite_methods_for_publication.txt' to cite the methods that you use in DeepRank system for publication. The tools can be also downloaded from their official websites.


**(3) Configure DeepRank system (required)**

```
a. edit configure.pl

b. set the path of variable '$DeepRank_db_tools_dir' for multicom databases and tools (i.e., /home/DeepRank_db_tools/).

c. save configure.pl

perl configure.pl
```

**(4) Mannally configure tools (required)**
*** one-time installation. If the path is same as before, the configurations can be skipped.
```
cd installation/DeepRank_manually_install_files

$ sh ./P1_install_boost.sh 
(** may take ~20 min)

$ sh ./P2_install_OpenBlas.sh 
(** take ~1 min)

$ sh ./P3_install_freecontact.sh 
(** take ~1 min)

$ sh ./P4_python_virtual.sh 
(** take ~1 min)

$ sh ./P5_python_virtual_keras2.sh 
(** take ~1 min)

$ sh ./P6_install_EMBOSS.sh 
(** take ~5 min)
```

**(5) Set theano as backend for keras (required)**

Change the contents in '~/.keras/keras.json'. DNCON2 is currently running based on theano-compiled models.
```
$ vi ~/.keras/keras.json


{
    "epsilon": 1e-07,
    "floatx": "float32",
    "image_data_format": "channels_last",
    "backend": "theano"
}
```

**(6) Testing the individual tools in DeepRank (recommended)**

```
cd installation/DeepRank_test_codes

   
a. Sequential testing 
    perl test_DeepRank_all_parallel.pl
  
b. Parallel tesing up to 5 jobs at same time
    perl test_DeepRank_all_parallel.pl 5
    
```

**(7) Validate the individual predictons**

```

cd installation/DeepRank_test_codes
sh T99-run-validation.sh

```

**(8) Testing the integrated DeepRank method (recommended)**

```

cd examples
sh T0-run-DeepRank-T0980s1.sh

```

**(9) Run DeepRank for quality assessment**

```
   Usage:
   $ sh bin/run_DeepRank.sh <target id> <file name>.fasta <model directory>  <output folder>

   Example:
   $ sh bin/run_multicom.sh T0980s1 examples/T0980s1.fasta test_out/T0980s1_out
```

**(10) Run individual methods for quality assessment**

```
Examples:
   hhsearch:
   $ sh bin/P1-run-hhsearch.sh <target id> <file name>.fasta  <output folder>
   
   dncon2:
   $ sh bin/P4-run-dncon2.sh <target id> <file name>.fasta  <output folder>

   hhsuite:
   $ sh bin/P11-run-hhsuite.sh <target id> <file name>.fasta  <output folder>

   hhblits3:
   $ sh bin/P24-run-hhblits3.sh <target id> <file name>.fasta  <output folder>

   confold:
   $ sh bin/P27-run-confold.sh <target id> <file name>.fasta  <output folder>

```
