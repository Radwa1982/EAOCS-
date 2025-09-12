
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


