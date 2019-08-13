library(Biobase)

expression <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/after_normalization.Rda")
m <- exprs(expression)
pdata <- pData(expression); rownames(pdata) <- pdata$ID
fdata <- fData(expression); rownames(fdata) <- make.names(fdata$symbol, unique=TRUE)

colnames(m) <- pdata$ID; rownames(m) <- rownames(fdata)
m <- m[order(rownames(m)), order(colnames(m))]

pdata <- pdata[order(pdata$ID), ]
pdata <- AnnotatedDataFrame(pdata)
fdata <- fdata[order(rownames(fdata)), ]
fdata <- AnnotatedDataFrame(fdata)
eset <- new("ExpressionSet", exprs=m, phenoData=pdata, featureData=fdata)

saveRDS(eset, file="~/Desktop/normalize_RNA_expression/final_eset.Rda")
