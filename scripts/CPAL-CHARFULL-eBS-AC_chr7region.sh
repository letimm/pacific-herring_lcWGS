#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=eBS_chr7
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii120/job_outfiles/CPAL-CHARFULL-eBS_chr7region_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd

angsd \
	-b /center1/GLASSLAB/letimm/Clupea_pallasii120/CPAL-CHARFULL-eBS-AC_filtered_bamslist.txt \
	-ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-sites /center1/GLASSLAB/letimm/Clupea_pallasii120/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites \
	-r NC-045158.1:13841600-13851100 \
	-out /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS-AC_chr7region \
	-nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 \
	-minMapQ 15 -minQ 15 \
	-doCounts 1 \
	-setminDepth 29 \
	-setmaxDepth 145 \
	-doGlf 2 \
	-GL 1 -doMaf 1 -doMajorMinor 1 -minMaf 0.05 -SNP_pval 1e-10 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1
