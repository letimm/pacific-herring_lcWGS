#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=admix
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_wgph_admix_%A-%a.out

#SBATCH --array=1-7%12

ulimit -s unlimited
ulimit -l unlimited

module purge

PATH=$PATH:/home/letimm/software/NGSadmix

for k_val in {1..7}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${k_val} ]]; then
		break
	fi
done

NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-CHARFULL_wgph.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/admixture/CPAL-CHARFULL_wgph_k${k_val}-0 -P 10 -minMaf 0
NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-CHARFULL_wgph.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/admixture/CPAL-CHARFULL_wgph_k${k_val}-1 -P 10 -minMaf 0
NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-CHARFULL_wgph.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/admixture/CPAL-CHARFULL_wgph_k${k_val}-2 -P 10 -minMaf 0
