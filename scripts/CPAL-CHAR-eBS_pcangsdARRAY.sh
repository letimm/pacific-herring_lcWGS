#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=pca_CPAL-CHAR-eBS
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR-eBS_pca-bychrom_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-26%8

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii/scripts/CPAL-CHAR-eBS_pcangsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	beagle_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

chrom=$(echo $beagle_file | sed 's!^.*/!!')
chrom=${chrom%.beagle.gz}

pcangsd --threads 10 --beagle ${beagle_file} -o /center1/GLASSLAB/letimm/Clupea_pallasii/pca/${chrom} --sites_save --pcadapt --filter /center1/GLASSLAB/letimm/Clupea_pallasii/eBS_keep18.txt
