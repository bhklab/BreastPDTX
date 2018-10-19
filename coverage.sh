#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set paths for input and output directories
export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"
export COVERAGE_DIR="/mnt/work1/users/bhklab/Users/jenny/coverage"

# Set target intervals (autosomes and chromosome X)
INTERVALS="/mnt/work1/users/bhklab/Users/jenny/INTERVALS/autox.bed"


# Select raw BAM files based on which coverage files will be generated
# BAI index files, RRBS BAM files (for methylation), and shallow WGS BAM files (for copy number variation) are not processed
cd $RAW_DIR
SAMPLE=$(ls | grep ".bam" | egrep -v '.bai|RRBS|Shall' | cut -f1 -d".")

# Calculate depth for all reads for selected BAM files
for i in $SAMPLE
do
  module load bedtools/2.23.0
  coverageBed -abam $i.bam \
  -b $INTERVALS -hist > $COVERAGE_DIR/$i.hist
  
  echo "Analyzing coverage for" $i "done"
done

# Calculate average coverage from HIST files and print results to text file
FILES=$(ls $COVERAGE_DIR | grep -v "txt")
for i in $FILES
do 
  COVERAGE=$(grep "all" $i | awk -F"\t" '{NUM+=$2*$3; DEN+=$3} END {print NUM/DEN}')
  for j in $COVERAGE
  do
    echo -e $i'\t'$j >> $COVERAGE_DIR/coverage.txt
  done
done
