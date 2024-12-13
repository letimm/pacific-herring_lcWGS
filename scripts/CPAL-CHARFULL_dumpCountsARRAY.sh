#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=dC
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_dumpCounts_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=12-16%5

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd

BASEDIR=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/dumpCounts

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL_dumpCountsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
        job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
        pop_id=$(echo ${sample_line} | awk -F ":" '{print $2}')
        bamslist_file=$(echo ${sample_line} | awk -F ":" '{print $3}')
        minDP=$(echo ${sample_line} | awk -F ":" '{print $4}')
        maxDP=$(echo ${sample_line} | awk -F ":" '{print $5}')
        if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
                break
        fi
done

angsd \
	-b ${bamslist_file} \
	-sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites \
	-ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-out ${BASEDIR}/CPAL-CHARFULL_${pop_id}_wgph \
	-nThreads 24 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minQ 15 \
	-minMapQ 15 \
	-doGlf 2 \
	-GL 1 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-only_proper_pairs 1 \
	-doCounts 1 \
	-minMaf 0.05 \
	-setminDepth ${minDP} \
	-setmaxDepth ${maxDP} \
	-doDepth 1 \
	-dumpCounts 3
