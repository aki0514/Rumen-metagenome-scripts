#!/bin/bash
# Usage:
#   bash calc_tpm.sh <SampleName> <CovermRawFile>
#
# <SampleName>     : sample name (used as prefix for output files)
# <CovermRawFile>  : coverm genome output (TSV)

SAMPLE="$1"
INPUT="$2"

OUTDIR=$(dirname "${INPUT}")

Rscript - <<EOF
library(tidyverse)

# Load file
df <- read_tsv("${INPUT}", show_col_types = FALSE)

# Detect column names
col_read <- grep("Read Count", colnames(df), value = TRUE)
col_cov  <- grep("Covered Fraction", colnames(df), value = TRUE)
col_len  <- grep("Length", colnames(df), value = TRUE)

df <- df %>%
  rename(
    contig = Genome,
    count = !!sym(col_read),
    covered_fraction = !!sym(col_cov),
    length = !!sym(col_len)
  )

# Filter: set to 0 if covered_fraction < 0.1
df <- df %>%
  mutate(
    count = if_else(covered_fraction < 0.1, 0, count)
  )

# TPM calculation
df <- df %>%
  mutate(
    length_kb = length / 1000,
    rpk = count / length_kb,
    tpm = rpk / sum(rpk) * 1e6
  )

# Output files
write_tsv(df, file.path("${OUTDIR}", "${SAMPLE}_filtered_tpm.tsv"))
write_tsv(df %>% select(contig, count), file.path("${OUTDIR}", "${SAMPLE}_filtered_count.tsv"))
EOF
