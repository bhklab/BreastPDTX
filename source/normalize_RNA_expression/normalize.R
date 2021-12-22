library(beadarray)
library(limma)
library(illuminaHumanv4.db)




datasumm <- readRDS("data/results/normalize_RNA_expression/before_normalization.Rda")
det <- readRDS("data/results/normalize_RNA_expression/detection_pval.Rda")

proportion <- propexpr(exprs(datasumm), status=fData(datasumm)$Status)
pdf("data/results/normalize_RNA_expression/expressed_probes.pdf",
    width=10, height=25)
dotchart(proportion, labels=pData(datasumm)$ID,
         xlab="Proportion of probes expressed above the level of negative controls", pch=19)
dev.off()
slide <- colnames(datasumm)
slide <- sapply(strsplit(slide, "_"), function(x) x[1])
pdf("data/results/normalize_RNA_expression/MDS_batch.pdf",
    width=10, height=10)
plotMDS(exprs(datasumm), col=as.numeric(factor(slide)), labels=pData(datasumm)$ID)
dev.off()

normalized <- normaliseIllumina(datasumm, method="quantile")

illuminaHumanv4()
ids <- as.character(featureNames(normalized))
qual <- unlist(mget(ids, illuminaHumanv4PROBEQUALITY, ifnotfound=NA))
qual <- gsub("*", "", qual, fixed=TRUE)
symbol <- unlist(mget(ids, illuminaHumanv4SYMBOL, ifnotfound=NA))
Pos <- unlist(mget(ids, illuminaHumanv4GENOMICLOCATION, ifnotfound=NA))
SNP <- unlist(mget(ids, illuminaHumanv4OVERLAPPINGSNP, ifnotfound=NA))
symbol2 <- unlist(mget(ids, illuminaHumanv4SYMBOLREANNOTATED, ifnotfound=NA))
zone <- unlist(mget(ids, illuminaHumanv4CODINGZONE, ifnotfound=NA))
fData(normalized) <- cbind(fData(normalized), qual, symbol, symbol2, Pos, SNP, zone)

# table(qual)
AveSignal <- rowMeans(exprs(normalized))
boxplot(AveSignal ~ qual)
rem <- qual=="No match" | qual=="Bad"
normalized.filt <- normalized[!rem, ]
dim(normalized)
dim(normalized.filt)


saveRDS(normalized.filt, "data/results/normalize_RNA_expression/after_normalization.Rda")
