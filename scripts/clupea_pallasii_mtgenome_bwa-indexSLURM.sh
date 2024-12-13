#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=bwa_index_clupea_pallasii_mtgenome
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/bwa-index_clupea_pallasii_mtgenome.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 BWA/0.7.17

bwa index -p /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/bwa/clupea_pallasii_mtgenome /center1/GLASSLAB/letimm/ref_genomes/clupea_pallasii_mtgenome.fna
