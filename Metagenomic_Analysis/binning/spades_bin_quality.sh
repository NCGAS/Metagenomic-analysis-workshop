#!/bin/bash
#PBS -k oe
#PBS -m abe
#PBS -M YOUREMAILHERE
#PBS -N bin_quality
#PBS -l nodes=1:ppn=1,vmem=100gb,walltime=2:00:00

cd PWDHERE

module load checkm/1.0.18
module load hmmer/3.1
module load kraken/1.1.1
export KRAKEN_DB1=/N/dc2/projects/ncgas/genomes/kraken/minikraken_20171019_8GB
module load centrifuge/1.0.3
module load busco/3.0.2

mkdir binning/bin_quality

#get the list of bins generated 
spades_bins=`ls binning/spades_metabat`

#CheckM
checkm tree -x fa binning/spades_metabat binning/bin_quality/checkm_tree
checkm tree_qa binning/bin_quality/checkm_tree/ -f binning/bin_quality/checkm_tree_qa
checkm lineage_set binning/bin_quality/checkm_tree binning/bin_quality/checkm_marker
checkm analyze binning/bin_quality/checkm_marker -x fa binning/spades_metabat binning/bin_quality/checkm_analyze
checkm qa binning/bin_quality/checkm_marker  binning/bin_quality/checkm_analyze > binning/bin_quality/checkm_summary
echo "CheckM done"

#kraken_taxa
for f in $spades_bins
do 
	kraken --preload --db $KRAKEN_DB1 binning/spades_metabat/"$f" > binning/bin_quality/"$f".kraken.out
	kraken-report --db $KRAKEN_DB1 binning/bin_quality/"$f".kraken.out > binning/bin_quality/"$f".kraken.report
done 
echo "Kraken done" 

#centrifuge_taxa
for f in $spades_bins
do 
	centrifuge -f -x $CENTRIFUGE_INDEX binning/spades_metabat/"$f"  >binning/bin_quality/"$f".centrifuge.out
	mv centrifuge_report.tsv binning/bin_quality/"$f"_centrifuge_report.tsv
done 
echo "centrifuge done"

#Busco report
for f in $spades_bins
do 
	run_BUSCO.py -i binning/spades_metabat/"$f" -c 1 -o spades-"$f"-busco-out -m genome -l /N/dc2/projects/ncgas/genomes/busco-lineage/bacteria_odb9/ -f
	mv run_spades-"$f"-busco-out binning/bin_quality/.
done 
echo "BUSCO done"

#Final_report
cp binning/bin_quality/checkm_summary binning/bin_quality/bins_quality_report
echo -en "\n\n\n"  >> binning/bin_quality/bins_quality_report
echo "Kraken_output  %reads  num_of_reads_per_clade  number_of_reads_in_taxa  rank_code  NCBI_taxa_ID  scientific_name">> binning/bin_quality/bins_quality_report

for f in $spades_bins
do 
	kraken_line=`head -n 10  binning/bin_quality/"$f".kraken.report`
	echo "kraken_output $kraken_line" >> binning/bin_quality/bins_quality_report
done 

echo -en "\n\n\n" >> binning/bin_quality/bins_quality_report
echo "Centrifuge_output  number_of_reads  taxa" >> binning/bin_quality/bins_quality_report
for f in $spades_bins
do 
	var=`cut -f 5 binning/bin_quality/"$f"_centrifuge_report.tsv | sort |tail -n 2 | grep -v "numReads" `
	taxa=`grep -w "$var" binning/bin_quality/"$f"_centrifuge_report.tsv | cut -f 1 | less -S`
	echo "Centrifuge_output  $var $taxa" >> binning/bin_quality/bins_quality_report
done

echo -en "\n\n\n" >> binning/bin_quality/bins_quality_report
echo "BUSCO results " >> binning/bin_quality/bins_quality_report
for f in $spades_bins
do 
	cat binning/bin_quality/run_spades-"$f"-busco-out/short_summary_spades-"$f"-busco-out.txt >> binning/bin_quality/bins_quality_report 
done
