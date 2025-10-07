#!/bin/bash
# Usage:
#   bash vcontact2.sh <ProteinFasta> <OutputPrefix>
#
# <ProteinFasta> : Prodigal output (filtered faa)
# <OutputPrefix> : prefix for output directory

FAA="$1"
PREFIX="$2"

OUTDIR="${PREFIX}_vcontact2"
mkdir -p "${OUTDIR}"

C1BIN="/path/to/cluster_one-1.0.jar"

DB="ProkaryoticViralRefSeq201-Merged"

# Convert proteins to genome-gene mapping
vcontact2_gene2genome \
  -p "${FAA}" \
  -o "${OUTDIR}/viral_genomes_g2g.csv" \
  -s 'Prodigal-FAA'

# Run vContact2 clustering
vcontact2 \
  --raw-proteins "${FAA}" \
  --proteins-fp  "${OUTDIR}/viral_genomes_g2g.csv" \
  --rel-mode Diamond \
  --db "${DB}" \
  --pcs-mode MCL \
  --vcs-mode ClusterONE \
  --c1-bin "${C1BIN}" \
  --output-dir "${OUTDIR}"