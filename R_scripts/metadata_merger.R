library(dplyr)
library(tibble)

args = commandArgs(trailingOnly=TRUE)
abundances <- read.csv(args[1],header=TRUE,row.names=1)
t_abundances <- data.frame(t(abundances))
t_abundances <- rownames_to_column(t_abundances,"GENE")
t_abundances <- data.frame(t_abundances)

#for now this is hardcoded 
ru1_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_ru1_metadata.csv")
ru2_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_ru2_metadata.csv")
rnaseq_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_rnaseq_metadata.csv")

transcriptomics <- inner_join(t_abundances,rnaseq_meta, by = c("GENE" = "SampleID"))
genomics_1 <- inner_join(t_abundances, ru1_meta, by = c("GENE" = "Filename"))
genomics_2 <- inner_join(t_abundances, ru2_meta, by = c("GENE" = "SampleID"))
genomics <- bind_rows(genomics_1,genomics_2)
all <- bind_rows(genomics,transcriptomics)

fn1 <- paste(args[1],"mgx",sep='_')
fn2 <- paste(args[1],"mtx",sep='_')
fn3 <- paste(args[1],"all",sep='_')

write.csv(genomics, file = fn1)
write.csv(transcriptomics,file = fn2)
write.csv(all,file=fn3)


