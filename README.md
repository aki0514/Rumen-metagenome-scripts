# Rumen-metagenome-scripts

This repository contains analysis pipelines for **rumen metagenome and virome studies**.  
The scripts are organized into two main categories:

- **MAG** : Metagenome-Assembled Genome analysis  
- **Virus** : Viral genome analysis  

Each pipeline consists of modular shell scripts (`.sh`) that can be run step by step.

---

## MAG Pipeline

1. **trim.sh** – Quality control and trimming  
2. **BWA_reference.sh** – Host read removal  
3. **Assemble_MAG.sh** – Assembly using SPAdes  
4. **BWA_back.sh** – Read mapping back to contigs  
5. **metabat2.sh / MaxBin2.sh / CONCOCT.sh** – Binning  
6. **DASTool.sh** – Bin refinement  
7. **CheckM2.sh** – Quality assessment  
8. **dRep99.sh** – Dereplication  
9. **gtdb-tk226.sh** – Taxonomic classification  
10. **phylophlan.sh** – Phylogenomic tree  
11. **prodigal.sh** – Gene prediction  
12. **HMM_cazy.sh** – Functional annotation (CAZy HMM)  
13. **coverm_MAG.sh + calc_tpm.sh** – Read recruitment & TPM calculation  

---

## Virus Pipeline

1. **trim.sh** – Quality control and trimming  
2. **Assemble_virus.sh** – Viral assembly (SPAdes, contigs ≥ 5 kb)  
3. **genomad.sh** – Viral identification and annotation  
4. **CheckV.sh** – Viral genome quality check  
5. **cd_hit.sh** – Dereplication of viral contigs  
6. **prodigal.sh** – Gene prediction (viral ORFs)  
7. **vcontact2.sh** – Viral clustering & network analysis  
8. **PhaTYP.sh** – Lifestyle prediction (lytic/lysogenic)  
9. **Crispr.sh** – CRISPR spacer extraction (host MAGs)  
10. **Blast_CRISPR.sh** – Spacer–virus interaction mapping  
11. **coverm_virus.sh + calc_tpm_virus.sh** – Viral abundance quantification  

---
## Related Publications

The analyses implemented in this repository are part of an ongoing manuscript:

- **Sato et al.**  
  *Maternal contact and age-dependent succession govern the establishment of the calf rumen microbiome and virome*  
  (In preparation)
