#!/bin/bash

################### HOMER (findMotifs.pl): Find MOTIFs in promoters with gene list input
### Prefers refseq IDs if possible, but can convert SYMBOLs
## http://homer.salk.edu/homer/motif/

## run on SCG
## find *.genes | xargs -n1 bash HOMER_motifs_from_genelist.sh

## modules: homer & weblogo are loaded in conda environment

## Variables:
NAME=`basename $1 .genes`

cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.motifsFromBed
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

##### Run commands:
## add -dumpFasta to get FASTA output also
findMotifs.pl $1 human $NAME.HOMERmotif_500  -start -50  -end 50 -p 4 -dumpFasta
#findMotifs.pl $1 human $name.HOMERmotif_2500 -start -2000 -end 500 -p 4 -dumpFasta
rm motifFindingParameters.txt

EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh

