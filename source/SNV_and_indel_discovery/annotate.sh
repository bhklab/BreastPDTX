# !/bin/bash
#
# $ -cwd
# $ -S /bin/bash
#

# Set path for Oncotator
export ONCOTATOR_DIR="/mnt/work1/software/oncotator/1.5.3.0"

# Set paths for input and output directories
export BIALLELIC_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/6a_biallelic_SNP"
export BIALLELIC_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/6b_biallelic_indel"
export ANNOTATED_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/7a_annotated_SNP"
export ANNOTATED_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/7b_annotated_indel"
export DISCARD_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/8a_discard_SNP"
export DISCARD_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/8b_discard_indel"
export FINAL_SNP_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/9a_final_SNP"
export FINAL_INDEL_DIR="/mnt/work1/users/bhklab/Users/jenny/somatic_mutations/9b_final_indel"


# Annotate
module load oncotator/1.5.3.0


##### SNV #####
SNP=$(ls $BIALLELIC_SNP_DIR | grep "vcf" | cut -f1 -d".")
for i in $SNP
do
  oncotator -i VCF --db-dir $ONCOTATOR_DIR/db \
  $BIALLELIC_SNP_DIR/$i.vcf \
  --output_format=SIMPLE_TSV \
  $ANNOTATED_SNP_DIR/$i.tsv hg19

  echo "Annotating" $i "done"

# Discard non-functional variants
  egrep 'synonymous|non-coding|intron|intergenic|non-protein' $ANNOTATED_SNP_DIR/$i.tsv > $DISCARD_SNP_DIR/$i.tsv

  echo "Discarding non-functional SNPs for" $i "done"

# Keep functional variants
  egrep -v 'synonymous|non-coding|intron|intergenic|non-protein' $ANNOTATED_SNP_DIR/$i.tsv > $FINAL_SNP_DIR/$i.tsv

  echo "Extracting functional SNPs for" $i "done"
done


##### INDEL #####
INDEL=$(ls $BIALLELIC_INDEL_DIR | grep "vcf" | cut -f1 -d".")
for i in $INDEL
do
  oncotator -i VCF --db-dir $ONCOTATOR_DIR/db \
  $BIALLELIC_INDEL_DIR/$i.vcf \
  --output_format=SIMPLE_TSV \
  $ANNOTATED_INDEL_DIR/$i.tsv hg19

  echo "Annotating" $INDEL_ID "indels done"

# Discard non-functional variants
  egrep 'intron|intergenic|non-protein' $ANNOTATED_INDEL_DIR/$i.tsv > $DISCARD_INDEL_DIR/$i.tsv

  echo "Discarding non-functional indels for" $i "done"

# Keep functional variants
  egrep -v 'intron|intergenic|non-protein' $ANNOTATED_INDEL_DIR/$i.tsv > $FINAL_INDEL_DIR/$i.tsv

  echo "Extracting functional indels for" $i "done"
done
