#!/bin/bash
# Usage:
#   bash PhaTYP.sh <ContigsFasta> <OutputPrefix>
#
# <ContigsFasta> : input viral contigs fasta (e.g., vOTU.fa after cd-hit)
# <OutputPrefix> : prefix for output directory

IN="$1"
PREFIX="$2"

OUTDIR="${PREFIX}_phatyp"
mkdir -p "${OUTDIR}"

# Path to required tools
PRODIGAL="/path/to/prodigal"
PHATYP_DIR="/path/to/PhaTYP"

# Run PhaTYP preprocessing
python "${PHATYP_DIR}/preprocessing.py" \
  --contigs "${IN}" \
  --prodigal "${PRODIGAL}" \
  --midfolder "${OUTDIR}"

# Run PhaTYP prediction
python "${PHATYP_DIR}/PhaTYP.py" \
  --out "${OUTDIR}/prediction.csv" \
  --midfolder "${OUTDIR}"
