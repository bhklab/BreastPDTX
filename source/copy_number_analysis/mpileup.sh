# !/bin/bash
#
# $ -cwd
# $ -S /bin/bash
#


# Set paths for input and output directories
export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"
export MPILEUP_DIR="/mnt/work1/users/bhklab/Users/jenny/CNA/1_mpileup"


# Set reference genome and target intervals
# Referece genome is a concatenation of hg19 and mm10 from UCSC
# Intervals consist of autosomes and chromosome X
REFERENCE="/mnt/work1/users/bhklab/Users/jenny/BREAST_CANCER_PDTX_REFERENCE_GENOME/BREAST_CANCER_PDTX.fa"


##### MODELS WITH ONLY 1 NORMAL SAMPLE #####
# Select non-normal samples (tumor, PDTX, and PDTC)
BAD_ID=$(ls $RAW_DIR | grep ".bam" | egrep -v '.bai|RRBS|Shall' | grep -- "-NR" | cut -f1 -d"-" | uniq)
ID=$(ls $RAW_DIR | grep ".bam" | egrep -v '.bai|RRBS|Shall' | grep -- "-N" | grep -v "$BAD_ID" | cut -f1 -d"-" | uniq)
TUMOR_SAMPLES=$(ls $RAW_DIR | grep ".bam" | egrep -v ".bai|RRBS|Shall" | grep "$ID" | grep -v -- "-N" | cut -f1 -d".")


# Prepare mpileup files
for i in $TUMOR_SAMPLES
do
  NORMAL=$(echo $i | cut -f1 -d"-")

  module load samtools/0.1.19
  samtools mpileup -q 1 -f $REFERENCE \
  $RAW_DIR/${NORMAL}-N.bam \
  $RAW_DIR/$i.bam | \
  awk -F"\t" '$4 > 0 && $7 > 0' > $MPILEUP_DIR/$i.mpileup
  
  echo "Mpileup for" $i "done"
done