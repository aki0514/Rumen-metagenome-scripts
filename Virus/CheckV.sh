#!/bin/bash
# Usage:
#   bash Checkv.sh <ViralFasta> <OutputPrefix> <CheckV_DB>
#
# <ViralFasta>  : viral contigs FASTA (e.g., from geNomad end-to-end)
# <OutputPrefix>: prefix for output directory/files (e.g., SampleA)
# <CheckV_DB>   : path to CheckV database (e.g., /path/to/checkv-db)

IN="$1"
PREFIX="$2"
CHECKV_DB="$3"

OUTDIR="${PREFIX}_checkv"
mkdir -p "${OUTDIR}"

# Run CheckV
checkv end_to_end "${IN}" "${OUTDIR}" -d "${CHECKV_DB}"

QS="${OUTDIR}/quality_summary.tsv"

grep -e $'\tYes\t' "${QS}" | grep -e 'High-quality'   | cut -f 1 > "${OUTDIR}/High_quality_provirus_tmp.txt"
grep -e $'\tYes\t' "${QS}" | grep -e 'Medium-quality' | cut -f 1 > "${OUTDIR}/Medium_quality_provirus_tmp.txt"

# Map provirus IDs to sequence IDs present in proviruses.fna
seqkit seq -n "${OUTDIR}/proviruses.fna" | cut -d' ' -f1 > "${OUTDIR}/proviruses_id.txt"
grep -F -f "${OUTDIR}/High_quality_provirus_tmp.txt"   "${OUTDIR}/proviruses_id.txt" > "${OUTDIR}/High_quality_provirus.txt"
grep -F -f "${OUTDIR}/Medium_quality_provirus_tmp.txt" "${OUTDIR}/proviruses_id.txt" > "${OUTDIR}/Medium_quality_provirus.txt"

grep -e $'\tNo\t' "${QS}" | grep -e 'High-quality'   | cut -f 1 > "${OUTDIR}/High_quality_virus.txt"
grep -e $'\tNo\t' "${QS}" | grep -e 'Medium-quality' | cut -f 1 > "${OUTDIR}/Medium_quality_virus.txt"

cat "${OUTDIR}/High_quality_virus.txt" \
    "${OUTDIR}/High_quality_provirus.txt" \
    "${OUTDIR}/Medium_quality_virus.txt" \
    "${OUTDIR}/Medium_quality_provirus.txt" \
    > "${OUTDIR}/all_virus.txt"

cat "${OUTDIR}/proviruses.fna" "${OUTDIR}/viruses.fna" > "${OUTDIR}/combined.fna"
seqkit grep -f "${OUTDIR}/all_virus.txt" "${OUTDIR}/combined.fna" > "${OUTDIR}/${PREFIX}_virus.fna"
seqkit seq -m 5000 "${OUTDIR}/${PREFIX}_virus.fna" > "${OUTDIR}/${PREFIX}_5k_virus.fna"
