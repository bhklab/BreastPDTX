#!/bin/bash
#
#$ -cwd 
#$ -S /bin/bash
#

# Set paths for GATK
export JAVA_DIR="/mnt/work1/software/java/8/jre1.8.0_162/bin"
export GATK_DIR="/mnt/work1/software/gatk/3.6"

# Set paths for input and output directories
export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"
export HAPLOTYPECALLER_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/test"
export HAPLOTYPECALLER_REP_DIR="/mnt/work1/users/bhklab/Users/jenny/repeated_normal/1_HaplotypeCaller"

# Set reference genome and target intervals
# Referece genome is a concatenation of hg19 and mm10 from UCSC
# Intervals consist of autosomes and chromosome X
REFERENCE="/mnt/work1/users/bhklab/Users/jenny/BREAST_CANCER_PDTX_REFERENCE_GENOME/BREAST_CANCER_PDTX.fa"
INTERVALS="/mnt/work1/users/bhklab/Users/jenny/INTERVALS/autox.bed"


##### MODELS WITH ONLY 1 NORMAL SAMPLE #####
# Select for models with exclusively "-N" in the sample name but not "-NR"
# Also filter out tumor-only models
BAD_ID=$(ls $RAW_DIR | grep ".bam" | egrep -v '.bai|RRBS|Shall' | grep -- "-NR" | cut -f1 -d"-" | uniq)
ID=$(ls $RAW_DIR | grep ".bam" | egrep -v '.bai|RRBS|Shall' | grep -- "-N" | grep -v "$BAD_ID" | cut -f1 -d"-" | uniq)
SAMPLES_WITH_NORMAL=$(ls $RAW_DIR | grep "$ID-" | egrep -v 'bai|RRBS|Shall' | cut -f1 -d".")

# Variant calling
for i in $SAMPLES_WITH_NORMAL
do
  module load gatk/3.6
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T HaplotypeCaller \
  -I $RAW_DIR/$i.bam \
  -R $REFERENCE \
  -L $INTERVALS \
  -o $HAPLOTYPECALLER_DIR/$i.vcf \
  -stand_call_conf 30.0 -stand_emit_conf 10.0

  echo "Variant calling" $i "done"
done

# Compress and index
for i in $SAMPLES_WITH_NORMAL
do
  module load tabix/0.2.6
  bgzip -c $HAPLOTYPECALLER_DIR/$i.vcf > $HAPLOTYPECALLER_DIR/$i.vcf.gz
  tabix -p vcf $HAPLOTYPECALLER_DIR/$i.vcf.gz

  echo "Indexing" $i "done"
done


##### MODELS WITH MULTIPLE NORMAL SAMPLES #####
# Select for models with both "-N" and "-NR" in the sample name
IDREP=$(ls $RAW_DIR | grep "bam" | egrep -v '.bai|RRBS|Shall' | grep -- "-NR" | cut -f1 -d"-" | sed 's/$/-/')
REPEATED_NORMAL=$(ls $RAW_DIR | grep "$IDREP" | egrep -v '.bai|RRBS|Shall' | cut -f1 -d".")

# Variant calling
for i in $REPEATED_NORMAL
do
  module load gatk/3.6
  $JAVA_DIR/java -Xmx4g -jar $GATK_DIR/GenomeAnalysisTK.jar \
  -T HaplotypeCaller \
  -I $RAW_DIR/$i.bam \
  -R $REFERENCE \
  -L $INTERVALS \
  -o $HAPLOTYPECALLER_REP_DIR/$i.vcf \
  -stand_call_conf 30.0 -stand_emit_conf 10.0

  echo "Variant calling" $i "done"
done

# Compress and index
for i in $REPEATED_NORMAL
do
  module load tabix/0.2.6
  bgzip -c $HAPLOTYPECALLER_REP_DIR/$i.vcf > $HAPLOTYPECALLER_REP_DIR/$i.vcf.gz
  tabix -p vcf $HAPLOTYPECALLER_REP_DIR/$i.vcf.gz

  echo "Indexing" $i "done"
done
