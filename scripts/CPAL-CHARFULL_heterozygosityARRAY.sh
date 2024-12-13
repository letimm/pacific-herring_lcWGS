#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=align
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_heterozygosity_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-120%20

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 bzip2/1.0.8

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/done/CPAL-CHARFULL_statsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	alignment=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

sample_id=$(echo $alignment | sed 's!^.*/!!')

#individual saf
angsd \
	-i ${alignment} \
	-sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites \
	-anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/heterozygosity/${sample_id} \
	-dosaf 1 \
	-gl 1

#individual het
realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/heterozygosity/${sample_id}.saf.idx -fold 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/heterozygosity/${sample_id}.ml
