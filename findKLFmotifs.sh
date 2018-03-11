##########################################################################################
##### Find KLF Motifs from BED of peaks (CUT&RUN, ATAC, ChIP) or promoters
##########################################################################################

##### submit w looping over multiple peak sets
## for x in `find *KLF*.Peaks.bed` ; do bash findKLFmotifs.sh $x; done

## Define variables
BEDFILE=$1
NAME=`basename $BEDFILE .bed`

## specify the motif file created to contain KLF2,KLF4,KLF10
MOTIF_FILE="./KLF.motif"

## homer command
findMotifsGenome.pl $BEDFILE hg19 . -find $MOTIF_FILE > $NAME.KLF.target_genes

## label output
TOTALMOTIFS=`cat $NAME.KLF.target_genes | cut -f1 | wc -l`
TOTALPEAKS=`cat $NAME.KLF.target_genes | cut -f1 | sort | uniq | wc -l`
LABEL=`echo $TOTALMOTIFS.$TOTALPEAKS | tr -d ' '`

mv $NAME.KLF.target_genes $NAME.$LABEL.KLF.target_genes
## cleanup
rm motifFindingParameters.txt
