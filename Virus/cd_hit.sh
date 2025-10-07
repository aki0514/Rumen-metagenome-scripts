#!/bin/bash
# Usage:
#   bash cd_hit.sh <InputFasta> <OutputPrefix>
#
# <InputFasta>   : merged viral FASTA file
# <OutputPrefix> : prefix for output directory

IN="$1"
PREFIX="$2"
ID=0.95   
COV=0.85  

OUTDIR="${PREFIX}_cdhit"
mkdir -p "${OUTDIR}"

cd-hit-est \
  -i "${IN}" \
  -o "${OUTDIR}/${PREFIX}_virus_nr.fa" \
  -c ${ID} \
  -aS ${COV}

