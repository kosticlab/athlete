library(ggplot2)
library(cowplot)
library(grid)
library(gridExtra)
library(tidyr)
library(ComplexHeatmap)
args = commandArgs(trailingOnly=TRUE)


t_abundances <- read.csv(args[1],header=TRUE,row.names=1)
s_abundances <- read.csv(args[2],header=TRUE,row.names=1)

test <- t_abundances[t_abundances$Exercise_state %in% c("Before","After"),]
test2 <- s_abundances[s_abundances$Exercise_state %in% c("Before","After"),]
setwd("/Users/jacobluber/Desktop/athlete_metadata")

plot_both <- function(gene){
gene <- "PBAAKNOD_01129"
transcript_range <- range(s_abundances[,gene]) 
check <- abs(transcript_range[1] - transcript_range[2])
print(check)
if(check > .01){
outf <- paste(gene, "png", sep=".")
p <- ggplot(data=test, aes_string(x="Exercise_state",y=gene,color="Athlete_gradient",shape="SampleCode",group="SampleCode")) + geom_point()  + scale_x_discrete(limits=c("Before","After"))+
  geom_smooth(method="lm") + scale_shape_manual(values = 0:30) + labs(title = "Genomics") + theme(axis.text.x=element_blank()) + theme_void()
g <- ggplot(data=test2, aes_string(x="Exercise_state",y=gene,color="Athlete_gradient",shape="SampleCode",group="SampleCode")) + geom_point() + scale_x_discrete(limits=c("Before","After"))+
  geom_smooth(method="lm") + scale_shape_manual(values = 0:30) + labs(title = "Transcriptomics") + theme(axis.text.x=element_blank()) + theme_void()#+ theme(legend.position="none")+ theme_void() 
maxp <- max(t_abundances[,gene])
maxg <- max(s_abundances[,gene])
p <- p + coord_cartesian(ylim = c(0,maxp))
g <- g + coord_cartesian(ylim = c(0,maxg))
setwd("/Users/jacobluber/Desktop/athlete_metadata")
png(paste(gene, "png", sep="."))
grid.arrange(p,g,ncol=2)
dev.off()
}
}

#lapply(intersect(colnames(test),colnames(test2))[-1],function(x) plot_both(x))

#gb <- t(na.omit(t_abundances[t_abundances$Exercise_state == "Before",]))
#ga <- t(na.omit(t_abundances[t_abundances$Exercise_state == "After",]))
#ht1 = Heatmap(as.matrix(gb[2:2400]), name = "ht1", row_title = "Genes", column_title = "Before Samples", show_row_names = FALSE, show_column_names = FALSE)
#ht2 = Heatmap(as.matrix(ga[2:2400]), name = "ht2", row_title = "Genes", column_title = "Heat Samples",  show_row_names = FALSE, show_column_names = FALSE)
split_heatmap_t <- function(transcriptomics){
tb <- transcriptomics[transcriptomics$Exercise_state == "Before",]
ta <- transcriptomics[transcriptomics$Exercise_state == "After",] 
tbe <- tb[tb$Athlete_gradient == "Elite",]
tbn <- tb[tb$Athlete_gradient == "Everyday",]
tae <- ta[ta$Athlete_gradient == "Elite",]
tan <- ta[ta$Athlete_gradient == "Everyday",]
tbe <- tbe[apply(tbe,1,function(x)any(!is.na(x))),]
tbn <- tbn[apply(tbn,1,function(x)any(!is.na(x))),]
tae <- tae[apply(tae,1,function(x)any(!is.na(x))),]
tan <- tan[apply(tan,1,function(x)any(!is.na(x))),]
idx <- which(colnames(tbn)=="BarcodeSequence") - 1
ht2 <- Heatmap(t(tbn[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="Before Everyday", row_title="Genes",column_title="Elite Before")
ht4 <- Heatmap(t(tbe[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="Before Elite", row_title="Genes",column_title="Elite Before")
ht6 <- Heatmap(t(tan[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="After Everyday", row_title="Genes",column_title="Everyday After")
ht8 <- Heatmap(t(tae[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="After Elite", row_title="Genes",column_title="Elite After")
setwd("/Users/jacobluber/Desktop/athlete_metadata")
hm1<-add_heatmap(ht2,ht4)
hm2<-add_heatmap(hm1,ht6)
hm3<-add_heatmap(hm2,ht8)
png(paste(args[2],"_hmap.png",sep=""))
draw(hm3)
dev.off()
}

split_heatmap_g <- function(genomics){
  #genomics <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/subset_gcat_Methylmalonyl-CoA_ramatrix_mgx",header=TRUE,row.names=1)
  gb <- genomics[genomics$Exercise_state == "Before",]
  ga <- genomics[genomics$Exercise_state == "After",]
  gbe <- gb[gb$Athlete_gradient == "Elite",]
  gbn <- gb[gb$Athlete_gradient == "Everyday",]
  gae <- ga[ga$Athlete_gradient == "Elite",]
  gan <- ga[ga$Athlete_gradient == "Everyday",]
  gbe <- gbe[apply(gbe,1,function(x)any(!is.na(x))),]
  gbn <- gbn[apply(gbn,1,function(x)any(!is.na(x))),]
  gae <- gae[apply(gae,1,function(x)any(!is.na(x))),]
  gan <- gan[apply(gan,1,function(x)any(!is.na(x))),]
  #gbn[] <- as.numeric(factor(as.matrix(gbn)))
  #gbn <- gbn[, colSums(gbn != 0) > 0]
  idx <- which(colnames(gbn)=="SampleID") - 1
  ht1 <- Heatmap(t(gbn[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="Before Everyday", row_title="Genes",column_title="Everyday Before") 
  ht3 <- Heatmap(t(gbe[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="Before Elite", row_title="Genes",column_title="Elite Before")
  ht5 <- Heatmap(t(gan[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="After Everyday", row_title="Genes",column_title="Everyday After")
  ht7 <- Heatmap(t(gae[2:idx]),show_row_names = FALSE, show_column_names = FALSE, name="After Elite", row_title="Genes",column_title="Elite After")
  setwd("/Users/jacobluber/Desktop/athlete_metadata")
  png(paste(args[1],"_hmap.png",sep=""))
  hm1<-add_heatmap(ht1,ht3)
  hm2<-add_heatmap(hm1,ht5)
  hm3<-add_heatmap(hm2,ht7)
  draw(hm3)
  dev.off()
  }

split_heatmap_g(t_abundances)
split_heatmap_t(s_abundances)



#plot_both("PBAAKNOD_01129")levels(gbn)

#plot_both("HPAOKJOH_00142")

