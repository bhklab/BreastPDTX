library(PharmacoGx)
library(SummarizedExperiment)

# cell <- read.csv("~/Desktop/BreastPDTX/data/cell.csv", header=TRUE, row.names=1)
# drug <- read.csv("~/Desktop/BreastPDTX/data/drug.csv", header=TRUE, row.names=1)
# curationCell <- read.csv("~/Desktop/BreastPDTX/data/cell_annotation_all.csv", header=TRUE, row.names=1)
# curationDrug <- read.csv("~/Desktop/BreastPDTX/data/drug_annotation_all.csv", header=TRUE, row.names=1)
# 
# info <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")
# profiles <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/profiles.Rda")
# raw <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/raw.Rda")
# 
# eset <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/final_eset.Rda")
####################-


## If you want to run this, update to correct path:
drug.annotation.all <- read.csv("~/Code/Github/pachyderm/Annotations/drugs_with_ids.csv")


cell <- read.csv("data/cell.csv", header=TRUE)
drug <- read.csv("data/raw_drug.csv", header=TRUE)






matchToIDTable <- function(ids,tbl, column, returnColumn="unique.cellid") {
  sapply(ids, function(x) {
    myx <- grep(paste0("((///)|^)",Hmisc::escapeRegex(x),"((///)|$)"), tbl[,column])
    if(length(myx) > 1){
      stop("Something went wrong in curating ids, we have multiple matches")
    }
    if(length(myx) == 0){return(NA_character_)}
    return(tbl[myx, returnColumn])
  })
}



drug$unique.drugid <- matchToIDTable(drug$DRUG_NAME, drug.annotation.all, "PDTX.drugid", "unique.drugid")




curationCell <- read.csv("data/cell_annotation_all.csv", header=TRUE, row.names=1)
curationDrug <- drug.annotation.all[,c("unique.drugid", "PDTX.drugid")]
curationDrug <- curationDrug[complete.cases(curationDrug),]



info <- readRDS("data/results/sensitivity/info.Rda")
profiles <- readRDS("data/results/sensitivity/profiles.Rda")
raw <- readRDS("data/results/sensitivity/raw.Rda")

## Map Info Table 

info$drugid <- matchToIDTable(info$drugid, drug.annotation.all, "PDTX.drugid", "unique.drugid")

SE <- SummarizedExperiment(readRDS("data/results/normalize_RNA_expression/final_eset.Rda"))
S4Vectors::metadata(SE)$annotation <- "rna"

final_PSet <- PharmacoSet(name="BreastPDTX",
                    molecularProfiles=list("rna"=SE),
                    cell=cell,
                    drug=drug,
                    sensitivityInfo=info,
                    sensitivityRaw=raw,
                    sensitivityProfiles=profiles,
                    curationCell=curationCell,
                    curationDrug=curationDrug,
                    datasetType="sensitivity",
                    verify=TRUE)

saveRDS(final_PSet, file="data/results/sensitivity/BreastPDTX_PSet.Rda")
