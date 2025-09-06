# refrencing 
 wget https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/ncrna/Homo_sapiens.GRCh38.ncrna.fa.gz   

#Indexing using bowtie
module avail
module load
 bowtie-build Homo_sapiens.GRCh38.ncrna.fa.gz hg38_ncrna_index 
# The mapping step 
mapper.pl config.txt -d -j -h -e -l 18 -m -p ref/hg38_genome_index -s reads_1.fa -t reads_vs_genome_1.arf  
#
