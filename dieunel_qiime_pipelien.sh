
###""""" Dieunel Derilus """##
# general pipeline to analyze  microbiome in qiim1

# activate qiime1 environment
Source activate qiime191

# Check the list of file in my current directory
(qiime191) [dderilus@boqueron data]$ ls
R001_barcode.fastq  R001_read1.fastq  mapping_file.txt

#filtering and demutiplexing
split_libraries_fastq.py -i R001_read1.fastq -b R001_barcode.fastq--rev_comp_mapping_barcodes -o split_out/ -m mapping_file.txt 


# the output files from  generated from the previous files

(qiime191) [dderilus@boqueron data_humberto]$ ls split_out
histograms.txt  seqs.fna  split_library_log.txt

#OTUs picking and taxonomy assignment, this should generate an otu-table.biom what will be used fr all the downstream analysis

pick_closed_reference_otus.py 
	-i split_out/seqs.fna -o otus_closed 
	-r /work/smassey/dderilus/data_humberto/fixed/my_goood_split/otro/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna 
	-t /work/smassey/dderilus/data_humberto/fixed/my_goood_split/otro/SILVA_132_QIIME_release/taxonomy/16S_only/97/taxonomy_7_levels.txt 
	-p parameter.txt
	-o closed_otus

# compute alpha diversity. This could be changed based on the number of OTUS and reads I get by sample
alpha_diversity.py
	 -i differential_abundance.py -i otu_table.biom -o diff_otus.txt -m map.txt -a DESeq2_nbinom -c Treatment -x Control -y Fast -d
	 -o alpha_rare_out
	 
# compute and Plot beta_diversity

beta_diversity_through_plots.py 
	-i otus/otu_table.biom 
	-m mapping_file.txt
	-o bdiv 
	-p parameter.txt


# identified discriminant taxa  from the samples categories

differential_abundance.py 
	-i otu_table.biom
	-o diff_otus.txt 
	-m mapping_file.txt
	-c Treatment 
	-x EBF 
	-y non-EBF
	
# other statistical analysis  and data visualization  could be conducted in R