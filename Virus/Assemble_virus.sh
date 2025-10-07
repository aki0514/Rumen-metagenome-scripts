#!/bin/bash
# Usage:
#   bash Assemble_virus.sh <SampleName>

SAMPLE="$1"

INDIR="${SAMPLE}_host_unmapped"
R1="${INDIR}/${SAMPLE}_paired_unmapped_R1.fq.gz"
R2="${INDIR}/${SAMPLE}_paired_unmapped_R2.fq.gz"
U="${INDIR}/${SAMPLE}_unpaired_unmapped.fq.gz"

OUTDIR="${SAMPLE}_virus_assembly"
mkdir -p "${OUTDIR}"

spades.py \
  -1 "${R1}" \
  -2 "${R2}" \
  -s "${U}" \
  -o "${OUTDIR}/metaspades" \
  --meta -k auto

# keep contigs >= 5000 bp
seqkit seq -m 5000 \
  "${OUTDIR}/metaspades/contigs.fasta" \
  > "${OUTDIR}/metaspades/${SAMPLE}_5k_contigs.fasta"

# rename contigs with sample prefix
awk -v sample="${SAMPLE}" '/^>/{sub(/^>NODE/, ">"sample, $0); print; next}{print}' \
  "${OUTDIR}/metaspades/${SAMPLE}_5k_contigs.fasta" \
  > "${OUTDIR}/metaspades/renamed_${SAMPLE}_5k_contigs.fasta"
