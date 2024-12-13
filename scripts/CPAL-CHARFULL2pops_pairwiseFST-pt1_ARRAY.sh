#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=sfst1
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL2pops_pairwiseFST-pt1_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-2%2

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL2pops_pairwiseFST-pt1_ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	population=$(echo ${sample_line} | awk -F ":" '{print $2}')
	bamfile=$(echo ${sample_line} | awk -F ":" '{print $3}')
	n=$(echo ${sample_line} | awk -F ":" '{print $4}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b ${bamfile} -ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL2pops_${population} -sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites -nThreads 20 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth ${n} -setmaxDepth $((n * 5)) -GL 1 -doGlf 1 -doMaf 1 -minMaf 0.05 -SNP_pval 1e-10 -doMajorMinor 1 -dumpCounts 3 -doDepth 1 -doSaf 1 -only_proper_pairs 1

realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL2pops_${population}.saf.idx > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULL2pops_${population}.sfs