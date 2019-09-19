#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=10,vmem=100gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N megahit

cd PWDHERE

module load megahit/1.1.2
left=reads/left.fq
right=reads/right.fq

megahit -1 $left -2 $right --tmp-dir PWDHERE -o assembly/megahit_output


