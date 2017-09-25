library(ggplot2)
library(cowplot)
library(grid)
library(gridExtra)
library(tidyr)
library(ComplexHeatmap)

t_abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/genomics.csv",header=TRUE,row.names=1)
s_abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/transcriptomics.csv",header=TRUE,row.names=1)

test <- t_abundances[t_abundances$Exercise_state %in% c("Before","After"),]
test2 <- s_abundances[s_abundances$Exercise_state %in% c("Before","After"),]
setwd("/Users/jacobluber/potential_stories")

plot_both <- function(gene){
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
png(paste(gene, "png", sep="."))
grid.arrange(p,g,ncol=2)
dev.off()
}
}

lapply(intersect(colnames(test),colnames(test2))[-1],function(x) plot_both(x))

#gb <- t(na.omit(t_abundances[t_abundances$Exercise_state == "Before",]))
#ga <- t(na.omit(t_abundances[t_abundances$Exercise_state == "After",]))
#ht1 = Heatmap(as.matrix(gb[2:2400]), name = "ht1", row_title = "Genes", column_title = "Before Samples", show_row_names = FALSE, show_column_names = FALSE)
#ht2 = Heatmap(as.matrix(ga[2:2400]), name = "ht2", row_title = "Genes", column_title = "Heat Samples",  show_row_names = FALSE, show_column_names = FALSE)
split_heatmap_t <- function(transcriptomics,rownum){
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
ht2 <- Heatmap(t(tbn[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="Before Everyday", row_title="Genes",column_title="Elite Before")
ht4 <- Heatmap(t(tbe[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="Before Elite", row_title="Genes",column_title="Elite Before")
ht6 <- Heatmap(t(tan[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="After Everyday", row_title="Genes",column_title="Everyday After")
ht8 <- Heatmap(t(tae[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="After Elite", row_title="Genes",column_title="Elite After")
ht2+ht4+ht6+ht8
}

split_heatmap_g <- function(genomics,rownum){
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
  ht1 <- Heatmap(t(gbn[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="Before Everyday", row_title="Genes",column_title="Everyday Before")
  ht3 <- Heatmap(t(gbe[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="Before Elite", row_title="Genes",column_title="Elite Before")
  ht5 <- Heatmap(t(gan[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="After Everyday", row_title="Genes",column_title="Everyday After")
  ht7 <- Heatmap(t(gae[2:rownum]),show_row_names = FALSE, show_column_names = FALSE, name="After Elite", row_title="Genes",column_title="Elite After")
  ht1+ht3+ht5+ht7
  }

split_heatmap_g(t_abundances,2553)
split_heatmap_t(s_abundances,2553)

#plot_both("HPAOKJOH_00142")

