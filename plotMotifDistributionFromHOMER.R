##### Source & load libraries ####
# source("http://bioconductor.org/biocLite.R")
# biocLite(c("DESeq2","pasilla","DESeq","pathview"))
# install.packages(c("rJava","ReporteRs","ReporteRsjars","ggplot2","rtable","xtable","VennDiagram"))
# install.packages(c("taRifx","devtools","dplyr","data.table"))
# devtools::install_github('tomwenseleers/export',local=F)
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/my.colorFct.R") 
zzz<-c("pheatmap","grid","gplots","ggplot2","export","devtools","DESeq2","pasilla","Biobase","EBSeq","dplyr","data.table",
       "genefilter","FactoMineR","VennDiagram","DOSE","ReactomePA","org.Hs.eg.db","clusterProfiler","pathview")
lapply(zzz, require, character.only=T)
data(geneList)

##### Motif ####
Motif <- "Pax2"

##### Read in the motif histogram results ####
hist_numbers <- read.delim(paste(Motif,".targetsHistogram.txt",sep=''), quote="\"", header=T)
hist_numbers <- read.delim("Pax2.targetsHistBin100.txt", quote="\"", header=T)
colnames(hist_numbers) <- c("distToTSS","totalSites","sites+","sites-","Afreq","Cfreq","Gfreq","Tfreq")

## count the # of DMCs in distance bins & make a df
# ## set the bins as a factor, so that ggplot won't plot genenames alphabetically
# bin_numbers$bins <- factor(bin_numbers$bins, levels = bin_numbers$bins)
## plot the distance to nearest TSS for count
ggplot() + geom_bar(data= hist_numbers, aes(y= totalSites, x= distToTSS), stat="identity",
                    position="dodge") + ggtitle("Motif Distribution near target TSS") +
  theme(plot.title= element_text(size= 14, face= "bold"),
        axis.text= element_text(size= 14), legend.text= element_text(size= 14),
        legend.title= element_text(size= 14), axis.title= element_text(size= 14))
## export
graph2ppt(file=paste(title,".distribution.ppt",sep=''), width=5, height=5, append=T)
