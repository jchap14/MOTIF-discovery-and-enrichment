##########################################################################################
##### Find Instances of Specific Motifs <- search on http://homer.salk.edu/homer/ngs/peakMotifs.html
##########################################################################################

##### Notes: 
# This requires a BED file of coordinates (e.g. Peaks or promoter coords)
# Comment out the appropriate section to specify "/homerResults/" or "/knownResults/"
# should be in that folder as working directory'

##### submit w looping
## interactively set to a space separated string
# STRING_of_INTERESTING_MOTIFs="KLF3 Fra1"
# for i in `echo $STRING_of_INTERESTING_MOTIFs | tr ' ' '\n'`
# do bash HOMER.findSpecificMotifTargetsBEDFILE.sh $i; done

## Define variables
MOTIF=$1
BEDFILE="../LS_siKLF2_4_vs_LS_siCon.minO3.DARs.FDR10.sorted.bed"
NAME=`basename $BEDFILE .bed`
RESULTTYPE="homerResults" #knownResults #homerResults

## find the motif file
MOTIF_FILE=`head -2 ./$RESULTTYPE/*.motif \
| egrep $MOTIF -B 1 | head -1 | rev | cut -f1 -d '/'| rev | cut -f1 -d ' '`

## homer command
findMotifsGenome.pl $BEDFILE hg19 . \
-find ./$RESULTTYPE/$MOTIF_FILE \
> $NAME.$MOTIF.target_genes

## cleanup
rm motifFindingParameters.txt
