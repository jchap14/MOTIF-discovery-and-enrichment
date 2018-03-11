#!/bin/bash
##### GOAL: use HOMER (findMotifs.pl) to ID TF motifs using genome coords (BED file)
##### Note: Do this on SCG cluster (takes forever locally & uses hi memory)
## help @ http://homer.salk.edu/homer/motif/

# for x in `/bin/ls *.bed` ; do bash HOMER.ID_motifs_from_BED.sh $x; done

## add modules
## Modules:
module add homer/4.7
module add weblogo/2.8.2

## Variables:
NAME=`basename $1 .bed`

cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.motifsFromBed
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=11:59:00
#$ -l s_rt=11:59:00

##### Run commands:
## add -dumpFasta to get FASTA output also
findMotifsGenome.pl $1 hg19 $NAME.HOMER_motifs -size given -p 12 -preparsedDir ./preparsedDir/
EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh

