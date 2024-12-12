#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=plog
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasiiFULL/job_outfiles/CPAL-CHARFULL_paralogs_%A.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu

ulimit -s unlimited
ulimit -l unlimited

module purge
module load GCCcore/11.3.0 bzip2/1.0.8 Python/3.10.4

PATH=$PATH:/home/letimm/software/ngsParalog
PATH=$PATH:/home/letimm/software/angsd

samtools mpileup \
	-b /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/CPAL-CHARFULL_bamslist.txt \
	-l /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/gls/CPAL-CHARFULL_wholegenome_polymorphic.sites \
	-q 0 \
	-Q 0 \
	--ff UNMAP,DUP | \
	ngsParalog calcLR \
	-infile - \
	-outfile /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic.lr \
	-minQ 5 \
	-minind 1 \
	-mincov 1 \
       -allow_overwrite 1

Rscript --vanilla /home/letimm/bin/ngsParalog_sigTest.R /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic.lr 0.05

angsd sites index /center1/GLASSLAB/letimm/Clupea_pallasiiFULL/paralogs/CPAL-CHARFULL_wholegenome_polymorphic_retain.sites
