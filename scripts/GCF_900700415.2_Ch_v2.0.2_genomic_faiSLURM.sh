#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=fai_GCF_900700415.2_Ch_v2.0.2_genomic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/fai_GCF_900700415.2_Ch_v2.0.2_genomic.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8

samtools faidx /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna
