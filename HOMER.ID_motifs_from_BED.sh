#!/bin/bash
##### GOAL: use HOMER (findMotifs.pl) to ID TF motifs using genome coords (BED file)
##### Note: Do this on SCG cluster (takes forever locally & uses hi memory)
## help @ http://homer.salk.edu/homer/motif/

# for x in `/bin/ls *.bed` ; do bash HOMER.ID_motifs_from_BED.sh $x; done

## add modules:
# module add homer/4.7 #not needed, in conda environment

## Variables:
NAME=`basename $1 .bed`

cat > $NAME.tempscript.sh << EOF
#!/bin/bash -l
#SBATCH --job-name $NAME.motifsFromBed
#SBATCH --output=$NAME.motifsFromBed.out
#SBATCH --mail-user jchap14@stanford.edu
#SBATCH --mail-type=ALL
# Request run time & memory
#SBATCH --time=5:00:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --account=mpsnyder

##### Run commands:
## add -dumpFasta to get FASTA output also
findMotifsGenome.pl $1 hg19 $NAME.HOMER_motifs -size given -p 12 -preparsedDir ./preparsedDir/
EOF

## qsub then remove the tempscript
sbatch $NAME.tempscript.sh #scg
sleep 1
rm $NAME.tempscript.sh

