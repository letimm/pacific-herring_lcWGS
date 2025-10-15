#!/bin/bash

#SBATCH --partition=bio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --ntasks=24
#SBATCH --mem=214G
#SBATCH --job-name=CPAL-CHARFULL-eBS_concat-beagles
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=letimm@alaska.edu
#SBATCH --output=/center1/GLASSLAB/letimm/Clupea_pallasii120/job_outfiles/CPAL-CHARFULL-eBS_concatenate-wgph-beagles_%A.out

ulimit -s unlimited
ulimit -l unlimited

module purge

zcat /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045152.1_polymorphic-filtered.beagle.gz | head -n 1 > /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_wgph.beagle

for i in /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045152.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045153.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045154.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045155.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045156.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045157.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045158.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045159.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045160.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045161.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045162.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045163.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045164.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045165.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045166.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045167.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045168.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045169.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045170.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045171.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045172.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045173.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045174.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045175.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045176.1_polymorphic-filtered.beagle.gz /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_NC-045177.1_polymorphic-filtered.beagle.gz
do zcat $i | tail -n +2 -q >> /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_wgph.beagle
done

gzip /center1/GLASSLAB/letimm/Clupea_pallasii120/gls/CPAL-CHARFULL-eBS_wgph.beagle
