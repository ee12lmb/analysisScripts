#!/bin/bash
echo
# test script to run J-index matlab function from command line

# set up shell variables 
script=${0##*/}
funcpath="/nfs/see-fs-01_teaching/ee12lmb/project/source/dev/Jstrain"
analysis_dir="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/jstrain"


# input checks
# -------------------------------------------------------------------------------
[[ $# -ne 1 ]] && echo "$script: testrun [ texture file ]" && exit 1

infile=$1

[[ ! -f $infile ]] && echo "$script: input file does not exist, check file path" && exit 1
# -------------------------------------------------------------------------------


# output setup
# -------------------------------------------------------------------------------
# create output analysis dir if it doesn't exist
[[ ! -d $analysis_dir ]] && mkdir $analysis_dir  

# create new run dir inside analysis dir
rundir=$analysis_dir/$(date "+%y%m%d")_jstrain_$(date "+%H%M").run
[[ -d $rundir ]] && echo "Run directory already exists... wait a minute!"
mkdir $rundir

# create ouput pdf name
outfile="$rundir/output.pdf"

# create log filename
logfile="$rundir/README.txt"
#--------------------------------------------------------------------------------

echo "$(date): Running analysis script: $script" | tee $logfile
echo "---------------------------------------------------------------------" | tee -a $logfile

echo "$script: $(date): calling matlab function: jstrain" | tee -a $logfile
printf "FUNCTION DIR:\t$funcpath\n" | tee -a $logfile
printf "INPUT TEXTURE:\t$infile\n" | tee -a $logfile

matlab -nodesktop -nodisplay -nosplash -r "addpath('$funcpath'); jstrain('$infile','$outfile'); exit"
echo "done"

# crop pdf so plot fills page
pdfcrop $outfile "$rundir/temp-crop.pdf" > /dev/null
mv "$rundir/temp-crop.pdf" $outfile

printf "OUTPUT PDF:\t$outfile\n" | tee -a $logfile
printf "$script: $(date): finished.\n" | tee -a $logfile
exit 0
  
