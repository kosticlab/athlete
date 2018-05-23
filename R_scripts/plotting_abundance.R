library(dada2)
library(ggplot2)
library(vegan)
library(dplyr)
library(scales)
library(grid)
library(reshape2)
library(phyloseq)
library(plotrix)
args = commandArgs(trailingOnly=TRUE)
load(args[1])
samples.out <- rownames(seqtab.nochim)
subject <- sapply(strsplit(samples.out, "D"), `[`, 1)
samdf <- data.frame(Subject=subject)
rownames(samdf) <- samples.out
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))
#sapply(strsplit(subject,"_"), `[`, 1)
#rownames(seqtab.nochim) <- sapply(strsplit(subject,"_"), `[`, 1)
#colnames(tax_table(ps)) <- c("Kingdom","Phylum","Class","Order","Family","Genus")

#agglomorate at a given taxonomic rank
#urG <- tax_glom(ps, taxrank = "Genus")
#http://deneflab.github.io/MicrobeMiseq/demos/mothur_2_phyloseq.html

#p <- plot_bar(urG, "Genus", fill="Genus")
              
top20 <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:20]
ps.top20 <- transform_sample_counts(ps, function(OTU) OTU/sum(OTU))
ps.top20 <- prune_taxa(top20, ps.top20)
t1 = tax_glom(ps.top20, "Genus")
plot_bar(ps.top20, fill="Family")


v1 = subset_taxa(ps, Genus == "Veillonella")
plot_bar(v1,fill="Genus")

v2 <- transform_sample_counts(v1, function(OTU) OTU/sum(OTU))
plot_bar(v2,fill="Genus")



v1 = subset_taxa(ps, Genus == "Veillonella")
plot_bar(v1,fill="Genus")

md <- read.csv(file="~/Desktop/metadatam.tsv",header=TRUE,sep="\t")
samdf <- data.frame(Subject=md$SampleID,State=md$ParticipantType,Individual=md$SubjectID,Time=md$Time)
rownames(samdf) <- samdf$Subject
phylum_colors <- c(
  "black", #CBD588", "#5F7FC7", "orange","#DA5724", "#508578", "#CD9BCD",
  "#AD6F3B", "#673770","#D14285", "#652926", "#C84248", 
  "#8569D5", "#5E738F","#D1A33D", "#8A7C64", "#599861"
)

ggplot(marathon_phylum, aes(x = Time, y = Abundance, fill = Phylum)) + 
  facet_grid(State~.) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = phylum_colors)

#filter(Abundance > 0.02) %>%

top20 <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:1000]
ps.top20 <- prune_taxa(top20, ps)
marathon_phylum <- ps.top20 %>%
  tax_glom(taxrank = "Phylum") %>%
  transform_sample_counts(function(x) {(x/sum(x))} ) %>%
  psmelt() %>%
  filter(Individual != "SG27") %>%
  filter(Time != 0) %>%
  filter(Time != -6) %>%
  arrange(Phylum)

ggplot(marathon_phylum, aes(x = Individual, y = Abundance, fill = Phylum)) + 
  facet_grid(Time~State,drop=TRUE,scales="free",space="free") +
  geom_bar(stat = "identity") + theme(strip.text = element_text(face="bold", size=9)) +
  theme(axis.text.y=element_blank(),axis.ticks.y=element_blank()) + ylab("Relative Abundance") +
  scale_y_continuous(sec.axis = sec_axis(~.*5, name = "Time(hrs) in Relation to Exercise")) 

#+theme(legend.position="bottom")


phyloObject.100  = transform_sample_counts(phyloObject, function(x) 100 * x/sum(x))
phyloObject.merged = phyloObject.100
variable1 = as.character(get_variable(phyloObject.merged, "X"))
variable2 = as.character(get_variable(phyloObject.merged, "F"))
sample_data(phyloObject.merged)$X_F <- mapply(paste0, variable1, variable2, 
                                              collapse = "_")
phyloObject.merged = merge_samples(phyloObject.merged, "X_F")
phyloObject.merged.100  = transform_sample_counts(phyloObject.merged, function(x) 100 * x/sum(x))
ms1 <- phyloObject.merged.100 %>% tax_glom(taxrank = "Genus") %>% psmelt() %>% arrange(Genus)


ggplot(v3, aes(x = Individual, y = Abundance, fill = Genus)) + 
  facet_grid(Time~State,drop=FALSE,scale="free",space="free") +
  geom_bar(stat = "identity") + theme(strip.text = element_text(face="bold", size=9)) +
  ylab("Relative Abundance") + scale_y_continuous(breaks=c(0, 0.005,0.03)) + 
  scale_fill_manual(values = phylum_colors) + scale_y_continuous(sec.axis = sec_axis(~.*5, name = "Time(hrs) in Relation to Exercise"))

ggplot(v3, aes(x = Individual, y = Abundance, fill = Genus)) + 
  facet_grid(Time~State,drop=FALSE,scale="free",space="free") +
  geom_bar(stat = "identity") + theme(strip.text = element_text(face="bold", size=9)) +
  ylab("Relative Abundance") + scale_y_continuous(breaks=c(0, 0.005,0.03)) + 
  scale_fill_manual(values = phylum_colors) + theme(legend.position="none")



mva.df = matrix(c(8,440,0,560),nrow=2)
fisher.test(mva.df)

df1 <- data.frame(subject,before,after)
il6 <- melt(df1,id.vars='subject')

ggplot(il6, aes(x=Time,y=IL.6.Abundance,fill = Treatment)) +   
  geom_bar(position = "dodge", stat="identity") + ylab("IL-6 Abundance") + xlab("Time Since Exercise") + geom_errorbar(aes(ymin=IL.6.Abundance-std.error(IL.6.Abundance), ymax=IL.6.Abundance+std.error(IL.6.Abundance)),width=.2,position=position_dodge(0.75))