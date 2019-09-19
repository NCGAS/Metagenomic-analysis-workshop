#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=100gb,walltime=2:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N kraken

cd PWDHERE

module load kraken/1.1.1
export KRAKEN_DB1=/N/dc2/projects/ncgas/genomes/kraken/minikraken_20171019_8GB

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	kraken --preload --db $KRAKEN_DB1 reads/"$f"_1.fastq reads/"$f"_2.fastq --paired > reads/kraken_"$f".out
	kraken-report --db $KRAKEN_DB1 reads/kraken_"$f".out >reads/kraken_"$f"_report
done
