#!/bin/bash
echo
# BATCH JOB SCRIPT

#------------------------------------------------------------------------
# Script for making 6 panel figure. This figure shows the relationship
# between all indices and strain for OLV, QTZ, and PPS, using 
# 5000 grains - for both axial compression and simple shear
#------------------------------------------------------------------------


# setup relevant paths
#--------------------------------------------------------------------------

# get paths to shell scripts to run each index

j_index="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/run_J_index.sh"
m_cont="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/run_M_Cont.sh"
m_disc="/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/run_M_Disc.sh" 


# get paths to relevant data

OLV_AXC="/nfs/see-fs-01_teaching/ee12lmb/project/data/olivine_axial_compress_VPSC_big/TEX_PH1.OUT"
OLV_SPS="/nfs/see-fs-01_teaching/ee12lmb/project/data/olivine_simple_shear_VPSC_big/TEX_PH1.OUT"

QTZ_AXC="/nfs/see-fs-01_teaching/ee12lmb/project/data/quartz_axial_compress_VPSC_big/TEX_PH1.OUT"
QTZ_SPS="/nfs/see-fs-01_teaching/ee12lmb/project/data/quartz_simple_shear_VPSC_big/TEX_PH1.OUT"

#PPS_AXC=
#PPS_SPS=

# creat output directory name (will be in each separte method's output file)
outdir="all_6panel_plot.out"


# setup input variables
#--------------------------------------------------------------------------
n=5000             # number of grains
seed=1             # seed to set random numbers
bin="0.25"         # set bin size (md)
binning="interp"   # binning type (md)


# RUN FUNCTIONS
#===========================================================================

#====================================OLIVINE================================
crystal="olivine"

# -----------------------------------J_INDEX--------------------------------
# axial compression
#run="
echo "nohup $j_index $OLV_AXC $n $seed $crystal $outdir/OLV_AXC_j_n${n}_strAll_sd${seed}.out >& /dev/null"
#eval "${run}" &

# simple shear 
echo "nohup $j_index $OLV_SPS $n $seed $crystal $outdir/OLV_SPS_j_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_CONT--------------------------------
# axial compression
echo "nohup $m_cont $OLV_AXC $n $seed $crystal $outdir/OLV_AXC_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_cont $OLV_SPS $n $seed $crystal $outdir/OLV_SPS_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_DISC--------------------------------
# axial compression
echo "nohup $m_disc $OLV_AXC $n $seed $crystal $bin $binning $outdir/OLV_AXC_md_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_disc $OLV_SPS $n $seed $crystal $bin $binning $outdir/OLV_SPS_md_n${n}_strAll_sd${seed}.out >& /dev/null"

#: <<'COMMENT'
#====================================QUARTZ================================
crystal="quartz"

# -----------------------------------J_INDEX--------------------------------
# axial compression
#run="
echo "nohup $j_index $QTZ_AXC $n $seed $crystal $outdir/QTZ_AXC_j_n${n}_strAll_sd${seed}.out >& /dev/null"
#eval "${run}" &

# simple shear
echo "nohup $j_index $QTZ_SPS $n $seed $crystal $outdir/QTZ_SPS_j_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_CONT--------------------------------
# axial compression
echo "nohup $m_cont $QTZ_AXC $n $seed $crystal $outdir/QTZ_AXC_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_cont $QTZ_SPS $n $seed $crystal $outdir/QTZ_SPS_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_DISC--------------------------------
# axial compression
echo "nohup $m_disc $QTZ_AXC $n $seed $crystal $bin $binning $outdir/QTZ_AXC_md_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_disc $QTZ_SPS $n $seed $crystal $bin $binning $outdir/QTZ_SPS_md_n${n}_strAll_sd${seed}.out >& /dev/null"

#================================POST-PEROVSKITE============================
crystal="post-perovskite"

# -----------------------------------J_INDEX--------------------------------
# axial compression
#run="
echo "nohup $j_index $PPS_AXC $n $seed $crystal $outdir/PPS_AXC_j_n${n}_strAll_sd${seed}.out >& /dev/null"
#eval "${run}" &

# simple shear
echo "nohup $j_index $PPS_SPS $n $seed $crystal $outdir/PPS_SPS_j_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_CONT--------------------------------
# axial compression
echo "nohup $m_cont $PPS_AXC $n $seed $crystal $outdir/PPS_AXC_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_cont $PPS_SPS $n $seed $crystal $outdir/PPS_SPS_mc_n${n}_strAll_sd${seed}.out >& /dev/null"

# -----------------------------------M_DISC--------------------------------
# axial compression
echo "nohup $m_disc $PPS_AXC $n $seed $crystal $bin $binning $outdir/PPS_AXC_md_n${n}_strAll_sd${seed}.out >& /dev/null"

# simple shear
echo "nohup $m_disc $PPS_SPS $n $seed $crystal $bin $binning $outdir/PPS_SPS_md_n${n}_strAll_sd${seed}.out >& /dev/null"

#COMMENT


