module avail
module load 
#sratoolkit
#fastqc
#fastp
 
 prefetch SRR24348451 #Sample name ( all samples ) 
 fasterq-dump SRR24348450 ( all samples)
  # Output .fastq.gz , here each two runs were fromthe same sample so merged together and labeled the sample name 
  cat  SRR24348457.fastq.gz  SRR24348458.fastq.gz > CW44.fastq.gz # These sample metadata were obtained from the study it self / single end reads but two runs 
  # Quality checks of the raw reads 
  mkdir qc_reports
  fastqc -o qc_reports *.fastq.gz -t 16
  #downloading to the computer in windows power shel
  scp 2375894@login1.ada.brunel.ac.uk: ( pwd to get the file path ) (folder path on the computer - note no " and the \ is changed to this/)

  #### Here the cluster did not have fastp folder so enviromnet within my scratch had to be created 
  [2375894@login1 raw_data]$ conda create --prefix ~/my_env fastp 
  conda env list  
   conda activate  /home/2375894/my_env # the path taken from conda env list)
   fastp -i CW44.fastq.gz -o CW44.fastq.gz -t 16 -l 17 -g -p    

   # The mapping step 
   # The genome selection ( either use basic annotation or annotation one of them will not work) 
   wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz
   wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.basic.annotation.gtf.gz ( most likley this one)
   # indexing to the genome ( IISTA - INDEX )- this is the fa file https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.primary_assembly.genome.fa.gz
    hisat2-build GRCh38.primary_assembly.genome.fa hisat_index 
    # out put 8 or 9 files all with pre fix hista index 

    ## the mapping or alingment step - we created bas script for HIST-2 using vim ) then run it usin f bash ( name of the script)
   
    #!/bin/bash
# Define directories and parameters
GENOME_DIR="/home/2375894/radwa-scratch/raw_data/ref_tran/hisat_index"       # Path to the directory containing genome reference files
GTF_FILE="/home/2375894/radwa-scratch/raw_data/ref_tran/genecode.v38.basic.annotation.gtf"  # Path to GTF annotation file
FASTQ_DIR="/home/2375894/radwa-scratch/raw_data/mrna/merged_samples"  # Path to the directory containing FASTQ files
OUTPUT_DIR="/home/2375894/radwa-scratch/raw_data/mapped_reads_HISAT2"  # Directory for storing output files
THREADS=16                                      # Number of threads for HISAT2 (adjust as needed)
FINAL_OUTPUT="${OUTPUT_DIR}/final_counts.txt"      # Final output file to store all counts

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

# Create or clear the final output file
echo -e "GeneID\t$(ls ${FASTQ_DIR}/*.fastq.gz | sed 's/.fastq.gz//g' | xargs -n 1 basename | tr '\n' '\t')" > ${FINAL_OUTPUT}

# Change to the directory containing fastq files
cd ${FASTQ_DIR}

# Loop through all single-end fastq.gz files
for sample in *.fastq.gz; do
    base=$(basename ${sample} .fastq.gz)           # Get the base name of the sample
    R1="${FASTQ_DIR}/${base}.fastq.gz"             # Define the read file
    PREPROCESSED_R1="${OUTPUT_DIR}/preprocessed_${base}.fastq.gz" # Output file for fastp processed reads

    # Step 1: Run fastp for quality control and trimming
    echo "Running fastp for ${base}..."
    fastp -i ${R1} -o ${PREPROCESSED_R1} -l 17 -g -p -w ${THREADS}

    # Step 2: Align reads using HISAT2
    echo "Aligning ${base} using HISAT2..."
    hisat2 -x ${GENOME_DIR}/genome_index -U ${PREPROCESSED_R1} -S ${OUTPUT_DIR}/mapped_${base}.sam -p ${THREADS}

    # Step 3: Convert SAM to BAM using samtools
    echo "Converting SAM to BAM for ${base}..."
    samtools view -bS ${OUTPUT_DIR}/mapped_${base}.sam > ${OUTPUT_DIR}/mapped_${base}.bam

    # Step 4: Sort the BAM file
    echo "Sorting BAM file for ${base}..."
    samtools sort ${OUTPUT_DIR}/mapped_${base}.bam -o ${OUTPUT_DIR}/mapped_${base}_sorted.bam

done
# Step 5: Run featureCounts with specified parameters
echo "Running featureCounts for ${base}..."
featureCounts -a ${GTF_FILE} -O -M --primary --largestOverlap -s 2 -o ${OUTPUT_DIR}/counts_${base}.txt *_sorted.bam

echo "Pipeline completed successfully!"


## Output of this step is aligmnet file SAM and BAM - sequence alignemnt map - convert sam to bam ( non human readable)
## Out put was count matrix final _count.txt 
## downloaded the file and took it to R 
# you can use this to retrive the percentage of mapped reads 
samtoo flagstat (sample name).BAM

    
   

   
   
   
