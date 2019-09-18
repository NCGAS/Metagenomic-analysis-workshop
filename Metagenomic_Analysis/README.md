# Metagenomic analysis README

## Description: 
The scripts available here follow along the following steps,
- coassembly or cross assembly of all the reads using 1)SPAdes 2)MEGAHIT
- assembly statistics using 1 )QUAST 2) Bowtie2
- Binning similar contigs toegther to reconstruct genomes, 1) MetaBat
- Bin qulaity statistics using 1) CheckM, Kraken, Centrifuge, BUSCO
- Taxa annotation after each steps using 1)Kraken, 2)Centrifuge, 3)FOCUS
- Functional annotation for the bins using 1)SUPEFOCUS

These scripts will help you get started with the basic steps employed in metagenomic analysis, starting with taxa/functional annotation
of the intial reads and assembled contigs. If you are insterested in further reconstructing the genomes from the metagenomes, you can
continue running the binning steps to tie the different function back to taxa.

This is by no means the end of the ananlysis steps, these are the general steps, the next further steps will vary base don your research
questions.

## Steps to run the scripts

**SETTING UP SCRIPTS FIRST**
1. Run the following commands, that will find the job scripts saved with an extension .sh and replaces the emailaddress and adds the path

        make sure to CHNAGE MY EMAIL ADDRESS TO YOURS HERE,
        for f in */*.sh; do sed -i 's/YOUREMAILHERE/email@iu.edu/g' $f; done

        for f in */*.sh; do p=`pwd`; sed -i "s|PWDHERE|$p|g" $f ; done

**LETS START WITH THE READS**

2. Add you reads as files to the reads directory.
In the reads directory, run the command

        cat *1.fastq >left.fq
        cat *2.fastq >right.fq

This command joins all the left reads(ending with 1.fastq) toegther to left.fq and all the right reads (ending with 2.fastq).

3. Before we start with the analysis, lets first see who is there in the data.
Before you start, take a look at the job script and make sure the email and path is set correctly before you submit the job. To take a look at the jobs script you can use the command
        
        less kraken.sh

To run the job, run the command
        
        qsub kraken.sh

OUTPUT - Files ending with the "kraken_readname.out" and "kraken_readname.report"

**ASSEMBLY AND ASSEMBLY REPORTS**

4. Go to to assembly directory to start assembling the reads
Before you start, take a look at the job script and make sure the email and path is set correctly before you submit the job. To take a look at the jobs script you can use the command

        less spades.sh
        less megahit.sh

To run the job script, the command is
        
        qusb spades.sh
        qsub megahit.sh

Wait for these jobs to complete. Take a look at the job logs before you continue.
OUTPUT - spades_output and megahit_output directories

5. Once the assembly jobs are completed, then run the next script
        
        qsub assembly_report.sh

OUTPUT - This complete your assemblers and the assembly stats report that will be saved to "assembly_report.txt"
Here you have an option, you can pick the best assembler for this dataset or if you cant decide run both assemblies through the next step.The latter is what I did for the next set of scripts.

6. Contigs taxa identification and diversity estimation
In the presentations for now

**BINNING AND BIN QUALITY REPORTS**

7. Lets start grouping similar sequences together now,
The script binning.sh runs metabat on both the spades and megahit assembly, check to see the script looks right before you
submit the job
        
        qsub binning.sh

OUTPUT - spades_metabat and megahit_metabat directories that have grouped bins in them

8. Check bin quality of the bins
Next once the bins are generated, run the next script to calculate the completeness/taxa for each bins. Run the script spades_bin_quality.sh
        
        qsub spades_bin_quality.sh

If you are interested in running the scripts for metabat as well, here are the steps

-Copy the job script file with a new name
        
        cp spades_bin_quality.sh metabat_bin_quality.sh

-In the script, you will want to replace the directory names from spades_ *to megahit_*. You can do this manually, or run the following commands
        
        sed -i 's/spades/megahit/g' megahit_bin_quality.sh

WARNING:The sed command only works if your files have the same convention as spades bin directory. For example, in this case, the bins from spades
assembly is saved to spades_metabat, and bins from megahit is saved to megahit_metabat.

## Contact 
Email bhnala@iu.edu or help@ncgas.org 
