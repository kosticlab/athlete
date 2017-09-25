library(dplyr)
library(tibble)



abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/l_abundances.csv",header=TRUE,row.names=1)




t_abundances <- data.frame(t(abundances))
t_abundances <- rownames_to_column(t_abundances,"GENE")
t_abundances <- data.frame(t_abundances)
#write.csv(x=t_abundances,file="/Users/jacobluber/Desktop/athlete_metadata/veill/test1.csv")

#t_abundances <- data.frame(lapply(t_abundances,as.factor))

ru1_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_ru1_metadata.csv")
ru2_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_ru2_metadata.csv")
rnaseq_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/precursors/correct_rnaseq_metadata.csv")

transcriptomics <- inner_join(t_abundances,rnaseq_meta, by = c("GENE" = "SampleID"))
genomics_1 <- inner_join(t_abundances, ru1_meta, by = c("GENE" = "Filename"))
genomics_2 <- inner_join(t_abundances, ru2_meta, by = c("GENE" = "SampleID"))
genomics <- bind_rows(genomics_1,genomics_2)
all <- bind_rows(genomics,transcriptomics)

write.csv(genomics, file = "l_genomics.csv")
write.csv(transcriptomics,file ="l_transcriptomics.csv")
write.csv(all,file="l_all.csv")


