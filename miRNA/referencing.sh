# refrencing 
 wget https://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/ncrna/Homo_sapiens.GRCh38.ncrna.fa.gz   

#Indexing using bowtie
module avail
module load
 bowtie-build Homo_sapiens.GRCh38.ncrna.fa.gz hg38_ncrna_index 
