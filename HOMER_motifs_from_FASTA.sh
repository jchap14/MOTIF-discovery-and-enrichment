################### HOMER (findMotifs.pl): Find MOTIFs in promoters with gene list input
### Prefers refseq IDs if possible, but can convert SYMBOLs
## http://homer.salk.edu/homer/motif/

#!/bin/bash
# module add perl-scg; module add MEME; module add homer; module add weblogo
# find *.DEGs | xargs -n1 qsub -V -cwd -l h_vmem=4G -pe shm 1 ./HOMER.sh #cluster
# find *.DEGs | xargs -n1 bash ./HOMER_motifs_from_genelist.sh #local, analyze all

name=`basename $1 .DEGs`
findMotifs.pl $1 human $name.HOMERmotif_500 -start -400 -end 100 -p 4 -dumpFasta