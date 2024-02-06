#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=align
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_alignment_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-40%48

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 BWA/0.7.17 bzip2/1.0.8 Python/3.10.4 Java/11.0.16

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasii/scripts/CPAL-CHAR_alignARRAY_input.txt
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

bwa mem -M -t 10 /center1/GLASSLAB/letimm/Clupea_pallasii/bwa/GCF_900700415.2_Ch_v2.0.2_genomic ${fq_r1} ${fq_r2} 2> /center1/GLASSLAB/letimm/Clupea_pallasii/bwa/CPAL-CHAR_${sample_id}_bwa-mem.out > /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.sam

samtools view -bS -F 4 /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.sam > /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.bam
rm /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.sam

samtools view -h /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.bam | samtools view -buS - | samtools sort -o /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted.bam
rm /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.bam

java -jar /home/letimm/software//picard.jar MarkDuplicates I=/center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted.bam O=/center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup.bam M=/center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_dups.log VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true
rm /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted.bam

bam clipOverlap --in /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup.bam --out /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup_clipped.bam --stats
rm /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup.bam

samtools depth -aa /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup_clipped.bam | cut -f 3 | gzip > /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}.depth.gz

samtools index /center1/GLASSLAB/letimm/Clupea_pallasii/bamtools/CPAL-CHAR_${sample_id}_sorted_dedup_clipped.bam
