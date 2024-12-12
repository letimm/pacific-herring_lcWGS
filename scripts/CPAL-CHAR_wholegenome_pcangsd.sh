#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=CPAL-CHAR_wgp-pca
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_wholegenome_polymorphic_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 Python/3.10.4

pcangsd --threads 10 --beagle /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.beagle.gz -o /center1/GLASSLAB/letimm/Clupea_pallasii/pca/CPAL-CHAR_wholegenome-polymorphic --sites_save --pcadapt
