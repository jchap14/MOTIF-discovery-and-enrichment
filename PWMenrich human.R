##### Import/load necessary libraries
# source("http://bioconductor.org/biocLite.R")
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/my.colorFct.R")
zzz<-c("pheatmap","grid","gplots","ggplot2","export","devtools","DESeq2","pasilla","Biobase",
       "EBSeq","dplyr","data.table", "genefilter","FactoMineR","VennDiagram","DOSE","ReactomePA",
       "org.Hs.eg.db","clusterProfiler","pathview","DiffBind","dendextend","limma","ReportingTools",
       "TxDb.Hsapiens.UCSC.hg19.knownGene","GO.db","ChIPseeker","GenomicRanges","PWMEnrich","Biostrings",
       "PWMEnrich.Hsapiens.background","BSgenome.Hsapiens.UCSC.hg19")
lapply(zzz, require, character.only= T)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

##### load the pre-compiled lognormal background for hg19
data(PWMLogn.hg19.MotifDb.Hsap)
registerCoresPWMEnrich(4) #use 4 parallel cores when possible

##########################################################################################
##### Find enriched motifs in multiple sequences (FASTA format)
sequences <- readDNAStringSet(
  file="DARs.LSS_vs_ST.LSS_enriched.fa")
res <- motifEnrichment(sequences, PWMLogn.hg19.MotifDb.Hsap) ## calculate motif enrichments
report <- groupReport(res) 
report                                          ## view report
plot(report[1:10], fontsize=7, id.fontsize=5)   ## plot report
graph2ppt(file="PWM_human.pptx", width=10, height=7, append=T)
report.top <- groupReport(res, by.top.motifs=T)
report.top
report.df <- as.data.frame(report)
report.top.df <- as.data.frame(report.top)

##########################################################################################
##### Plot the interesting TFs on the sequences
ids      <- c("PRNP", "TP73", "CYB5R1")
sel.pwms <- PWMLogn.hg19.MotifDb.Hsap$pwms[ids]
names(sel.pwms) <- c("PRNP", "TP73", "CYB5R1")
## scan & get the raw scores
scores <- motifScores(sequences, sel.pwms, raw.scores=T)
## plot
plotMotifScores(scores, cols=c("green", "red", "blue"))
graph2ppt(file="PWM_human.pptx", width=10, height=7, append=T)

##########################################################################################
#####  Plot the individual motif hits with a specified pValue cutoff
## empirical distribution for the PRNP motif
PRNP.ecdf <- motifEcdf(sel.pwms$PRNP, Hsapiens, quick=T)[[1]]
## find the score that is equivalent to the P-value of 1e-3
threshold.1e3 <- log2(quantile(PRNP.ecdf, 1 - 1e-3))
threshold.1e3
## replot only the PRNP motif hits with the P-value cutoff of 1e-3 (0.001)
plotMotifScores(scores, cols="green", sel.motifs="PRNP", cutoff=threshold.1e3)

##########################################################################################
##### Find enriched motifs in a single sequence
# load the stripe2 sequences from a FASTA file for motif enrichment
sequence <- readDNAStringSet(system.file(package="PWMEnrich", dir="extdata", file="stripe2.fa"))
# perform motif enrichment!
res <- motifEnrichment(sequence, PWMLogn.hg19.MotifDb.Hsap)
## Calculating motif enrichment scores ...
report <- sequenceReport(res, 1)
report
# plot the motif with P-value < 0.05
plot(report[report$p.value < 0.0001], fontsize=7, id.fontsize=6)
