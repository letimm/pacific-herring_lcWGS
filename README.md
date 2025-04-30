# Biogeography of Pacific herring (_Clupea pallasii_) using low-coverage whole genome sequencing data
Details associated with the assembly, analyses, and visualization/plotting are below.

## Assembly
Assembly and basic analyses follow the [WGSfqs-to-genolikelihoods](https://github.com/letimm/WGSfqs-to-genolikelihoods) pipeline. The run was initialized with [CPAL-CHARFULL_config.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/CPAL-CHARFULL_config.txt).

### Index the [reference genome](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/700/415/GCF_900700415.2_Ch_v2.0.2/GCF_900700415.2_Ch_v2.0.2_genomic.fna.gz)
The reference genome was prepared with a pair of scripts: [GCF_900700415.2_Ch_v2.0.2_genomic_bwa-indexSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/GCF_900700415.2_Ch_v2.0.2_genomic_bwa-indexSLURM.sh) and [GCF_900700415.2_Ch_v2.0.2_genomic_faiSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/GCF_900700415.2_Ch_v2.0.2_genomic_faiSLURM.sh).

### Prepare the raw fastqs
Raw fastqs were quality-checked with FASTQC and multiQC. [CPAL-CHARFULL-raw_fastqcARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_fastqcARRAY.sh) ran with the array input [CPAL-CHARFULL-raw_fqcARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_fqcARRAY_input.txt).
After this script ran, results were collated with [CPAL-CHARFULL-raw_multiqcSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-raw_multiqcSLURM.sh).
[Nextera adapters](https://github.com/usadellab/Trimmomatic/blob/main/adapters/NexteraPE-PE.fa) were trimmed using [CPAL-CHARFULL_trimARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_trimARRAY.sh), which ran with the array input [CPAL-CHARFULL_trimARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_trimARRAY_input.txt).
After these ran, quality was checked for individual trimmed fastqs with [CPAL-CHARFULL-trim_fastqcARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_fastqcARRAY.sh), which ran with the array input [CPAL-CHARFULL-trim_fqcARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_fqcARRAY_input.txt).
After this script ran, results were collated with [CPAL-CHARFULL-trim_multiqcSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-trim_multiqcSLURM.sh)

### Alignment
Trimmed fastqs were aligned to the reference genome, reads sorted, duplicates removed, and overlaps clipped with the single script [CPAL-CHARFULL_alignARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_alignARRAY.sh) with the array input [CPAL-CHARFULL_alignARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_alignARRAY_input.txt).
Prior to genotype likelihood calculations, mean alignment depth was calculated for each individual with [CPAL-CHARFULL_depthsARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_depthsARRAY.sh) and the array input [CPAL-CHARFULL_depthsARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_depthsARRAY_input.txt). Depth calculation requires [mean_cov_ind.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/mean_cov_ind.py).
Mean depths were visualized in the project Rmd [pacific_herring_summary.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/pacific_herring_summary.Rmd). No individuals fell below the mean depth threshold of 1x, so all samples were included in genotype likelihood calculation.

### Calculate genotype likelihoods
Genotype likelihoods were calculated across all polymorphic sites with [CPAL-CHARFULL_polymorphicARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_polymorphicARRAY.sh) and across all sites with [CPAL-CHARFULL_globalARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_globalARRAY.sh). Both scripts ran with the array input [CPAL-CHARFULL_angsdARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_angsdARRAY_input.txt).
As the output of these scripts are genotype likelihoods for each chromosome individually, data were concatenated to generate a whole genome dataset. [CPAL-CHARFULL_concatenate_beagles.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_beagles.sh) joined likelihood data.
[CPAL-CHARFULL_concatenate_mafs.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_mafs.sh) joined MAF data.

## Analyses
### PCA
I generated a PCA for the whole genome with [Afim_wholegenome_pcangsd.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/Afim_wholegenome_pcangsd.sh). Two outliers (ABLG1633 and ABLG1634) were determined to be a duplicated sample, so I re-ran the PCA with one outlier (ABLG1633) removed with [Afim_wholegenome_pcangsd-keep119.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/Afim_wholegenome_pcangsd-keep119.sh). As this resolved the issue, I re-ran steps 6 and 7 above with ABLG1633 excluded.
Six clusters remained in the PCA. To clarify where this signal came from within the genome, I ran a PCA for every chromosome with [Afim_pcangsdARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_pcangsdARRAY.sh) which ran over the array [CPAL-CHARFULL_pcangsdARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_pcangsdARRAY_input.txt).
Signal came from chromosome 22. A new "whole genome" beagle file was generated by concatenating likelihood data from all chromosomes **except** chromosome 22 with [CPAL-CHARFULL_concatenate_beagles-nix22.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_concatenate_beagles-nix22.sh) and a new PCA was generated ([CPAL-CHARFULL_wholegenome_pcangsd-nix22.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_wholegenome_pcangsd-nix22.sh)).
PCAs were visualized with [pcangsd_graph.R](https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/pcangsd_graph.R).

Prior to population analyses, the checkpoint file was copied and edited to branch analyses. The checkpoint files for each branch are:
- [CPAL-CHARFULL-4regions.ckpt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-4regions.ckpt) to analyze individuals by collection region
- [CPAL-CHARFULL-clusters.ckpt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters.ckpt) to analyze individuals by cluster
- [CPAL-CHARFULL-sex.ckpt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-sex.ckpt) to analyze individuals by sex (note that sample sizes are smaller here because only a subset of samples were sexed)

### Population-level _FST_
Individuals were organized in two ways that were informative for the research questions: by region (Bering Sea and Aleutian Islands - BSAI, western Gulf of Alaska - wGOA, eastern Gulf of Alaska - eGOA, and the Washington State coast - south) and by cluster (A-F representing the six clusters in the whole genome PCA, from left to right).
_FST_ values were calculated for all population pairs within these schemes using [CPAL-CHARFULL_summaryFST-pt1_ARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_summaryFST-pt1_ARRAY.sh) and [CPAL-CHARFULL_summaryFST-pt2_ARRAY.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_summaryFST-pt2_ARRAY.sh). 
Within each script, an array file specifies the populations and population pairs.
| scheme | groups | pt1 array | pt2 array |
| ------ | ------ | ------ | ------ |
| regions | BSAI, wGOA, eGOA, south | [CPAL-CHARFULL-regions_summaryFST-pt1_ARRAY_input.txt] | [CPAL-CHARFULL-regions_summaryFST-pt2_ARRAY_input.txt] |
| clusters | A, B, C, D, E, F | [CPAL-CHARFULL-clusters_summaryFST-pt1_ARRAY_input.txt] | [CPAL-CHARFULL-clusters_summaryFST-pt2_ARRAY_input.txt] |

To examine the statistical significance of the calculated _FST_ values, I ran a permutation test for every population pair. Briefly, given the four populations BSAI (n = 25), wGOA (n = 17), eGOA (n = 28), and south (n = 49), for each permutation all 119 individuals are randomly shuffled into these four populations, maintaining sample sizes. Pairwise population-level _FST_ values are calculated for this new arrangement of individuals. After the permutations have concluded and we have a distribution of _FST_ values for each population pair, we calculate the mean of each distribution and use it to estimate the cumulative distribution function (CDF) of the _FST_ result for the population pair under an exponential distribution. P-val is estimated as 1 - CDF.

Distributions were generated with [CPAL-CHARFULL-4regions_fst_posterior.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-4regions_fst_posterior.sh) and [CPAL-CHARFULL-clusters_fst_posterior.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters_fst_posterior.sh).
Significance was tested with [CPAL-CHARFULL-4regions_fst-sig-test-wrapper.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-4regions_fst-sig-test-wrapper.sh) and [CPAL-CHARFULL-clusters_fst-sig-test-wrapper.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters_fst-sig-test-wrapper.sh) (these scripts call [fst_significance_test.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/fst_significance_test.py)).

### Genome scan
In addition to the two schemes listed above, samples from Washington State were sexed, allowing for analysis of males vs females.
| scheme | groups | scan array |
| ------ | ------ | ------ |
| regions | BSAI, wGOA, eGOA, south | [CPAL-CHARFULL_popARRAY.sh] |
| clusters | A, B, C, D, E, F | [CPAL-CHARFULL-clusters_popARRAY.sh] |
| sex | male, female | [CPAL-CHARFULL-sex_popARRAY.sh] |

These scripts take [CPAL-CHARFULL_angsdARRAY_input.txt](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_angsdARRAY_input.txt) as array input.

Results were visualized with R scripts on a cluster (which is why there is a shell for each R script).
| regions | r script | wrapper |
| ------ | ------ | ------ |
| BSAI | [fst_genomescan_regions-BSAI.R] | [Afim_genomescanFIG_regions-BSAI.sh] |
| wGOA | [fst_genomescan_regions-wGOA.R] | [Afim_genomescanFIG_regions-wGOA.sh] |
| eGOA | [fst_genomescan_regions-eGOA.R] | [Afim_genomescanFIG_regions-eGOA.sh] |
| south | [fst_genomescan_regions-south.R] | [Afim_genomescanFIG_regions-south.sh] |

| clusters | r script | wrapper |
| ------ | ------ | ------ |
| A | [fst_genomescan_clusters-A.R] | [Afim_genomescanFIG_clusters-A.sh] |
| B | [fst_genomescan_clusters-B.R] | [Afim_genomescanFIG_clusters-B.sh] |
| C | [fst_genomescan_clusters-C.R] | [Afim_genomescanFIG_clusters-C.sh] |
| D | [fst_genomescan_clusters-D.R] | [Afim_genomescanFIG_clusters-D.sh] |
| E | [fst_genomescan_clusters-E.R] | [Afim_genomescanFIG_clusters-E.sh] |
| F | [fst_genomescan_clusters-F.R] | [Afim_genomescanFIG_clusters-F.sh] |

| sex | r script | wrapper |
| ------ | ------ | ------ |
| female | [fst_genomescan_female.R] | [Afim_genomescanFIG_female.sh] |

These genome scans revealed
1) A lack of genetic structure across the geographic range.
2) Two large inversions dominating chromosome 22 and driving the clustering seen in teh whole genome PCA.
3) A distinct peak on chromosome 14 that differentiates males and females.

