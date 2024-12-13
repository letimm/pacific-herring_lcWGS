#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=sfst2
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL3pops_pairwiseFST-pt2_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-3%3

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd/misc

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL3pops_pairwiseFST-pt2_ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	pop1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	pop2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}.saf.idx /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop2}.saf.idx -P 10 -maxIter 30 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}-${pop2}.ml
realSFS fst index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}.saf.idx /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop2}.saf.idx -sfs /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}-${pop2}.ml -fstout /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}-${pop2}
realSFS fst stats /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}-${pop2}.fst.idx > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL3pops_${pop1}-${pop2}.global.fst
