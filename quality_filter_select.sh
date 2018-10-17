#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set paths for GATK
export JAVA_DIR="/mnt/work1/software/java/8/jre1.8.0_162/bin"
export GATK_DIR="/mnt/work1/software/gatk/3.6"

# Set paths for input and output directories
export SOMATIC_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/2_somatic"
export FILTERED_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/3_filtered"
export RAW_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4a_raw_SNP"
export RAW_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4b_raw_indel"

# Set reference genome
# Referece genome is a concatenation of hg19 and mm10 from UCSC
REFERENCE="/mnt/work1/users/home2/jennywa/BREAST_CANCER_PDTX_REFERENCE_GENOME/BREAST_CANCER_PDTX.fa"


# Filter out reads with GQ < 20, FS > 40, and DP < 5
SOMATIC=$(ls $SOMATIC_DIR | grep -v ".tbi" | cut -f1 -d".") 
for i in $SOMATIC
do
  module load gatk/3.6
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T VariantFiltration \
  -R $REFERENCE \
  -o $FILTERED_DIR/$i.vcf \
  --variant $SOMATIC_DIR/$i.vcf.gz \
  --filterExpression "GQ < 20" --filterName "GQ20" \
  --filterExpression "FS > 40" --filterName "FS40" \
  --filterExpression "DP < 5" --filterName "DP5"

  echo "Filtering" $i "done"
done

# Modify the content of header field "AD" to something recognizable by GATK SelectVariants
cd $FILTERED_DIR
for i in $SOMATIC
do
  sed -i 's/Number=R/Number=./g' $i.vcf

  echo "Replacing AD" $i "done"
done


##### SNV #####
# Select SNP reads that pass all quality control filters
for i in $SOMATIC
do
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T SelectVariants \
  -R $REFERENCE \
  --variant $FILTERED_DIR/$i.vcf \
  -o $RAW_SNP_DIR/$i.vcf.gz \
  -select "vc.isNotFiltered()" \
  -selectType SNP

  echo "SNP selection for" $i "done"
done


##### INDEL #####
# Select indel reads that pass all quality control filters
for i in $SOMATIC
do
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T SelectVariants \
  -R $REFERENCE \
  --variant $FILTERED_DIR/$i.vcf \
 -o $RAW_INDEL_DIR/$i.vcf.gz \
  -select "vc.isNotFiltered()" \
  -selectType indel

  echo "Indel selection for" $i "done"
done
