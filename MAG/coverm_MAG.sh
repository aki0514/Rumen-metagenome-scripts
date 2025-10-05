#!/bin/bash
# Usage:
#   bash coverm_MAG.sh <SampleName> <GenomesDir> <R1.fq.gz> <R2.fq.gz>
#
# <SampleName> : sample name (used as prefix for output files)
# <GenomesDir> : directory containing MAGs (*.fa)
# <R1.fq.gz>   : filtered paired-end read file (R1)
# <R2.fq.gz>   : filtered paired-end read file (R2)

SAMPLE="$1"
GENOMES="$2"
R1="$3"
R2="$4"

OUTDIR="${SAMPLE}_coverm"
mkdir -p "${OUTDIR}"

coverm genome \
  -1 "${R1}" \
  -2 "${R2}" \
  --genome-fasta-directory "${GENOMES}" \
  -x fa \
  -m count covered_fraction length \
  -p bwa-mem \
  --trim-min 0.10 \
  --trim-max 0.90 \
  --min-covered-fraction 0 \
  --min-read-percent-identity 95 \
  --min-read-aligned-percent 75 \
  > "${OUTDIR}/${SAMPLE}_coverm_raw.tsv"
