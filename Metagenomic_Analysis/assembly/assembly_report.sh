#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N assembly_report

cd PWDHERE

module load quast/4.6.3
module load bowtie2

quast.py assembly/megahit_output/final.contigs.fa  -o assembly/megahit_quast
quast.py assembly/spades_output/contigs.fasta  -o assembly/spades_quast

echo "SPAdes"
bowtie2-build assembly/spades_output/contigs.fasta assembly/spades_quast/index
bowtie2 -x assembly/spades_quast/index -U reads/left.fq,reads/right.fq -S assembly/spades_quast/spades.sam > assembly/spades_bowtie2.log 2>&1 

echo "Megahit"
bowtie2-build assembly/megahit_output/final.contigs.fa assembly/megahit_quast/index
bowtie2 -x assembly/megahit_quast/index -U reads/left.fq,reads/right.fq -S assembly/megahit_quast/megahit.sam >assembly/megahit_bowtie2.log  2>&1

#If there was already a assembly_report.txt generated that will be deleted
rm -r assembly/assembly_report.txt 

#Summarizing all the results together to a table
sed -i 's/contigs/spades_contigs/g' assembly/spades_quast/report.tsv 
sed -i 's/ /_/g' assembly/spades_quast/report.tsv
sed -i 's/contigs/megahit_contigs/g' assembly/megahit_quast/report.tsv
sed -i 's/ /_/g' assembly/megahit_quast/report.tsv
join -j 1 <(sort -k 1 assembly/spades_quast/report.tsv) <(sort -k 1 assembly/megahit_quast/report.tsv) > assembly/assembly_report.txt
echo  "quast results processed" 

var_0_spades=`grep "aligned 0 times" assembly/spades_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_0_megahit=`grep "aligned 0 times" assembly/megahit_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_1_spades=`grep "aligned exactly 1 time" assembly/spades_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_1_megahit=`grep "aligned exactly 1 time" assembly/megahit_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_more_than_once_spades=`grep "aligned >1 times" assembly/spades_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_more_than_once_megahit=`grep "aligned >1 times" assembly/megahit_bowtie2.log | sed 's/ /\t/g'| cut -f 6`
var_overall_spades=`grep "overall alignment rate" assembly/spades_bowtie2.log | sed 's/ /\t/g'| cut -f 1`
var_overall_megahit=`grep "overall alignment rate" assembly/megahit_bowtie2.log | sed 's/ /\t/g'| cut -f 1`

echo "aligned_0_times  $var_0_spades $var_0_megahit" >> assembly/assembly_report.txt
echo "aligned_1_time  $var_1_spades $var_1_megahit" >> assembly/assembly_report.txt
echo "more_than_once $var_more_than_once_spades $var_more_than_once_megahit" >> assembly/assembly_report.txt
echo "overall_alignment  $var_overall_spades $var_overall_megahit" >> assembly/assembly_report.txt
