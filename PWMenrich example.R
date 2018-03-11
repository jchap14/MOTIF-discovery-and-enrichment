source("http://bioconductor.org/biocLite.R")
biocLite("BSgenome.Dmelanogaster.UCSC.dm3")
library("PWMEnrich")
library("PWMEnrich.Dmelanogaster.background")
library("PWMEnrich.Hsapiens.background")
registerCoresPWMEnrich(4) #use 4 parallel cores when possible

##### Example 1:Finding enrichment motifs in a single sequence
# load the pre-compiled lognormal background
data(PWMLogn.dm3.MotifDb.Dmel)
# load the stripe2 sequences from a FASTA file for motif enrichment
sequence = readDNAStringSet(system.file(package="PWMEnrich", dir="extdata", file="stripe2.fa"))
sequence
# perform motif enrichment!
res = motifEnrichment(sequence, PWMLogn.dm3.MotifDb.Dmel)
## Calculating motif enrichment scores ...
report = sequenceReport(res, 1)
report
# plot the motif with P-value < 0.05
plot(report[report$p.value < 0.05], fontsize=7, id.fontsize=6)

##### Example 2: Examining the binding sites
# extract the 3 PWMs for the TFs we are interested in
ids = c("bcd_FlyReg_FBgn0000166",
        "gt_FlyReg_FBgn0001150",
        "Kr")
sel.pwms = PWMLogn.dm3.MotifDb.Dmel$pwms[ids]
names(sel.pwms) = c("bcd", "gt", "Kr")
# scan and get the raw scores
scores = motifScores(sequence, sel.pwms, raw.scores=TRUE)
# raw scores for the first (and only) input sequence
dim(scores[[1]])
## [1] 968 3
head(scores[[1]])
# score starting at position 1 of forward strand
scores[[1]][1, "bcd"]
# score for the reverse complement of the motif, starting at the same position
scores[[1]][485, "bcd"]
# plot
plotMotifScores(scores, cols=c("green", "red", "blue"))

#####  P-value for individual motif hits
library(BSgenome.Dmelanogaster.UCSC.dm3)
library(BSgenome.Hsapiens.UCSC.hg19)
# empirical distribution for the bcd motif
bcd.ecdf = motifEcdf(sel.pwms$bcd, Dmelanogaster, quick=TRUE)[[1]]
# find the score that is equivalent to the P-value of 1e-3
threshold.1e3 = log2(quantile(bcd.ecdf, 1 - 1e-3))
threshold.1e3
# replot only the bcd motif hits with the P-value cutoff of 1e-3 (0.001)
plotMotifScores(scores, cols="green", sel.motifs="bcd", cutoff=threshold.1e3)
# Convert scores into P-values
pvals = 1 - bcd.ecdf(scores[[1]][,"bcd"])
head(pvals)

##### Example 3: Finding enriched motifs in multiple sequences
sequences = readDNAStringSet(system.file(package="PWMEnrich",
                                         dir="extdata", file="tinman-early-top20.fa"))
res = motifEnrichment(sequences, PWMLogn.dm3.MotifDb.Dmel)
report = groupReport(res)
report
plot(report[1:10], fontsize=7, id.fontsize=5)
report.top = groupReport(res, by.top.motifs=TRUE)
report.top
