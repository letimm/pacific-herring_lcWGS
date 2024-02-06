#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=CPAL-CHAR-GOA_wgp-pca
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR-GOA_pca-wg_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

pcangsd --threads 10 --beagle /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR-GOA_wholegenome_polymorphic.beagle.gz -o /center1/GLASSLAB/letimm/Clupea_pallasii/pca/CPAL-CHAR-GOA_wholegenome-polymorphic --sites_save --pcadapt

