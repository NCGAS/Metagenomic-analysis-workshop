#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=2:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N kraken

cd PWDHERE

module load centrifuge/1.0.3

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	centrifuge -x $CENTRIFUGE_INDEX -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq > reads/"$f".centrifuge.out
done
