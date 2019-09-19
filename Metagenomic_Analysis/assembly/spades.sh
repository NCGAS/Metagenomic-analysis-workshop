#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=10,vmem=100gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N spades

cd PWDHERE

module load spades/3.11.1

left=reads/left.fq
right=reads/right.fq

spades.py -1 $left  -2 $right --meta -t 8 -o assembly/spades_output


