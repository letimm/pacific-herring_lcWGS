#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=CPAL-CHAR_wgp-admix
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_wholegenome_polymorphic_%A-%a.out
#SBATCH --array=1-4%4

module purge

PATH=$PATH:/home/letimm/software/NGSadmix

for k_val in {1..4}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${k_val} ]]; then
		break
	fi
done

NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasii/admixture/CPAL-CHAR_wholegenome-polymorphic_k${k_val}-0 -P 10 -minMaf 0
NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasii/admixture/CPAL-CHAR_wholegenome-polymorphic_k${k_val}-1 -P 10 -minMaf 0
NGSadmix -likes /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /center1/GLASSLAB/letimm/Clupea_pallasii/admixture/CPAL-CHAR_wholegenome-polymorphic_k${k_val}-2 -P 10 -minMaf 0
