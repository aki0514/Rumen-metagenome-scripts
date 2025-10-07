#!/bin/bash
# Usage:
#   bash calc_tpm_virus.sh <coverm_raw.tsv> <OutputPrefix>
#
# <coverm_raw.tsv>: CoverM output (count, covered_fraction, length)
# <OutputPrefix>  : prefix for output files

IN="$1"
PREFIX="$2"

OUTDIR=$(dirname "$IN")

Rscript - <<EOF
library(tidyverse)

# Load data
df <- read_tsv("${IN}", show_col_types = FALSE)

# Detect relevant columns
col_read <- grep("Read Count", colnames(df), value = TRUE)
col_cov  <- grep("Covered Fraction", colnames(df), value = TRUE)
col_len  <- grep("Length", colnames(df), value = TRUE)

df <- df %>%
  rename(
    contig = 1,
    count = !!sym(col_read),
    covered_fraction = !!sym(col_cov),
    length = !!sym(col_len)
  )

# Apply 0.7 coverage filter
df <- df %>%
  mutate(
    count = if_else(covered_fraction < 0.7, 0, count),
    covered_fraction = if_else(covered_fraction < 0.7, 0, covered_fraction)
  )

# TPM calculation
df <- df %>%
  mutate(
    length_kb = length / 1000,
    rpk = count / length_kb,
    tpm = rpk / sum(rpk) * 1e6
  )

# Save outputs
write_tsv(df, file.path("${OUTDIR}", "${PREFIX}_tpm.tsv"))
write_tsv(df %>% select(contig, count), file.path("${OUTDIR}", "${PREFIX}_count.tsv"))
EOF
