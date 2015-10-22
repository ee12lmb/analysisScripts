#!/bin/bash
echo
# test script to run J-index matlab function from command line

# set up shell variables 
script=${0##*/}
mfunc="/nfs/see-fs-01_teaching/ee12lmb/project/source/intial_scripts/jstrain"
funcpath="/nfs/see-fs-01_teaching/ee12lmb/project/source/dev/Jstrain"

echo "Running analysis script: $script"
echo "------------------------------------"

# input checks
[[ $# -ne 2 ]] && echo "$script: testrun [ texture file ] [ output plot pdf ]" && exit 1
[[ $2 != *.pdf ]] && echo "$script: output file should be .pdf" && exit 1 

infile=$1
outfile=$2
outdir=$(echo $2 | rev | cut -d"/" -f2- | rev)

[[ ! -f $infile ]] && echo "$script: input file does not exist, check file path" && exit 1
[[ -f $outfile ]]  && echo "$script: output file already exists" && exit 1

echo "$script: $(date): calling matlab function: jstrain('$infile','$outfile')..."
echo
matlab -nodesktop -nodisplay -nosplash -r "addpath('$funcpath'); jstrain('$infile','$outfile'); exit"
echo "done"

# crop pdf so plot fills page
pdfcrop $outfile "$outdir/crop-temp.pdf" > /dev/null
mv "$outdir/crop-temp.pdf" $outfile

echo
echo "$script: $(date): output pdf: $outfile"
exit 0
  
