#!/bin/bash
# Usage:
#   bash coverm_virus.sh <SampleName> <VirusFasta> <R1.fq.gz> <R2.fq.gz>
#
# <SampleName> : sample name (used as prefix for output files)
# <VirusFasta> : viral contigs FASTA file (e.g., vOTU.fa)
# <R1.fq.gz>   : paired-end read file (R1, filtered)
# <R2.fq.gz>   : paired-end read file (R2, filtered)

SAMPLE="$1"
VIRUS="$2"
R1="$3"
R2="$4"

OUTDIR="${SAMPLE}_coverm_virus"
mkdir -p "${OUTDIR}"

coverm contig \
  -1 "${R1}" \
  -2 "${R2}" \
  --reference "${VIRUS}" \
  -m count covered_fraction length \
  -p bwa-mem \
  --trim-min 0.10 \
  --trim-max 0.90 \
  --min-covered-fraction 0 \
  --min-read-percent-identity 95 \
  --min-read-aligned-percent 75 \
  > "${OUTDIR}/${SAMPLE}_coverm_raw.tsv"


