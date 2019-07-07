# DeepRank
The deep learning method for ranking protein structural models


**(1) Download DeepRank package (short path is recommended)**

```
git clone https://github.com/jianlin-cheng/DeepRank.git

(If fail, try username) git clone https://huge200890@github.com/jianlin-cheng/DeepRank.git

cd DeepRank
```

**(2) Setup the tools and download the database (required)**

```
a. edit method.list

    uncomment the methods that you would like to run in DeepRank method (i.e., DeepQA, Contact) 

b. edit setup_database.pl
    (i) Manually create folder for database (i.e., /data/commons/DeepRank_db_tools/)
    (ii) Set the path of variable '$DeepRank_db_tools_dir' for multicom databases and tools (i.e., /data/commons/DeepRank_db_tools/).

c. perl setup_database.pl
```

Please refer to 'cite_methods_for_publication.txt' to cite the methods that you use in DeepRank system for publication. The tools can be also downloaded from their official websites.


**(3) Configure DeepRank system (required)**

```
a. edit configure.pl

b. set the path of variable '$DeepRank_db_tools_dir' for multicom databases and tools (i.e., /data/commons/DeepRank_db_tools/).

c. save configure.pl

perl configure.pl
```

**(4) Set theano as backend for keras (required)**

Change the contents in '~/.keras/keras.json'. DNCON2 is currently running based on theano-compiled models.
```
$ mkdir ~/.keras
$ vi ~/.keras/keras.json


{
    "epsilon": 1e-07,
    "floatx": "float32",
    "image_data_format": "channels_last",
    "backend": "theano"
}
```


**(5)  Install "zoo" package by launching R and typing install.packages("zoo") (assume R is pre-installed) **

```
$R

>install.packages("zoo")
>library("zoo")
>q()
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
   $ sh bin/run_DeepRank.sh <target id> <file name>.fasta <model directory> <output folder>

   Example:
   $ sh bin/run_DeepRank.sh T0980s1 /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1 /home/jh7x3/DeepRank/test_out/T0980s1_out
   
   $ sh bin/run_DeepRank_lite.sh T0980s1 /home/jh7x3/DeepRank/examples/T0980s1.fasta /home/jh7x3/DeepRank/examples/T0980s1 /home/jh7x3/DeepRank/test_out/T0980s1_lite_out
```

**(10) Run individual methods for quality assessment**

```
Examples:
   DeepQA:
   $ sh bin/P1-run-DeepRank-DeepQA.sh <target id> <file name>.fasta <model directory> <output folder>

   proq3:
   $ sh bin/P2-run-DeepRank-proq3.sh <target id> <file name>.fasta <model directory> <output folder>
   
   dope:
   $ sh bin/P3-run-DeepRank-dope.sh <target id> <file name>.fasta <model directory> <output folder>
   
   OPUS:
   $ sh bin/P4-run-DeepRank-OPUS.sh <target id> <file name>.fasta <model directory> <output folder>
   
   RF_SRS:
   $ sh bin/P5-run-DeepRank-RF_SRS.sh <target id> <file name>.fasta <model directory> <output folder>
   
   vonorota:
   $ sh bin/P6-run-DeepRank-vonorota.sh <target id> <file name>.fasta <model directory> <output folder>
   
   Apollo:
   $ sh bin/P7-run-DeepRank-Apollo.sh <target id> <file name>.fasta <model directory> <output folder>
   
   ModFoldclust2:
   $ sh bin/P7-run-DeepRank-ModFoldclust2.sh <target id> <file name>.fasta <model directory> <output folder>
   
   pcons:
   $ sh bin/P9-run-DeepRank-pcons.sh <target id> <file name>.fasta <model directory> <output folder>
   
   SBROD:
   $ sh bin/P10-run-DeepRank-SBROD.sh <target id> <file name>.fasta <model directory> <output folder>
   
   contact:
   $ sh bin/P11-run-DeepRank-contact.shh <target id> <file name>.fasta <model directory> <output folder>
   
```
