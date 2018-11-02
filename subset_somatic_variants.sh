# !/bin/bash
# 
# $ -cwd
# $ -S /bin/bash
#

# Set paths for input and output directories
export HAPLOTYPECALLER_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/1_HaplotypeCaller"
export HAPLOTYPECALLER_REP_DIR="/mnt/work1/users/bhklab/Users/jenny/repeated_normal/1_HaplotypeCaller"
export SOMATIC_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/2_somatic"


##### MODELS WITH ONLY 1 NORMAL SAMPLE #####
# Select non-normal samples (tumor, PDTX, and PDTC)
ID=$(ls $HAPLOTYPECALLER_DIR | grep ".vcf.gz" | grep -v ".tbi" | cut -f1 -d"-" | uniq)
SAMPLES_FOR_SOMATIC=$(ls $HAPLOTYPECALLER_DIR | grep ".vcf.gz" | grep -v ".tbi" | grep "$ID" | grep -v -- "-N" | cut -f1 -d".")

# Extract somatic variants
for i in $SAMPLES_FOR_SOMATIC
do
  NORMAL=$(echo $i | cut -f1 -d"-")
  module load vcftools/0.1.12
  vcf-isec -c $HAPLOTYPECALLER_DIR/$i.vcf.gz $HAPLOTYPECALLER_DIR/${NORMAL}-N.vcf.gz | bgzip -c > $SOMATIC_DIR/$i.vcf.gz
  
  echo "Somatic" $i "done"
done


##### MODELS WITH MULTIPLE NORMAL SAMPLES #####
# Select non-normal samples (tumor, PDTX, and PDTC)
IDREP=$(ls $HAPLOTYPECALLER_REP_DIR | grep ".vcf.gz" | grep -v ".tbi" | cut -f1 -d"-" | uniq)
SAMPLES_FOR_SOMATIC_REP=$(ls $HAPLOTYPECALLER_REP_DIR | grep ".vcf.gz" | grep -v ".tbi" | grep "$IDREP" | grep -v -- "-N" | cut -f1 -d".")

# Extract somatic variants
for i in $SAMPLES_FOR_SOMATIC_REP
do
  NORMAL_REP=$(echo $i | cut -f1 -d"-")
  module load vcftools/0.1.12
  vcf-isec -c $HAPLOTYPECALLER_REP_DIR/$i.vcf.gz $HAPLOTYPECALLER_REP_DIR/${NORMAL_REP}-NR.vcf.gz | bgzip -c > $SOMATIC_DIR/$i.vcf.gz
  
  echo "Somatic" $i "done"
done


##### From now on, somatic mutations are treated the same way regardless of copies of normal samples #####
# Index
for i in $SOMATIC_DIR/*.vcf.gz
do
  module load tabix/0.2.6
  tabix -p vcf $i
  
  echo "Indexing" $i "done"
done
