library(beadarray)
library(limma)

datasumm <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/before_normalization.Rda")
det <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/detection_pval.Rda")

proportion <- propexpr(exprs(datasumm), status=fData(datasumm)$Status)
pdf("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/expressed_probes.pdf",
    width=10, height=25)
dotchart(proportion, labels=pData(datasumm)$ID,
         xlab="Proportion of probes expressed above the level of negative controls", pch=19)
dev.off()
slide <- colnames(datasumm)
slide <- sapply(strsplit(slide, "_"), function(x) x[1])
pdf("~/Desktop/test1.pdf", width=10, height=10)
plotMDS(exprs(datasumm))
dev.off()
