#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=2:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N kraken

cd PWDHERE

module load kraken/2.0.8

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	kraken2 --db $KRAKEN_DB --paired reads/"$f"_1.fastq reads/"$f"_2.fastq --threads 1 --use-names --report reads/"$f"_kraken_report --output reads/"$f"_kraken.out
done
