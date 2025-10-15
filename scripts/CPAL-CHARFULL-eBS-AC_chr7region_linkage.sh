#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=ld
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii120/job_outfiles/CPAL-CHARFULL-eBS-AC_chr7region_linkage_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0 zlib/1.2.12

PATH=$PATH:/home/letimm/software/ngsLD

base_filename="/center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS-AC_chr7region"
ld_base_filename=${base_filename/gls/linkage}
zcat ${base_filename}.beagle.gz | sed '1d' | gzip > ${base_filename}.tmp.beagle.gz
zcat ${base_filename}.tmp.beagle.gz | awk '{print $1}' | sed 's/.1_/.1\t/g' > ${ld_base_filename}.pos
zcat ${base_filename}.tmp.beagle.gz | cut -f 4- | gzip > ${ld_base_filename}.beagle.gz
rm ${base_filename}.tmp.beagle.gz
num_lines=$(< "${ld_base_filename}.beagle.gz" zcat | wc -l)

ngsLD \
	--geno ${ld_base_filename}.beagle.gz \
	--pos ${ld_base_filename}.pos \
	--probs \
	--n_ind 29 \
	--n_sites ${num_lines} \
	--max_kb_dist 0 \
	--n_threads 10 \
	--out ${ld_base_filename}.ld
