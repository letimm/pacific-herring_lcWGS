#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=pop_CPAL-CHARFULLeBSAInuc
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULLeBSAInuc_pop-analyses_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-26%24

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd:/home/letimm/software/angsd/misc

JOBS_FILE=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/scripts/CPAL-CHARFULL_angsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	chrom=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-CHARFULLeBSAInuc_A_bams.txt -r ${chrom}: -sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites -ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_A_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 -setminDepth 18 -setmaxDepth 90.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-CHARFULLeBSAInuc_B_bams.txt -r ${chrom}: -sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites -ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_B_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 -setminDepth 25 -setmaxDepth 125.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-CHARFULLeBSAInuc_C_bams.txt -r ${chrom}: -sites /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites -ref /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -anc /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna -out /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_C_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minQ 15 -minMapQ 15 -doCounts 1 -setminDepth 11 -setmaxDepth 55.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_A_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_B_polymorphic_folded.saf.idx -fold 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-B_polymorphic_folded.sfs
realSFS fst index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_A_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_B_polymorphic_folded.saf.idx -fold 1 -sfs /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-B_polymorphic_folded.sfs -fstout /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-B_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-B_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-B_polymorphic_folded.sfs.pbs.fst.txt

realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_A_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_C_polymorphic_folded.saf.idx -fold 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-C_polymorphic_folded.sfs
realSFS fst index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_A_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_C_polymorphic_folded.saf.idx -fold 1 -sfs /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-C_polymorphic_folded.sfs -fstout /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-C_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-C_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_A-C_polymorphic_folded.sfs.pbs.fst.txt

realSFS /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_B_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_C_polymorphic_folded.saf.idx -fold 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_B-C_polymorphic_folded.sfs
realSFS fst index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_B_polymorphic_folded.saf.idx -fold 1 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/diversity/CPAL-CHARFULLeBSAInuc_${chrom}_C_polymorphic_folded.saf.idx -fold 1 -sfs /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_B-C_polymorphic_folded.sfs -fstout /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_B-C_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_B-C_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/fst/CPAL-CHARFULLeBSAInuc_${chrom}_B-C_polymorphic_folded.sfs.pbs.fst.txt

