#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=fqc_array_CPAL-CHAR
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR-trim_fastqc_%A-%a.out
#SBATCH --array=1-80%24

module purge

PATH=$PATH:/home/letimm/software/FastQC

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii/scripts/CPAL-CHAR-trim_fastqcARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

fastqc ${fq} -o /center1/GLASSLAB/letimm/Clupea_pallasii/fastqc/trimmed/