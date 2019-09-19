#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=10,vmem=100gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N metabat_binning

cd PWDHERE

module load bowtie2/intel/2.3.2
module load samtools/1.9
module load metabat/2.11.3

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`


#SPAdes binning
bowtie2-build assembly/spades_output/contigs.fasta binning/spades_index
for f in $reads
do 
	bowtie2 -x  binning/spades_index -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq --fr -S binning/"$f"_spades.sam
	samtools view -bS binning/"$f"_spades.sam | samtools sort -o binning/"$f"_sort_spades.bam
done 

jgi_summarize_bam_contig_depths --outputDepth binning/spades_metabat_depth binning/*_sort_spades.bam
metabat2 -i assembly/spades_output/contigs.fasta -a binning/spades_metabat_depth -m 1500 -o binning/spades_metabat/bin

echo "Metabat binning for SPAdes done"

MegaHit binning
bowtie2-build assembly/megahit_output/final.contigs.fa  binning/megahit_index
for f in $reads
do
        bowtie2 -x  binning/megahit_index -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq --fr -S binning/"$f"_megahit.sam
        samtools view -bS binning/"$f"_megahit.sam | samtools sort -o binning/"$f"_sort_megahit.bam
done

jgi_summarize_bam_contig_depths --outputDepth binning/megahit_metabat_depth binning/*_sort_megahit.bam
metabat2 -i assembly/megahit_output/final.contigs.fa -a binning/megahit_metabat_depth -m 1500 -o binning/megahit_metabat/bin

echo "Metabat binning for MegaHit done"
