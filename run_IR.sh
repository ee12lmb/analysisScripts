#!/bin/bash

# Script runs index_repeat from command line
# See relevant documentation in function (/project/souce/dev/...)
# Output filename is always placed in: /project/analysis/outputs/IR

function usage()
{
 echo "Usage: run_IR.sh [ infile ] [ step ] [ no. grains ] [ repeat ] [ seed ] [ index ] [ output name ]" 
 echo "Usage: alternatively, will run interactively if no arguments given"
}


#------------------------------------------------------------------------
# check if running quietly or accepting inputs

if [[ $# -eq 0 ]] 
then 

  echo
  printf "Input file:........ "
  read infile
  printf "Step:.............. "
  read step
  printf "No. grains:........ "
  read n
  printf "Repeat:............ "
  read repeat
  printf "Seed:.............. "
  read seed
  printf "Index:............. "
  read index
  printf "Output file name:.. "
  read outname
  echo "Running function with user inputs..."
  echo

else

  [[ $# -ne 4 ]] && usage && exit 1
  infile=$1
  step=$2
  n=$3
  repeat=$4
  seed=$5
  index=$6
  outname=$7

fi

#------------------------------------------------------------------------
# setup important dirs

outdir="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR"
devdir="/nfs/see-fs-01_teaching/ee12lmb/project/source/dev"
outfile=$outdir/$outname

#------------------------------------------------------------------------
# input checks
[[ ! -f $infile ]] && echo "Input file not found!" && usage && exit 1
[[ -f $outfile ]] && echo "Output file already exists!" && usage && exit 1

#------------------------------------------------------------------------
# Run matlab function

matlab -nodesktop -nodisplay -nosplash -r "addpath('/nfs/see-fs-01_teaching/ee12lmb/project/source/dev/'); setup_env; index_repeat('$infile',$step,$n,$repeat,$seed,'index','$index','outfile','$outfile'); exit;"

exit 0
