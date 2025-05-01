#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=plm_CPAL-MTFULL
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-MTFULL_filteredGLS_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd

#where did I get the min and max depths?
#n = 120
#average seq depth for the mt alignments is ~412
#min depth = 412 * 120 * 1
#max depth = 412 * 120 * 5
# that only retained 47 snps, so...

#10x was the blacklist cutoff
#min depth = 120 * 10
#max depth = 120 * 100
# that didn't retain anything (probably too low)

#let's try
#min depth = 120 * 10
#max depth = 412 * 120 * 5

angsd sites index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-MTFULL_wholegenome_polymorphic_retain.sites

angsd \
	-b /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-MTFULL_filtered_bamslist.txt \
	-ref /center1/GLASSLAB/letimm/ref_genomes/clupea_pallasii_mtgenome.fna \
	-r NC_009578.1: \
	-sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-MTFULL_wholegenome_polymorphic_retain.sites \
	-out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-MTFULL_wgph \
	-nThreads 10 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minMapQ 15 \
	-minQ 15 \
	-doCounts 1 \
	-setminDepth 1200 \
	-setmaxDepth 247412 \
	-doGlf 2 \
	-GL 1 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-minMaf 0.05 \
	-SNP_pval 1e-10 \
	-doDepth 1 \
	-dumpCounts 3 \
	-only_proper_pairs 1
