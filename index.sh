#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set path for input directory
export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"


# Select BAM files
cd $RAW_DIR

BAM=$(ls | grep ".bam" | egrep -v 'RRBS|Shall')

# Index
for i in $BAM
do
  module load samtools/0.1.18
  samtools index $i

  echo "Indexing" $i "done"
done
