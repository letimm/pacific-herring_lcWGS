#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=div
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_diversity_%A-%a.out
#SBATCH --array=1-4%4

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

BASEDIR=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL_diversityARRAY_input.txt
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
	-ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna \
	-sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites \
	-out ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded \
	-nThreads 24 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minMapQ 15 \
	-doCounts 1 \
	-setminDepth ${minDP} \
	-setmaxDepth ${maxDP} \
	-GL 1 \
	-doGlf 3 \
	-doMaf 1 \
	-minMaf 0.05 \
	-doMajorMinor 1 \
	-doSaf 1 \
	-only_proper_pairs 1

### Calculate site frequency spectra to get diversity and selection values (theta, Watterson, Tajima's D) for each population. ###
realSFS ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.saf.idx \
	-fold 1 \
	-P 24 > ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.saf.sfs

realSFS saf2theta \
	${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.saf.idx \
	-fold 1 \
	-sfs ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.saf.sfs \
	-outname ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded

thetaStat do_stat \
	${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.thetas.idx

thetaStat print \
	${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.thetas.idx.pestPG > ${BASEDIR}/CPAL-CHARFULL${pop_id}_wgph_folded.thetas.txt
