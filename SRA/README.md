# Mining SRA to identify datasets with a sequence of interest # 

### Steps to run this workflow
#### Input sequence
This is the sequence of interest or a genome that you are interested in idenitfying other datasets in SRA that may have this genome.
For the workshop our input is crAssphage genome, NC_024711.1 Uncultured crAssphage, complete genome from NCBI 

Available on the VM in path /opt, to copy the file from there to you user space, run the command. \
`cp /opt/crassphage.fasta /home/username`

#### Search SRA 
This part of the analysis is already done and is available on the virtual machine. The steps to do this part of the analysis is described below. 

To search SRA, we used the gateway [SearchSRA gateway](https://www.searchsra.org/)
- First register for an account, if you dont have an account already
- Create a project - enter project name, project description. 
- Create an experiment - experiment name description, project the experiment should belong to, application-"Search-SRA". Then click "Continue" 
- Choose reference file- Import the input sequence 
- For the option "Select existing Search IDs File OR Upload your own below" - you can select to serahc against only "[Human Microbiome Project](https://www.hmpdacc.org/ihmp/) datasets in SRA", "[TARA ocean project datasets](https://oceans.taraexpeditions.org/en/m/about-tara/les-expeditions/tara-oceans/), or "All-SRA-metagenomes"
- Click "Save and Launch" to start the job

Documentation on how to use the gateway is also available [here](https://www.searchsra.org/pages/documentation).

Once the searchSRA job is completed, download the output "results.txt". This file contains a link where the results are stored, and other information.     

#### Filtering the SearchSRA results 
Filter the bam files to include only those that, 
- have a alignment length of more than 100bp 
    - This was done using the code available in another git repository https://github.com/linsalrob/sam.
- have more than 10 hits at least \
Run the command, to run the above steps \
`./filtering.sh` 

The result is a subset directory with only the bam files that passed these filtering paramters. Additonaly there are two other files generated that has some really useful information as well 
**samtools-count** — list the number of reads that aligned against the reference genome from *.filtered.bam files (output from sam_len) 
**morethan10Hits.txt** – filters the samtools_count list to separate out only those datasets that have a value more then 50.  

#### Getting metadata or run information for the filtered subset
To do this step we will be using E-utilities – to lookup the metadata information of the subset datasets using SRA ID.
- generating metadata \
As a note make sure change single quotes " ' " to " ` ". 
`for f in 'cat moreThan10Hits.txt'; do epost -db sra -format acc -id $f | efetch -format runinfo>>metadata; done`
- formatting the metadata \
`sort metadata | uniq| sed '/^[[:space:]]*$/d' >metadata2`

#### Visualization 
This final step is to quickly visualize the filtered bam files against the input sequence to assess the coverage, regions of the input sequence.

For this step we picked [Anvi'o](http://merenlab.org/software/anvio/), an analysis and visualization platform for omics data. This platform will extend the data to not just confirming datasets do contain the genome, but also explore the results further. 

The commands used to quickly visualize the data in anvio, 
- Start with formatting the input file (sequence entered into SearchSRA as input) header line. This line has to be the same as header line in bam files as well. 
	-  Anvi’o doesn’t like spaces, and the input.fa file header has to be the same in the bam files
	-  use samtools to see what the header line is in the bam files in subset \
		`samtools view -h -o out.sam DRR002659.bam` \
		        @SQ     SN:NC_024711.1  LN:97065 
	- remove everything else in the crassphage.fa header line 
- Input files for Anvio
    - Reformatted input sequence from Step 1 
    - Bam files- *bam files in subset directory 
    
- Generate a contigs database 
	`anvi-gen-contigs-database -f crassphage.fasta -o contigs.db`
    
- Profiling bam files – in subset directory run the below commands.
    Sorting and indexing all the bam files using samtools to do this step  
    `for f in *.bam ; do anvi-init-bam $f -o $f.anvio.bam; done`

- Adding the bam file information to the contigs database to add sample specific information
	`for f in *anvio.bam ; do  anvi-profile -i $f -c ../contigs.db ; done`

- Merge all the profiles to one database 
    `anvi-merge */PROFILE.db -o SAMPLES-MERGED -c ../contigs.db`

- Visualize the data 
    `anvi-interactive -p SAMPLES-MERGED/PROFILE.db -c ../contigs.db`

Visualize the Anvi'o figure in the path http://IPADRRESS/app/index.html
