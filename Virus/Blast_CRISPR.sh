#!/bin/bash
# Usage:
#   bash Blast_CRISPR.sh <vOTU.fa> <spacers.fa> <OutputPrefix>

VOTU="$1"
SPACERS="$2"
PREFIX="$3"

OUTDIR="${PREFIX}_blast_crispr"
mkdir -p "${OUTDIR}"

DB="${OUTDIR}/${PREFIX}_vOTU"

makeblastdb -in "${VOTU}" -dbtype nucl -parse_seqids -out "${DB}"

blastn -task blastn-short \
  -evalue 1e-3 \
  -perc_identity 95 \
  -qcov_hsp_perc 95 \
  -query "${SPACERS}" \
  -db "${DB}" \
  -outfmt "6 qseqid sseqid pident length qlen mismatch gapopen qcovs" \
  > "${OUTDIR}/${PREFIX}_blast.txt"

awk '{ if (($6 + $7) <= 1) print }' \
  "${OUTDIR}/${PREFIX}_blast.txt" \
  > "${OUTDIR}/${PREFIX}_blast.filtered.txt"
