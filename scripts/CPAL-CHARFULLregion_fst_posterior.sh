#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=fst-sig
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULLregion_fst-sigtest_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --array=1-50%10

ulimit -s unlimited
ulimit -l unlimited

module purge
for iteration in {1..50}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${iteration} ]]; then
		break
	fi
done

/home/letimm/bin/generate-fst-posterior_chinook.py --full_bamslist /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-CHARFULL_filtered_bamslist.txt --sites_file /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites --population_details KodiakOutsideKiliuda:10,KodiakInsideUganik:10,PopofIsland:20,ConstantineBay:20,PortMoller:20,eBS:20,GOA:20 --population_pairs ConstantineBay-GOA,ConstantineBay-KodiakInsideUganik,ConstantineBay-KodiakOutsideKiliuda,ConstantineBay-PopofIsland,ConstantineBay-PortMoller,ConstantineBay-eBS,GOA-KodiakInsideUganik,GOA-KodiakOutsideKiliuda,GOA-PopofIsland,GOA-PortMoller,GOA-eBS,KodiakInsideUganik-KodiakOutsideKiliuda,KodiakInsideUganik-PopofIsland,KodiakInsideUganik-PortMoller,KodiakInsideUganik-eBS,KodiakOutsideKiliuda-PopofIsland,KodiakOutsideKiliuda-PortMoller,KodiakOutsideKiliuda-eBS,PopofIsland-PortMoller,PopofIsland-eBS,PortMoller-eBS --reference_genome /center1/GLASSLAB/letimm/ref_genomes/GCF_900700415.2_Ch_v2.0.2_genomic.fna --email letimm@alaska.edu --iteration ${iteration} --software_dir /home/letimm/software/ --group_id region
