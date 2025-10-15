#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=pca
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii120/job_outfiles/CPAL-CHARFULL-eBS-AC_chr7region_wgph_pca_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

pcangsd --threads 10 --beagle /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS-AC_chr7region.beagle.gz -o /center1/GLASSLAB/letimm/Clupea_pallasii120/pca/CPAL-CHARFULL-eBS-AC_chr7region_wgph --sites_save --pcadapt
