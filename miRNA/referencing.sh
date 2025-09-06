# refrencing 
 wget https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/ncrna/Homo_sapiens.GRCh38.ncrna.fa.gz   

#Indexing using bowtie
module avail
module load
 bowtie-build Homo_sapiens.GRCh38.ncrna.fa.gz hg38_ncrna_index 
# The mapping step 
mapper.pl config.txt -d -j -h -e -l 18 -m -p ref/hg38_genome_index -s reads_1.fa -t reads_vs_genome_1.arf  

# 5. Download miRBase reference sequences for known miRNAs
# For quantifying known miRNAs, you need the mature and hairpin sequences.
wget https://www.mirbase.org/download/mature.fa
wget https://www.mirbase.org/download/hairpin.fa

#Extract only the human (hsa) sequences from the downloaded files.
#(Assumes headers start with ">hsa-")
grep -A1 '^>hsa-' mature.fa > hsa.mature.fa
grep -A1 '^>hsa-' hairpin.fa > hsa.hairpin.fa

# for white spaces error we use this commmand
awk '{print $1}' hsa.mature.fa> one_column_hsa.mature.fa
awk '{print $1}' hsa.hairpin.fa> one_column_hsa.hairpin.fa

fastaparse.pl one_column_hsa.mature.fa -b > one_column_hsa.mature.clean.fa
fastaparse.pl one_column_hsa.hairpin.fa -b > one_column_hsa.hairpin.clean.fa

###then the quantifier to get the raw counts read 
 quantifier.pl -m ref/one_column_hsa.mature.clean.fa -p ref/one_column_hsa.hairpin.clean.fa -r reads_1.fa -t hsa -c config.txt  

