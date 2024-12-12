#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=depth
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_depths_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-80%40

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL_depthsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	depth_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

touch /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/bamtools/CPAL-CHARFULL_depths.csv
mean_cov_ind_vCHINOOK.py -i ${depth_file} -o /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/bamtools/CPAL-CHARFULL_depths.csv
