##### Find Motifs by extracting FASTA sequences using homerTools -> MEME analysis

######## homerTools: Extract Seq From FASTA Files (specify regions) on cluster ###########

nano homerTools-extract.sh
#!/bin/bash
name=`basename $1 .bed`
homerTools extract $1 /home/jchap14/hi_quota_folder/Annotations/GENCODE-v19-GRCh37-hg19/GRCh37.p13.genome.fa \
-fa > $name.fa 

# RUN COMMANDS
module add homer
mac2unix *
for x in `/bin/ls *.bed` ; do bash ./homerTools-extract.sh $x; done


########################### MEME to find Motifs #######################################
#run this locally because the cluster version is fucked

nano MEME.sh
#!/bin/bash
name=`basename $1 .fa`
# Usage: meme-chip [options] [-db <motif database>]+ <sequences>
/usr/local/Cellar/meme/4.10.1/bin/meme-chip -oc ./$name -db ./HOCOMOCOv9_AD_MEME.txt -filter-thresh 0.05 $1

# RUN COMMANDS
mac2unix *
for x in `/bin/ls *.fa` ; do bash ./MEME.sh $x; done

## Trial
# /usr/local/Cellar/meme/4.10.1/bin/meme-chip -oc ./Responder_up -db ./HOCOMOCOv9_AD_MEME.txt Responder_up.fasta

#########################################################################################
################### MEME-ChIP : several motif finding algorithms in 1 package

### can get FASTA by making custom track from bed on UCSC table browser
### or can get FASTA from -dumpFasta output of HOMER
# feed the fasta files to MEME:

for i in *.fa; do
  mkdir ${i/.fa/}_MEME_CHIP
  meme-chip -oc ${i/.fa/}_MEME_CHIP -db /Users/jchap12/meme/db/motif_databases/HUMAN/HOCOMOCOv10_HUMAN_mono_meme_format.meme $i
done

##########################################################################################
################# TESTING: HOMER+MEME-CHIP 200 bp window around peak centers
##### find motifs within 200bp of ATAC summits (peak center) (bed file as input)
#! /usr/bin/env bash
for i in *.summit.bed
do
findMotifsGenome.pl $i hg19 ${i}_HOMER_200bp -size 200 -p 4 -dumpFasta
mkdir ${i}_MEME_CHIP
meme-chip -oc ${i}_MEME_CHIP -db /Users/jchap12/meme/db/motif_databases/HUMAN/HOCOMOCOv10_HUMAN_mono_meme_format.meme ./${i}_HOMER_200bp/target.fa
done