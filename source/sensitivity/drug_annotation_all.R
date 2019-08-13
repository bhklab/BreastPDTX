library(Biobase)

sensitivity <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")

drug_annotation_all <- data.frame(unique.drugid=unique(sensitivity$drugid),
                                  BreastPDTX=unique(sensitivity$drugid))

rownames(drug_annotation_all) <- drug_annotation_all$unique.drugid

write.csv(drug_annotation_all, file="~/Desktop/BreastPDTX/data/drug_annotation_all.csv")
