#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=eBS-pca
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL-eBS_wgph_pca_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

pcangsd --threads 10 --beagle /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-CHARFULL_wgph.beagle.gz -o /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/pca/CPAL-CHARFULL-eBS_wgph --sites_save --pcadapt --filter /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/eBS_PCA.txt
