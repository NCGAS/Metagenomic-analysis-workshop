#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=2:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N kraken

cd PWDHERE

module unload python
module load python/3.6.8
module load focus/1.4
export LD_LIBRARY_PATH=/N/soft/rhel7/focus/jellyfish-2.2.6/lib:$LD_LIBRARY_PATH

focus -q reads -o reads/focus_output --threads 1
