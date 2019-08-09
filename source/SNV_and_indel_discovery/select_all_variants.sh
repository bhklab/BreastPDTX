#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

# Set paths for GATK
export JAVA_DIR="/mnt/work1/software/java/8/jre1.8.0_162/bin"
export GATK_DIR="/mnt/work1/software/gatk/3.6"

# Set paths for input and output directories
export FILTERED_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/3_filtered"
export ALL_VARIANTS_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/4c_all_variants"

# Set reference genome
# Referece genome is a concatenation of hg19 and mm10 from UCSC
REFERENCE="/mnt/work1/users/bhklab/Users/jenny/BREAST_CANCER_PDTX_REFERENCE_GENOME/BREAST_CANCER_PDTX.fa"


# Select variant reads that pass all quality control filters
for i in $SOMATIC
do
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T SelectVariants \
  -R $REFERENCE \
  --variant $FILTERED_DIR/$i.vcf \
  -o $ALL_VARIANTS_DIR/$i.vcf.gz \
  -select "vc.isNotFiltered()" \

  echo "Variant selection for" $i "done"
done
