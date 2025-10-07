#!/bin/bash
# Usage:
#   bash prodigal.sh <InputFasta> <OutputPrefix>
#
# <InputFasta>   : viral contigs FASTA (e.g., clustered with cd-hit)
# <OutputPrefix> : prefix for output directory

IN="$1"
PREFIX="$2"

OUTDIR="${PREFIX}_prodigal"
mkdir -p "${OUTDIR}"

# Run Prodigal in metagenome mode (virus-friendly)
prodigal \
  -i "${IN}" \
  -o "${OUTDIR}/${PREFIX}_genes.gbk" \
  -a "${OUTDIR}/${PREFIX}_proteins.faa" \
  -d "${OUTDIR}/${PREFIX}_genes.fna" \
  -p meta

# Keep only non-partial ORFs (partial=00)
awk '/^>/{p=($0 ~ /partial=00/)} p' \
  "${OUTDIR}/${PREFIX}_proteins.faa" \
  > "${OUTDIR}/${PREFIX}_proteins_filtered.faa"
