(base) [2375894@login1 mirna]$ cat map_count.sh 
#!/bin/bash 
# ==== CONFIGURATION ====   
FASTQ_DIR="/home/2375894/radwa-scratch/raw_data/mirna/" 
COLLAPSED_DIR="collapsed"  
MAPPED_DIR="mapped" 
GENOME_INDEX="ref/hg38_genome_index"  
# ========================  
# Create output directories 
mkdir -p "$COLLAPSED_DIR" "$MAPPED_DIR"
# Loop through all *_clean.fastq files
for fq in *_clean.fastq; do   
# Skip if no matching files  
    [ -e "$fq" ] || continue   
# Extract sample name (remove path and "_clean.fastq")  
    sample=$(basename "$fq" _clean.fastq)   
    echo "▶️ Processing $sample"  
# Run mapper.pl   
    mapper.pl "$fq"    
    -e -h -j -m -l 18 \
    -s "${COLLAPSED_DIR}/${sample}.fa" \ 
    -t "${MAPPED_DIR}/${sample}.arf" \ 
    -p "$GENOME_INDEX"
    echo "✅ Done: $sample"  
done                              


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


