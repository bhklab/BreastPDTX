drug <- read.csv("~/Desktop/BreastPDTX/data/raw_drug.csv")

curationDrugs <- read.csv("~/Desktop/BreastPDTX/data/drug_annotation_all.csv")

colnames(drug)[1] <- "unique.drugid"

drug <- drug[order(match(drug$unique.drugid, curationDrugs$unique.drugid)), ]
rownames(drug) <- drug$unique.drugid

write.csv(drug, file=("~/Desktop/BreastPDTX/data/drug.csv"))
