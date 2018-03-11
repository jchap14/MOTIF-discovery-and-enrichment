#!/bin/bash
##### Use this script to Find Instances of Specific Motifs from a GENEFILE! (not BEDFILE)
##### help at http://homer.ucsd.edu/homer/microarray/index.html

##### submission command
## for i in `cat $LIST_of_INTERESTING_MOTIFs`; do bash HOMER.findSpecificMotifTargetsGENEFILE.sh $i; done

##### set variables
## whether to search denovo "./homerResults/" or known "./knownResults/"
searchDir="./homerResults/"
## list of interesting motifs to search for
LIST_of_INTERESTING_MOTIFs="LIST_of_INTERESTING_MOTIFs.txt"
## list of genes to search for motifs in
GENEFILE="../Rev_vs_Irr.DEGs.FDR0.1.FC2.Irr.genes"
NAME=`basename $GENEFILE .genes`
MOTIF=$1
## find the motif file which matches the motif of interest
MOTIF_FILE=`head -2 $searchDir/*.motif | egrep $MOTIF -B 1 | head -1 | rev | cut -f1 -d '/'| rev | cut -f1 -d ' '`
MOTIF_LOCATION=`echo $searchDir/$MOTIF_FILE`

##### create a tempscript for queue sub
cat > $NAME.$MOTIF.tempscript.sh << EOF
#!/bin/bash

## run the findMotifs command
findMotifs.pl $GENEFILE rat . -find $MOTIF_LOCATION > $NAME.$MOTIF.target_genes
rm motifFindingParameters.txt
EOF

## qsub then remove the tempscript
bash $NAME.$MOTIF.tempscript.sh 
sleep 1
#rm $NAME.$MOTIF.tempscript.sh 
