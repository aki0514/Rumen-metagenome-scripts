#!/bin/bash
# Usage:
#   bash genomad.sh <SampleName> <DBdir>
#
# <SampleName> : sample name (used as prefix for output files)
# <DBdir>      : directory containing the geNomad database

SAMPLE="$1"
DBDIR="$2"

CONTIGS="${SAMPLE}_virus_assembly/metaspades/renamed_${SAMPLE}_5k_contigs.fasta"
OUTDIR="${SAMPLE}_genomad"

mkdir -p "${OUTDIR}"

genomad end-to-end \
  --cleanup \
  --splits 8 \
  "${CONTIGS}" \
  "${OUTDIR}" \
  "${DBDIR}"