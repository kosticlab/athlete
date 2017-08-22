library(dplyr)

abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/criteria_abundances001_t.csv")
ru1_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/correct_ru1_metadata.csv")
ru2_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/correct_ru2_metadata.csv")
rnaseq_meta <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/correct_rnaseq_metadata.csv")

transcriptomics <- inner_join(abundances,rnaseq_meta, by = c("GENE" = "SampleID"))
genomics_1 <- inner_join(abundances, ru1_meta, by = c("GENE" = "Filename"))
genomics_2 <- inner_join(abundances, ru2_meta, by = c("GENE" = "SampleID"))
genomics <- bind_rows(genomics_1,genomics_2)
all <- bind_rows(genomics,transcriptomics)

write.csv(genomics, file = "genomics.csv")
write.csv(transcriptomics,file ="transcriptomics.csv")
write.csv(all,file="all.csv")


