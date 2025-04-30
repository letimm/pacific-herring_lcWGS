#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=bwa_index_GCF_900700415.2_Ch_v2.0.2_genomic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/bwa-index_GCF_900700415.2_Ch_v2.0.2_genomic.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 BWA/0.7.17

bwa index -p /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/bwa/GCF_900700415.2_Ch_v2.0.2_genomic /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna
