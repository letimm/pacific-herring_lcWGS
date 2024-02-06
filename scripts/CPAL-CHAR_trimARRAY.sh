#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=trim
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_trimming_%A-%a.out
#SBATCH --array=1-40%48

ulimit -s unlimited
ulimit -l unlimited

module purge
module load Java/11.0.16

PATH=$PATH:/home/letimm/software/
JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii/scripts/CPAL-CHAR_trimARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq_r1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	fq_r2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

sample_id=$(echo $fq_r1 | sed 's!^.*/!!')
sample_id=${sample_id%%_*}

java -jar /home/letimm/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 -phred33 ${fq_r1} ${fq_r2} /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R1_paired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R1_unpaired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R2_paired.fq.gz /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:/home/letimm/bin/TruSeq3-PE-2.fa:2:30:10:1:true MINLEN:40
fastp --trim_poly_g -L -A --cut_right -i /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R1_paired.fq.gz -o /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_clipped_R1_paired.fq.gz -I /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_R2_paired.fq.gz -O /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_clipped_R2_paired.fq.gz -h /center1/GLASSLAB/letimm/Clupea_pallasii/trimmed/${sample_id}_trimmed_clipped_paired_report.html