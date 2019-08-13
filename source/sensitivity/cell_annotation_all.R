library(Biobase)

sensitivity <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")
expression <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/final_eset.Rda")


expression_samples <- rownames(pData(expression))
sensitivity_samples <- as.character(unique(sensitivity$cellid))

names <- union(expression_samples, sensitivity_samples)

cell_annotation_all <- data.frame(unique.cellid=names, BreastPDTX=names,
                                  row.names=names)

write.csv(cell_annotation_all, file="~/Desktop/BreastPDTX/data/cell_annotation_all.csv")
