# Mining SRA to identify datasets with a sequence of interest # 

### Steps to run this workflow
#### Input sequence
This is the sequence of interest or a genome that you are interested in idenitfying other datasets in SRA that may have this genome.
For the workshop our input is crAssphage genome, NC_024711.1 Uncultured crAssphage, complete genome from NCBI 

Available on the VM in path /opt, to copy the file from there to you user space, run the command.
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
1. have a alignment length of more than 100bp 
    - This was done using the code available in another git repository https://github.com/linsalrob/sam.
2. have more than 10 hits at least \
Run the command, to run the above steps
`./filtering.sh` 

The result is a subset directory with only the bam files that passed these filtering paramters

Great! Now we have the filered bam files that potentially have the input sequence 
