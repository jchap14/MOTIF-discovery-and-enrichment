################### HOMER (findMotifs.pl): Find MOTIFs in promoters with gene list input
### Prefers refseq IDs if possible, but can convert SYMBOLs
## http://homer.salk.edu/homer/motif/

#!/bin/bash
# find *.genes | xargs -n1 bash HOMER_motifs_from_genelist.sh #local, analyze all

name=`basename $1 .genes`
findMotifs.pl $1 human $name.HOMERmotif_500  -start -50  -end 50 -p 4 -dumpFasta
#findMotifs.pl $1 human $name.HOMERmotif_2500 -start -2000 -end 500 -p 4 -dumpFasta
rm motifFindingParameters.txt
