#!/bin/bash
echo
# BATCH JOB SCRIPT 
# Running index repeat to create a J index convergence curve

#------------------------ RUN 2 ---------------------------
# Now running for 4 time steps to allow for better plotting
#-----------------------------------------------------------

# set full script path for ease
IR=/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/run_IR.sh

# set fixed params
seed=1
repeat=50
index="j"
infile="/nfs/see-fs-01_teaching/ee12lmb/project/data/olivine_axial_compress_VPSC_big/TEX_PH1.OUT"

#-------------------------------------------------------
# RUN ANALYSIS

# running each analysis at three strain steps
for step in 1 8 15 21
do

  # run for different numbers of grains
  for n in 5 10 50 100 200 500 1000 2000 5000 10000
  do

     printf "Running step = $step | n = $n | repeat =  $repeat | seed = $seed ..."
     run="$IR $infile $step $n $repeat $seed $index Jconv_OLV_AXC_n10000_run2.out/OLV_AXC_${index}_n${n}_r${repeat}_st${step}_sd${seed}.out > /dev/null"
     eval "${run}" &>/dev/null &disown
     printf "Done\n"

  done
done

  
