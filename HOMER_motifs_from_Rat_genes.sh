################### HOMER (findMotifs.pl): Find MOTIFs in promoters with gene list input
### Prefers refseq IDs if possible, but can convert SYMBOLs
## http://homer.salk.edu/homer/motif/

#!/bin/bash
# module add perl-scg; module add MEME; module add homer; module add weblogo
# find *.genes | xargs -n1 qsub -V -cwd -l h_vmem=4G -pe shm 1 ./HOMER.sh #cluster
# find *.genes | xargs -n1 bash HOMER_motifs_from_Rat_genes.sh #local, analyze all

name=`basename $1 .genes`
#findMotifs.pl <inputfile.txt> <promoter set> <output directory> [options]
findMotifs.pl $1 rat $name.HOMERmotif_500  -start -400  -end 100 -p 4 -dumpFasta
findMotifs.pl $1 rat $name.HOMERmotif_2500 -start -2000 -end 500 -p 4 -dumpFasta
rm motifFindingParameters.txt
