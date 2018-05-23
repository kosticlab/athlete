args <- commandArgs(trailingOnly = TRUE)
df2 <- read.table(file=args[1])
df2$adjusted <- p.adjust(df2$V1, method="BH", n=3000)
write.table(df2$adjusted, file= args[2], col.names = FALSE)

