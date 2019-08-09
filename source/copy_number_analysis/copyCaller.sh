#
#$ -cwd
#$ -S /bin/bash
#

# Set paths for GATK
export JAVA_DIR="/mnt/work1/software/java/8/jre1.8.0_162/bin"
export VARSCAN_DIR="/mnt/work1/software/varscan/2.4.2"

# Set paths for input and output directories
export MPILEUP_DIR="/mnt/work1/users/bhklab/Users/jenny/CNA/1_mpileup"
export COPYNUMBER_DIR="/mnt/work1/users/bhklab/Users/jenny/CNA/2_copynumber"
export COPYCALLER_DIR="/mnt/work1/users/bhklab/Users/jenny/CNA/3_copycaller"

SAMPLES=$(ls $MPILEUP_DIR | cut -f1 -d".")

for i in $SAMPLES
do
  $JAVA_DIR/java -jar $VARSCAN_DIR/VarScan.jar copynumber $MPILEUP_DIR/$i.mpileup $COPYNUMBER_DIR/$i --mpileup 1

  $JAVA_DIR/java -jar $VARSCAN_DIR/VarScan.jar copyCaller $COPYNUMBER_DIR/$i.copynumber --output-file $COPYCALLER_DIR/$i.copynumber.called

  echo "Copy number calling for" $i "done"
done