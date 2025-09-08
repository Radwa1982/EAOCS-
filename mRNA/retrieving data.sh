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
  