The inversions and peak were investigated in more detail.

## Regions of Interest
### _gsdf_: the master sex-determining gene in pacific-herring
When BLASTing the sequence associated with the peak in _FST_ values on chromosome 14 when comparing males to females, the top hits are 'Anoplopoma fimbria chromosome X putative gonadal soma-derived factor (gsdf) gene, complete cds' and 'Anoplopoma fimbria chromosome X putative gonadal soma-derived factor (gsdf) gene, complete cds' ([KC623942.1](https://www.ncbi.nlm.nih.gov/nuccore/KC623942.1) and [KC623943.1](https://www.ncbi.nlm.nih.gov/nuccore/KC623943.1), respectively).
Initially, I examined sequencing depths along the region of interest on chr14. _gsdf_ has X-specific and Y-specific segments and the reference genome includes the X-specific sequence (not the Y-specific sequence). Because of this, we expect sequencing depth to drop along the X-specific segment. To confirm this, I counted sequencing depths along _gsdf_ with [CPAL-CHARFULL_global_gsdf-depths_female_nofilter.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_global_gsdf-depths_female_nofilter.sh) and [CPAL-CHARFULL_global_gsdf-depths_male_nofilter.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_global_gsdf-depths_male_nofilter.sh). To reduce the noise of basepair-by-basepair sequencing depths, I ran a 100bp sliding window analysis in R and plotted the results for males and females with [coverage_sliding_window.Rmd](https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/coverage_sliding_window.Rmd).

To analyze this region, I extracted it from the larger dataset with [chr14_peak.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr14-peak.sh), which calls [subset_pca.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/subset_pca.py) and results in a new beagle file and a script ([chr14peak_pcaSLURM.sh](https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr14peak_pcaSLURM.sh)) for executing a PCA of the extarcted region.
Finally, a genotype heatmap was plotted for the region with [genotypeHeatmap_sex.R](https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/genotypeHeatmap_sex.R).

### Chromosome 16 inversions
Two large inversions were identified on chromosome 22.
First, I pulled these regions from the full dataset. Then I conducted PCAs for each inversion and investigated linkage.
| inversion | region (bps) | subset script | pca script | linkage script |
| ------ | ------ | ------ | ------ | ------ |
| inv1 | 4.13e6-8.19e6 | [chr22-inv1_4.13-8.19_0.3fst.sh] | [chr22-inv1_4.13-8.19_0.3fst_pcaSLURM.sh] | [chr22-inv1_LD.sh] |
| inv2 | 8.97e6-11.90e6 | [chr22-inv2_8.97-11.9_0.3fst.sh] | [chr22-inv2_8.97-11.9_0.3fst_pcaSLURM.sh] | [chr22-inv2_LD.sh] |

The linkage scripts require [ldplot_general.R](https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/ldplot_general.R) to plot the output.

The majority of the R scripts listed here were developed by Sara Schaal.

[CPAL-CHARFULL-regions_summaryFST-pt1_ARRAY_input.txt]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-4regions_summaryFST-pt1_ARRAY_input.txt>
[CPAL-CHARFULL-regions_summaryFST-pt2_ARRAY_input.txt]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-4regions_summaryFST-pt2_ARRAY_input.txt>
[CPAL-CHARFULL-clusters_summaryFST-pt1_ARRAY_input.txt]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters_summaryFST-pt1_ARRAY_input.txt>
[CPAL-CHARFULL-clusters_summaryFST-pt2_ARRAY_input.txt]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters_summaryFST-pt2_ARRAY_input.txt>

[CPAL-CHARFULL_popARRAY.sh]:
<https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL_popARRAY.sh>
[CPAL-CHARFULL-clusters_popARRAY.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-clusters_popARRAY.sh>
[CPAL-CHARFULL-sex_popARRAY.sh]:
<https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/CPAL-CHARFULL-sex_popARRAY.sh>

[fst_genomescan_regions-BSAI.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_regions-BSAI.R>
[fst_genomescan_regions-wGOA.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_regions-wGOA.R>
[fst_genomescan_regions-eGOA.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_regions-eGOA.R>
[fst_genomescan_regions-south.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_regions-south.R>
[Afim_genomescanFIG_regions-BSAI.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_regions-BSAI.sh>
[Afim_genomescanFIG_regions-wGOA.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_regions-wGOA.sh>
[Afim_genomescanFIG_regions-eGOA.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_regions-eGOA.sh>
[Afim_genomescanFIG_regions-south.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_regions-south.sh>

[fst_genomescan_clusters-A.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-A.R>
[fst_genomescan_clusters-B.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-B.R>
[fst_genomescan_clusters-C.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-C.R>
[fst_genomescan_clusters-D.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-D.R>
[fst_genomescan_clusters-E.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-E.R>
[fst_genomescan_clusters-F.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_clusters-F.R>
[Afim_genomescanFIG_clusters-A.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-A.sh>
[Afim_genomescanFIG_clusters-B.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-B.sh>
[Afim_genomescanFIG_clusters-C.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-C.sh>
[Afim_genomescanFIG_clusters-D.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-D.sh>
[Afim_genomescanFIG_clusters-E.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-E.sh>
[Afim_genomescanFIG_clusters-F.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_clusters-F.sh>

[fst_genomescan_female.R]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/fst_genomescan_female.R>
[Afim_genomescanFIG_female.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/plotting/Afim_genomescanFIG_female.sh>

[chr22-inv1_4.13-8.19_0.3fst.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv1_4.13-8.19_0.3fst.sh>
[chr22-inv2_8.97-11.9_0.3fst.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv2_8.97-11.9_0.3fst.sh>
[chr22-inv1_4.13-8.19_0.3fst_pcaSLURM.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv1_4.13-8.19_0.3fst_pcaSLURM.sh>
[chr22-inv2_8.97-11.9_0.3fst_pcaSLURM.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv2_8.97-11.9_0.3fst_pcaSLURM.sh>
[chr22-inv1_LD.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv1_LD.sh>
[chr22-inv2_LD.sh]: <https://github.com/letimm/pacific-herring_lcWGS/blob/main/scripts/chr22-inv2_LD.sh>
