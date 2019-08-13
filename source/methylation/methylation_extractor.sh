# !/bin/bash
#
# $ -cwd
# $ -S /bin/bash
#


# Set paths for input and output directories
export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"
export EXTRACTOR_DIR="/mnt/work1/users/bhklab/Users/jenny/methylation/extractor"

SAMPLES=$(ls $RAW_DIR | grep "RRBS")

for i in $SAMPLES
do
        module load bismark/0.16.3
        module load samtools/0.1.19

        cd $EXTRACTOR_DIR

        bismark_methylation_extractor --multi 4 \
        --bedGraph --counts --gzip -s \
        --no_overlap --report \
        $RAW_DIR/$i

        echo "Methylation extraction for" $i "done"
done