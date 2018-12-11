#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set paths for input and output directories
export JENNY_SNV_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4a_raw_SNP"
export JENNY_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4b_raw_indel"
export AUTHOR_DIR="/mnt/work1/users/bhklab/Users/jenny/author/VCF"
export SHARED_SNV_DIR="/mnt/work1/users/bhklab/Users/jenny/compare/RAW_SNV/shared"
export SHARED_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/compare/RAW_INDEL/shared"
export JENNY_SNV_ONLY_DIR="/mnt/work1/users/bhklab/Users/jenny/compare/RAW_SNV/jenny_only"
export JENNY_INDEL_ONLY_DIR="/mnt/work1/users/bhklab/Users/jenny/compare/RAW_INDEL/jenny_only"


##### SNV #####
# Find positive and negative intersections
JENNY_SNV=$(ls $JENNY_DIR | grep ".vcf.gz$" | cut -f1 -d".")

for i in $JENNY_SNV
do
  module load vcftools/0.1.12
  
  # Subset SNVs that were called from both Jenny's and authors' pipelines
  vcf-isec -n +2 $JENNY_SNV_DIR/$i.vcf.gz $AUTHOR_DIR/$i.vcf.gz_SNPS_filtered.vcf.vcf.gz | bgzip -c > $SHARED_SNV_DIR/$i.vcf.gz
  
  # Subset SNVs that were called from only Jenny's pipeline
  vcf-isec -c $JENNY_SNV_DIR/$i.vcf.gz $AUTHOR_DIR/$i.vcf.gz_SNPS_filtered.vcf.vcf.gz | bgzip -c > $JENNY_SNV_ONLY/$i.vcf.gz
  
  echo "Comparing SNVs for" $i "done"
done


# Print results to text file (make sure to grep -v to exclude VCF header lines)
VCF=$(ls | grep ".vcf.gz$" | cut -f1 -d".")
for i in $VCF
do
  zcat $i.vcf.gz | grep -cv "^#" >> compare_SNVs.txt
done


##### INDEL #####
# Find positive and negative intersections
JENNY_INDEL=$(ls $JENNY_INDEL_DIR | grep ".vcf.gz$" | cut -f1 -d".")

for i in $JENNY_INDEL
do
  module load vcftools/0.1.12
  
  # Subset indels that were called from both Jenny's and authors' pipelines
  vcf-isec -n +2 $JENNY_INDEL_DIR/$i.vcf.gz $AUTHOR_DIR/$i.vcf.gz_indels_filtered.vcf.vcf.gz | bgzip -c > $SHARED_INDEL_DIR/$i.vcf.gz
  
  # Subset indels that were called from only Jenny's pipeline
  vcf-isec -c $JENNY_INDEL_DIR/$i.vcf.gz $AUTHOR_DIR/$i.vcf.gz_indels_filtered.vcf.vcf.gz | bgzip -c > $JENNY_INDEL_ONLY/$i.vcf.gz
  
  echo "Comparing indels for" $i "done"
done


# Print results to text file (make sure to grep -v to exclude VCF header lines)
VCF=$(ls | grep ".vcf.gz$" | cut -f1 -d".")
for i in $VCF
do
  zcat $i.vcf.gz | grep -cv "^#" >> compare_indels.txt
done
