#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set path for VCF_Parser
export VCF_PARSER_DIR="/mnt/work1/users/home2/jennywa/.local/bin"

# Set paths for input and output directories
export RAW_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4a_raw_SNP"
export RAW_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4b_raw_indel"
export MERGED_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/5a_merged_SNP"
export MERGED_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/5b_merged_indel"
export BIALLELIC_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/6a_biallelic_SNP"
export BIALLELIC_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/6b_biallelic_indel"


##### SNV #####
# Merge across model
cd $RAW_SNP_DIR
PATIENT_SNP=$(ls | grep ".vcf.gz" | grep -v ".tbi" | cut -f1 -d"-" | uniq)
for i in $PATIENT_SNP
do
  MERGE_SNP=$(ls | grep ".vcf.gz" | grep -v ".tbi" | grep "$i")
  SNP_ID=$(ls | grep ".vcf.gz" | grep -v ".tbi" | grep "$i" | cut -f1 -d"-" | uniq)
  module load vcftools/0.1.12
  vcf-merge $MERGE_SNP | bgzip -c > $MERGED_SNP_DIR/${SNP_ID}_SNP.vcf.gz

# Modify the content of header field "AD" to something recognizable by VCF_Parser
  zcat $MERGED_SNP_DIR/${SNP_ID}_SNP.vcf.gz | sed 's/Number=R/Number=./g' > $MERGED_SNP_DIR/${SNP_ID}_SNP.vcf

  echo "Merging" $SNP_ID "SNPs done"

# Split multi-allelic variants to resemble biallelic variants
  $VCF_PARSER_DIR/vcf_parser $MERGED_SNP_DIR/${SNP_ID}_SNP.vcf --split > $BIALLELIC_SNP_DIR/${SNP_ID}_SNP.vcf

  echo "Splitting" $SNP_ID "SNPs done"
done


##### INDEL #####
# Merge across model
cd $RAW_INDEL_DIR
PATIENT_INDEL=$(ls | grep "vcf.gz" | grep -v "tbi" | cut -f1 -d"-" | uniq)
for i in $PATIENT_INDEL
do
  MERGE_INDEL=$(ls | grep "vcf.gz" | grep -v "tbi" | grep "$i")
  INDEL_ID=$(ls | grep "vcf.gz" | grep -v "tbi" | grep "$i" | cut -f1 -d"-" | uniq)
  module load vcftools/0.1.12
  vcf-merge $MERGE_INDEL | bgzip -c > $MERGED_INDEL_DIR/${INDEL_ID}_indel.vcf.gz

# Modify the content of header field "AD" to something recognizable by VCF_Parser
  zcat $MERGED_INDEL_DIR/${INDEL_ID}_indel.vcf.gz | sed 's/Number=R/Number=./g' > $MERGED_INDEL_DIR/${INDEL_ID}_indel.vcf

  echo "Merging" $INDEL_ID "indels done"

# Split multi-allelic variants to resemble biallelic variants
  $VCF_PARSER_DIR/vcf_parser $MERGED_INDEL_DIR/${INDEL_ID}_indel.vcf --split > $BIALLELIC_INDEL_DIR/${INDEL_ID}_indel.vcf

  echo "Splitting" $INDEL_ID "indels done"
done
