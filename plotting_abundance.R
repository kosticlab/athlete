library(phyloseq)
library(dada2)
args = commandArgs(trailingOnly=TRUE)
load(args[1])
samples.out <- rownames(seqtab.nochim)
subject <- sapply(strsplit(samples.out, "D"), `[`, 1)
samdf <- data.frame(Subject=subject)
rownames(samdf) <- samples.out
ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxa))

#colnames(tax_table(ps)) <- c("Kingdom","Phylum","Class","Order","Family","Genus")

#agglomorate at a given taxonomic rank
#urG <- tax_glom(ps, taxrank = "Genus")


#p <- plot_bar(urG, "Genus", fill="Genus")
              
top20 <- names(sort(taxa_sums(ps), decreasing=TRUE))[1:1000]
ps.top20 <- transform_sample_counts(ps, function(OTU) OTU/sum(OTU))
ps.top20 <- prune_taxa(top20, ps.top20)
plot_bar(ps.top20, fill="Genus")


v1 = subset_taxa(ps, Genus == "Veillonella")
plot_bar(v1,fill="Genus")

v2 <- transform_sample_counts(v1, function(OTU) OTU/sum(OTU))
plot_bar(v2,fill="Genus")