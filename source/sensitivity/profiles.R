library(PharmacoGx)

raw_drug <- read.csv("~/Desktop/bruna_drugs/RawDataDrugsSingleAgents.csv")
raw_drug <- raw_drug[, -c(1, 3)]
raw_drug <- raw_drug[order(raw_drug$DRUG_ID), ]
# Normalize raw intensity values to produce viability values
raw_drug[, 8:12] <- (raw_drug[, 8:12] - raw_drug$Blank)/(raw_drug$Control - raw_drug$Blank) * 100

info <- readRDS("~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")

med_intensity <- aggregate(raw_drug[, 8:12],
                           by=list(raw_drug$ID, raw_drug$DRUG_ID),
                           FUN=median)
med_intensity <- cbind(med_intensity, info[, 4:8])

rownames(med_intensity) <- paste("drugid", med_intensity$Group.2, med_intensity$Group.1, sep="_")
saveRDS(med_intensity, file="~/Desktop/BreastPDTX/data/dose_viability.Rda")

ic50_recomputed <- c()
for (i in 1:nrow(med_intensity)) {
  zz <- computeIC50(med_intensity[i, 8:12], med_intensity[i, 3:7])
  
  ic50_recomputed <- rbind(ic50_recomputed, zz)
}

auc_recomputed <- c()
for (i in 1:nrow(med_intensity)) {
  zz <- computeAUC(med_intensity[i, 8:12], med_intensity[i, 3:7])
  
  auc_recomputed <- rbind(auc_recomputed, zz)
}

published <- read.csv("~/Desktop/bruna_drugs/DrugResponsesAUCSamples.csv")
published <- published[order(published$Drug), ]

profiles <- data.frame(published$iC50, published$AUC,
                       auc_recomputed, ic50_recomputed)
colnames(profiles) <- c("ic50_published", "auc_published", "auc_recomputed", "ic50_recomputed")
rownames(profiles) <- rownames(med_intensity)
saveRDS(profiles, file="~/Desktop/BreastPDTX/data/results/sensitivity/profiles.Rda")
