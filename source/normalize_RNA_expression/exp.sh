#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#

export RAW_DIR="/Users/jennywang/Desktop/expression_files"
export TARGET_DIR="/Users/jennywang/Desktop/bruna_expression"

cd $RAW_DIR

CHIPS=$(ls | grep ".txt" | cut -f2 -d"_" | uniq)

for i in $CHIPS
do
  cp *$i* ${TARGET_DIR}/$i
done