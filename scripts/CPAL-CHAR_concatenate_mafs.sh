#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=CPAL-CHAR_concat-mafs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii/job_outfiles/CPAL-CHAR_concatenate-mafs_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge
module load bzip2/1.0.8 GCCcore/11.3.0

PATH=$PATH:/home/letimm/software/angsd

for i in /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045152.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045153.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045154.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045155.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045156.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045157.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045158.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045159.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045160.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045161.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045162.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045163.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045164.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045165.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045166.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045167.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045168.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045169.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045170.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045171.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045172.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045173.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045174.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045175.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045176.1_polymorphic.mafs.gz /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_NC-045177.1_polymorphic.mafs.gz
do zcat $i | tail -n +2 -q >> /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.mafs; done
cut -f 1,2,3,4 /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.mafs > /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.sites
gzip /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.mafs

angsd sites index /center1/GLASSLAB/letimm/Clupea_pallasii/gls/CPAL-CHAR_wholegenome_polymorphic.sites