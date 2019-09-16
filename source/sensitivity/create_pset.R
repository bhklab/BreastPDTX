library(PharmacoGx)

cell <- read.csv("~/Desktop/BreastPDTX/data/cell.csv", header=TRUE, row.names=1)
drug <- read.csv("~/Desktop/BreastPDTX/data/drug.csv", header=TRUE, row.names=1)
curationCell <- read.csv("~/Desktop/BreastPDTX/data/cell_annotation_all.csv", header=TRUE, row.names=1)
curationDrug <- read.csv("~/Desktop/BreastPDTX/data/drug_annotation_all.csv", header=TRUE, row.names=1)

info <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")
profiles <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/profiles.Rda")
raw <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/raw.Rda")

eset <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/final_eset.Rda")

Biobase::annotation(eset) <- "rna"

final_PSet <- PharmacoSet(name="BreastPDTX",
                    molecularProfiles=list("rna"=eset),
                    cell=cell,
                    drug=drug,
                    sensitivityInfo=info,
                    sensitivityRaw=raw,
                    sensitivityProfiles=profiles,
                    curationCell=curationCell,
                    curationDrug=curationDrug,
                    datasetType="sensitivity",
                    verify=TRUE)

saveRDS(final_PSet, file="~/Desktop/BreastPDTX/data/results/sensitivity/BreastPDTX_PSet.Rda")
