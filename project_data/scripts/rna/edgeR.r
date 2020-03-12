library(edgeR)

#change below variable to read_counts path generated from SeqMonk
counts_path <- "/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/read_counts.txt"

#import read_counts dataset into RStudio
read_counts <- read.delim("/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/read_counts.txt")
message("read counts imported")

#SeqMonk outputs multiple columns we don't need, only want gene annotation and 8 sample columns
#below removes unwanted column, trim_counts is are data matrix for edgeR analysis
trim_counts <- read_counts[ , c("Mid_1","Mid_3","Mid_5","Mid_7","Neg_2","Neg_4","Neg_6","Neg_8"), ]
message("read_counts columns trimmed")

#generate DGEList, with 2 groups of 4 samples each
group <- c(1,1,1,1,2,2,2,2)
list_counts <- DGEList(counts=trim_counts, genes=rownames(trim_counts), group=group)
message("DGEList generated, total counts visible below")

summary(list_counts)
pre_filter <- summary(list_counts)
save(pre_filter, file = "/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/edger_stats/pre_filter.RData")

#filter out counts with minimal expression
keep <- filterByExpr(list_counts)
list_counts <- list_counts[keep, , keep.lib.sizes=FALSE ]
message("minimally expressed counts filtered, total counts visible below")

summary(list_counts)
post_filter <- summary(list_counts)
save(post_filter, file = "/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/edger_stats/post_filter.RData")

#Normalise for RNA composition
list_counts <- calcNormFactors(list_counts)
sample_normalisation_factors <- list_counts$samples
save(sample_normalisation_factors, file = "/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/edger_stats/sample_normalisation_factors.RData")
message("Counts normalised for RNA composition")

#Estimate dispersions between two groups and find differentially expressed (DE) genes
list_counts <- estimateDisp(list_counts)
et <- exactTest(list_counts)

#writing top gene hits to a text file
message("writing top gene hits to a text file")
gene_hits <- topTags(et)
write.table(gene_hits, file = "/Volumes/Recovered_Mac/project/project_data/analysis/rna_seq/mapping/edger_stats/gene_hits", sep="\t", row.names = TRUE, col.names = TRUE)
View(gene_hits)
message("edgeR analysis complete")
