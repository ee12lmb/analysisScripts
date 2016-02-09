#!/bin/bash

# Script runs m_indexCont from command line
# See relevant documentation in function (/project/souce/dev/...)
# Output filename is always placed in: /project/analysis/outputs/M_Cont

function usage()
{
 echo "Usage: run_M_Cont.sh [ infile ] [ no. grains ] [ seed ] [ output name ]" 
 echo "Usage: alternatively, will run interactively if no arguments given"
}


#------------------------------------------------------------------------
# check if running quietly or accepting inputs

if [[ $# -eq 0 ]] 
then 

  echo
  printf "Input file:........ "
  read infile
  printf "No. grains:........ "
  read n
  printf "Seed:.............. "
  read seed
  printf "Output file name:.. "
  read outname
  echo "Running function with user inputs..."
  echo

else

  [[ $# -ne 4 ]] && usage && exit 1
  infile=$1
  n=$2
  seed=$3
  outname=$4

fi

#------------------------------------------------------------------------
# setup important dirs

outdir="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Cont"
devdir="/nfs/see-fs-01_teaching/ee12lmb/project/source/dev"
outfile=$outdir/$outname

#------------------------------------------------------------------------
# input checks
[[ ! -f $infile ]] && echo "Input file not found!" && usage && exit 1
[[ -f $outfile ]] && echo "Output file already exists!" && usage && exit 1

#------------------------------------------------------------------------
# Run matlab function

matlab -nodesktop -nodisplay -nosplash -r "addpath('/nfs/see-fs-01_teaching/ee12lmb/project/source/dev/'); setup_env; m_indexCont('$infile',$n,$seed,'outfile','$outfile'); exit;"

exit 0
