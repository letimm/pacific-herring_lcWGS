# Biogeography of Pacific herring (_Clupea pallasii_) using low-coverage whole genome sequencing data
Details associated with the assembly, analyses, and visualization/plotting are below.

## Assembly
Assembly and basic analyses follow the [WGSfqs-to-genolikelihoods](https://github.com/letimm/WGSfqs-to-genolikelihoods) pipeline. The run targeting nuclear data was initialized with [CPAL-CHARFULL_config.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/CPAL-CHARFULL_config.txt). The run targeting mitogenomic data was initialized with [CPAL-MTFULL_config.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/CPAL-MTFULL_config.txt).
Non-data files required for running these scripts (files listing bamfiles associated with a group or population, mean individual sequencing depths, etc.) are provided in [miscellaneous](https://github.com/letimm/pacific-herring_lcWGS/tree/main/miscellaneous).

### Index reference genomes
The [Atlantic herring reference genome](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/700/415/GCF_900700415.2_Ch_v2.0.2/GCF_900700415.2_Ch_v2.0.2_genomic.fna.gz) was prepared with a pair of scripts: [GCF_900700415.2_Ch_v2.0.2_genomic_bwa-indexSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/GCF_900700415.2_Ch_v2.0.2_genomic_bwa-indexSLURM.sh) and [GCF_900700415.2_Ch_v2.0.2_genomic_faiSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/GCF_900700415.2_Ch_v2.0.2_genomic_faiSLURM.sh).

The [Pacific herring mitochondrial genome](https://www.ncbi.nlm.nih.gov/nuccore/NC_009578.1?report=fasta) was indexed with [clupea_pallasii_mtgenome_bwa-indexSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/clupea_pallasii_mtgenome_bwa-indexSLURM.sh) and [clupea_pallasii_mtgenome_faiSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/clupea_pallasii_mtgenome_faiSLURM.sh).

### Prepare the raw fastqs
Raw fastqs were quality-checked with FASTQC and multiQC. [CPAL-CHARFULL-raw_fastqcARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_fastqcARRAY.sh) ran with the array input [CPAL-CHARFULL-raw_fqcARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_fqcARRAY_input.txt).
After this script ran, results were collated with [CPAL-CHARFULL-raw_multiqcSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_multiqcSLURM.sh).
[Nextera adapters](https://github.com/usadellab/Trimmomatic/blob/main/adapters/NexteraPE-PE.fa) were trimmed using [CPAL-CHARFULL_trimARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_trimARRAY.sh), which ran with the array input [CPAL-CHARFULL_trimARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_trimARRAY_input.txt).
After these ran, quality was checked for individual trimmed fastqs with [CPAL-CHARFULL-trim_fastqcARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_fastqcARRAY.sh), which ran with the array input [CPAL-CHARFULL-trim_fqcARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_fqcARRAY_input.txt).
After this script ran, results were collated with [CPAL-CHARFULL-trim_multiqcSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_multiqcSLURM.sh)

### Align to nuclear genome
Trimmed fastqs were aligned to the reference genome, reads sorted, duplicates removed, and overlaps clipped with the single script [CPAL-CHARFULL_alignARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_alignARRAY.sh) with the array input [CPAL-CHARFULL_alignARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_alignARRAY_input.txt).
Prior to genotype likelihood calculations, mean alignment depth was calculated for each individual with [CPAL-CHARFULL_depthsARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_depthsARRAY.sh) and the array input [CPAL-CHARFULL_depthsARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_depthsARRAY_input.txt). Depth calculation requires [mean_cov_ind.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/mean_cov_ind.py).
Mean depths were visualized in the project Rmd [pacific_herring_summary.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/RMarkdown_htmls/pacific_herring_summary.Rmd). No individuals fell below the mean depth threshold of 1x, so all samples were included in genotype likelihood calculation.

### Align to mitogenome
Trimmed reads were aligned to the mitgenome with [CPAL-MTFULL_alignARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_alignARRAY.sh), arrayed across individuals with [CPAL-MTFULL_alignARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_alignARRAY_input.txt). Mean alignment depth across the mitgenome was calculated for each individual with [CPAL-MTFULL_depthsARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_depthsARRAY.sh), arrayed with [CPAL-MTFULL_depthsARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_depthsARRAY_input.txt).
Mean depths for mitogenomic alignments were visualized in [pacific-herring_mt-genome.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/RMarkdown_htmls/pacific-herring_mt-genome.Rmd). No individuals were excluded from genotype likelihood calculation due to low coverage across the mitogenome.

### Calculate genotype likelihoods across the nuclear genome
Genotype likelihoods were calculated across all polymorphic sites with [CPAL-CHARFULL_polymorphicARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_polymorphicARRAY.sh) and across all sites with [CPAL-CHARFULL_globalARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_globalARRAY.sh). Both scripts ran with the array input [CPAL-CHARFULL_angsdARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_angsdARRAY_input.txt).
As the output of these scripts are genotype likelihoods for each chromosome individually, data were concatenated to generate a whole genome dataset. [CPAL-CHARFULL_concatenate_beagles.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_beagles.sh) joined likelihood data.
[CPAL-CHARFULL_concatenate_mafs.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_mafs.sh) joined MAF data.

### Calculate genotype likelihoods across the mitogenome
Genotype likelihoods were calculated for all polymorphic sites in the mitogenome with [CPAL-MTFULL_polymorphic.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_polymorphic.sh).

### Filter paralogous sites in the nuclear data
Paralogous sites were identified by piping samtools mpileup output to ngsParalog. The likelihood ratio for each site was tested for significance in R with [ngsParalog_sigTest.R](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/ngsParalog_sigTest.R). Finally, retained sites were indexed in ANGSD with [CPAL-CHARFULL_paralogs.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_paralogs.sh)
After indexing a list of homologous sites, genotype likelihoods were calculated by-chromosome at these sites with [CPAL-CHARFULL_filteredGLS.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_filteredGLS.sh). Chromosomal beagles and mafs were concatenated with [CPAL-CHARFULL_concatenate_wgph_beagles.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_wgph_beagles.sh) and [CPAL-CHARFULL_concatenate_wgph_mafs.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_wgph_mafs.sh), respectively.
Analyses were conducted on these polymorphic, homologous data.

### Filter paralogous sites in the mitogenomic data
Paralogous sites were filtered out and sites to retain were indexed with [CPAL-MTFULL_paralogs.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_paralogs.sh). Genotype likelihoods were re-calculated for these homologous sites with [CPAL-MTFULL_filteredGLS.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-MTFULL_filteredGLS.sh). 
Genotype likelihoods were converted to a FASTA file with [beagle2fasta.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/beagle2fasta.py).
The FASTA was reviewed in Geneious Prime v2024.0.5. Individuals with >10% missing data (n = 13) were excluded from downstream analysis.

## Analysis of mitogenomic data
Mitogenomic data were analyzed with several R packages. These are detailed in [pacific-herring_mt-genome.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/RMarkdown_htmls/pacific-herring_mt-genome.Rmd).
PCA revealed three haplogroups: an eBSAI haplogroup and two nGOA haplogroups. Individuals comprising these two nGOA haplogroups (nGOA-haplogroup1 and nGOA-haplogroup2) were investigated with nuclear data (does this strong mitogenomic signal correspond to nuclear signal? see [Identifying adaptive regions in the genome](https://github.com/letimm/pacific-herring_lcWGS/blob/main/README.md#identifying-adaptive-regions-in-the-genome)).

## Analysis of nuclear data
### PCA
I conducted a PCA for the whole genome with [CPAL-CHARFULL_wgph_pcangsd.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_wgph_pcangsd.sh) Given the large percent variation explained by PC1, I ran three additional PCAs: an eBSAI-specific PCA [CPAL-CHARFULL-eBSAI_wgph_pcangsd.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-eBSAI_wgph_pcangsd.sh), a nGOA-specific PCA that includes Popof Island [CPAL-CHARFULL-nGOA_wgph_pcangsd.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-nGOA_wgph_pcangsd.sh), and a nGOA-specific PCA that excludes Popof Island [CPAL-CHARFULL-nGOA-noPopof_wgph_pcangsd.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-nGOA-noPopof_wgph_pcangsd.sh). The eBSAI-specific PCA was driven by two outliers, so one outlier was removed to calculate a new PCA [CPAL-CHARFULL-eBSAI_wgph_pcangsd_keep59.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-eBSAI_wgph_pcangsd_keep59.sh). Four clusters were identified in the resulting PCA and these were futher investigated in [Identifying adaptive regions in the genome](https://github.com/letimm/pacific-herring_lcWGS/blob/main/README.md#identifying-adaptive-regions-in-the-genome). PCAs were visualized in [pacific_herring_summary.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/RMarkdown_htmls/pacific_herring_summary.Rmd).

Moving forward, population-level analyses were conducted to evaluate:
- a regional scenario; Togiak (TOG), Constantine Bay (CB), Port Moller (PM), Popof Island (PI), Kodiak - Uganik (KU), Kodiak - Kiliuda (KK), Cordova (COR)
- a two-population scenario; nGOA (PI, KU, KK, COR) vs eBSAI (TOG, CB, PM)
- a three-population scenario; nGOA (KU, KK, COR) vs PI vs eBSAI (TOG, CB, PM)


### Pairwise _FST_
After individuals were organized as described above, _FST_ values were calculated for all population pairs within these schemes using [CPAL-CHARFULL2pops_pairwiseFST-pt1_ARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_pairwiseFST-pt1_ARRAY.sh) and [CPAL-CHARFULL2pops_pairwiseFST-pt2_ARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_pairwiseFST-pt2_ARRAY.sh). 
Within each script, an array file specifies the populations and population pairs.
| scheme | groups | pt1 array | pt2 array |
| ------ | ------ | ------ | ------ |
| region | TOG, CB, PM, PI, KU, KK, COR | [CPAL-CHARFULLregion_pairwiseFST-pt1_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLregion_pairwiseFST-pt1_ARRAY_input.txt) | [CPAL-CHARFULLregion_pairwiseFST-pt2_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLregion_pairwiseFST-pt2_ARRAY_input.txt) |
| 2pops | nGOA (with PI), eBSAI | [CPAL-CHARFULL2pops_pairwiseFST-pt1_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_pairwiseFST-pt1_ARRAY_input.txt) | [CPAL-CHARFULL2pops_pairwiseFST-pt2_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_pairwiseFST-pt2_ARRAY_input.txt) |
| 3pops | nGOA (without PI), PI, eBSAI | [CPAL-CHARFULL3pops_pairwiseFST-pt1_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL3pops_pairwiseFST-pt1_ARRAY_input.txt) | [CPAL-CHARFULL3pops_pairwiseFST-pt2_ARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL3pops_pairwiseFST-pt2_ARRAY_input.txt) |

To examine the statistical significance of the calculated _FST_ values, I ran a permutation test for every population pair. Briefly, given the three-population scenario (eBSAI, n = 60; PI, n = 20; nGOA, n = 40) , for each permutation all 120 individuals are randomly shuffled into these three populations, maintaining sample sizes. Pairwise population-level _FST_ values are calculated for this new arrangement of individuals. After the permutations have concluded and we have a distribution of _FST_ values for each population pair, we calculate the mean of each distribution and use it to estimate the cumulative distribution function (CDF) of the _FST_ result for the population pair under an exponential distribution. P-val is estimated as 1 - CDF.

Distributions were generated with [CPAL-CHARFULLregion_fst_posterior.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLregion_fst_posterior.sh), [CPAL-CHARFULL2pops_fst_posterior.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_fst_posterior.sh), and [CPAL-CHARFULL3pops_fst_posterior.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL3pops_fst_posterior.sh).
Significance was tested with [generate-fst-posterior_chinook.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/generate-fst-posterior_chinook.py).

### Population-level metrics
[CPAL-CHARFULL_diversityARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_diversityARRAY.sh) calculated diversity with the array input [CPAL-CHARFULL_diversityARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_diversityARRAY_input.txt). Heterozygosity was calculated with [CPAL-CHARFULL_heterozygosityARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_heterozygosityARRAY.sh) arrayed across individuals with [CPAL-CHARFULL_heterozygosityARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_heterozygosityARRAY_input.txt). Scripts are provided below. Population-level diversity was calculated from the pestPG files as the sum of each chromosome's diversity value, divided by the total number of sites that diversity was calculated over.
Individual heterozygosity was calculated from the ml files as the number of heterozygous sites divided by the total number of sites. Population-level heterozygosity was calculated as the average individual heterozygosity for the population.


### Identifying adaptive regions in the genome
#### _FST_ genome scans
To identify genomic sites differentiating between groups, _FST_ was calculated for every SNP in each scheme described. Two additional schemes were used to investigate the genomic differences underlying the clusters identified in the eBSAI PCA (eBSAInuc; see the section on the [eBSAI PCA](https://github.com/letimm/pacific-herring_lcWGS/blob/main/README.md#pca)) and the nGOA haplogroups identified in the mitogenome (nGOAmt; see [Analysis of mitogenomic data](https://github.com/letimm/pacific-herring_lcWGS/blob/main/README.md#analysis-of-mitogenomic-data) above).
| scheme | groups | scan array |
| ------ | ------ | ------ |
| region | TOG, CB, PM, PI, KU, KK, COR | [CPAL-CHARFULLregion_popARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLregion_popARRAY.sh) |
| 2pops | nGOA (with PI), eBSAI | [CPAL-CHARFULL2pops_popARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL2pops_popARRAY.sh) |
| 3pops | nGOA (without PI), PI, eBSAI | [CPAL-CHARFULL3pops_popARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL3pops_popARRAY.sh) |
| eBSAInuc | eBSAI-A, eBSAI-B, eBSAI-C | [CPAL-CHARFULLeBSAInuc_popARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLeBSAInuc_popARRAY.sh) |
| nGOAmt | nGOA-haplogroup1, nGOA-haplogroup2 | [CPAL-CHARFULLnGOAmt_popARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULLnGOAmt_popARRAY.sh) |

These scripts take [CPAL-CHARFULL_angsdARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_angsdARRAY_input.txt) as array input.

####  Local score analysis
To identify genomic sites under selection, local score analysis was conducted for each scheme described.
Allele counts were made with [CPAL-CHARFULL_dumpCountsARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_dumpCountsARRAY.sh), which takes [CPAL-CHARFULL_dumpCountsARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_dumpCountsARRAY_input.txt) as array input. Fisher's Exact Test (FET) results were calculated from allele counts with [dumpCounts2FET.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/dumpCounts2FET.Rmd). Local score analyses were conducted over these FET results with [FET2localScores.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/FET2localScores.Rmd).

Results were visualized in an R markdown [manhattan_plots.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/RMarkdown_htmls/manhattan_plots.Rmd).
