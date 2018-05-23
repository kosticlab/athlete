library(ggplot2)
args <- commandArgs(trailingOnly = TRUE)
df2 <- read.table(file=args[1],sep=",",header=TRUE)
jpeg(paste(args[1],".jpg",sep=""))
#ggplot(df2, aes(x=ra, fill=condition)) + geom_density(alpha=.3) + coord_cartesian(ylim=c(0, 1000))
ggplot(df2, aes(x=ra, fill=condition)) + geom_histogram(alpha=.3) + coord_cartesian(ylim=c(0,250))
dev.off()

