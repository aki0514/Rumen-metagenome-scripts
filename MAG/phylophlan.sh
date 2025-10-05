#!/bin/bash
# Usage:
#   bash phylophlan.sh <GenomeDir> <OutputPrefix> <ConfigFile>
#
# <GenomeDir>   : directory containing genomes (e.g., dRep dereplicated_genomes)
# <OutputPrefix>: prefix for output directory
# <ConfigFile>  : PhyloPhlAn config file (e.g., supermatrix_aa.cfg)

GENOMES="$1"
PREFIX="$2"
CONFIG="$3"

OUTDIR="${PREFIX}_phylophlan"
mkdir -p "${OUTDIR}"

phylophlan \
  -i "${GENOMES}" \
  -f "${CONFIG}" \
  -d phylophlan \
  --diversity high \
  --nproc 8 \
  --genome_extension .fa \
  -o "${OUTDIR}" \
  --min_num_markers 30
