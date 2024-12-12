#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=plm_CPAL-CHAR
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_polymorphic_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-26%24

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii/scripts/CPAL-CHAR_angsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	contig=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

#bespoke! (rounded to nearest whole number)
#minDepth = 0.5 * mean coverage * N
#maxDepth = 2 * mean coverage * N
#minInd = 0.8 * N

angsd \
	-b /center1/GLASSLAB/letimm/Clupea_pallasii/CPAL-CHAR_filtered_bamslist.txt \
	-ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-r ${contig}: \
	-out /center1/GLASSLAB/letimm/Clupea_pallasii/gls/bespoke/CPAL-CHAR_${contig}_polymorphic \
	-nThreads 10 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minMapQ 15 \
	-minQ 15 \
	-doCounts 1 \
	-minInd 32 \
	-setminDepth 66 \
	-setmaxDepth 266 \
	-doGlf 2 \
	-GL 1 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-minMaf 0.05 \
	-SNP_pval 1e-10 \
	-doDepth 1 \
	-dumpCounts 3 \
	-only_proper_pairs 1