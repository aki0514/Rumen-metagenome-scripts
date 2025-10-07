#!/bin/bash
# Usage:
#   bash Crispr.sh <GenomeDir> <OutputPrefix>
#
# <GenomeDir>    : directory containing MAG fasta files (*.fa)
# <OutputPrefix> : prefix for output directory

GENOMES="$1"
PREFIX="$2"

OUTDIR="${PREFIX}_crispr"
mkdir -p "${OUTDIR}"

for filepath in ${GENOMES}/*.fa; do
  dir_name="$(basename ${filepath} .fa)"
  sed -i 's/\./_/g' ${filepath}

  singularity exec /home/aki0514/program/CrisprCasFinder.simg \
    perl /usr/local/CRISPRCasFinder/CRISPRCasFinder.pl \
    -so /usr/local/CRISPRCasFinder/sel392v2.so \
    -cf /usr/local/CRISPRCasFinder/CasFinder-2.0.3 \
    -drpt /usr/local/CRISPRCasFinder/supplementary_files/repeatDirection.tsv \
    -rpts /usr/local/CRISPRCasFinder/supplementary_files/Repeat_List.csv \
    -def G -out ${OUTDIR}/${dir_name} -in ${filepath}

  cat ${OUTDIR}/${dir_name}/result.json \
    | jq -r '.Sequences[].Crisprs[] 
             | select(.Evidence_Level == 4 or .Evidence_Level == 3) 
             | .Regions[] 
             | select(.Type == "Spacer") 
             | .Sequence' \
    | awk -v dir_name="${dir_name}" '{print ">" dir_name "_Sequence" NR "\n" $0}' \
    > ${OUTDIR}/${dir_name}/spacer.fasta
done

