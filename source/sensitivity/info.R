raw_drug <- read.csv("~/Desktop/bruna_drugs/RawDataDrugsSingleAgents.csv")
raw_drug <- raw_drug[, -c(1, 3, 15, 16)]
raw_drug <- raw_drug[order(raw_drug$DRUG_ID), ]

x <- aggregate(raw_drug[, 3:7],
                     by=list(raw_drug$ID, raw_drug$DRUG_ID),
                     FUN=median) # same thing as removing duplicates but this way we make sure the rownames match
                                 # exactly with the rownames in profiles and everything else

x$num <- c()
for (i in 1:nrow(x)) {
  x$num[i] <- length(unique(x[i, 3:7]))
}

cellid <- paste("drugid", x$Group.2, x$Group.1, sep="_")


info <- data.frame(cellid=cellid, drugid=x$Group.2, nbr.conc.tested=x$num,
                   Dose1.uM=x$D1_CONC, Dose2.uM=x$D2_CONC, Dose3.uM=x$D3_CONC,
                   Dose4.uM=x$D4_CONC, Dose5.uM=x$D5_CONC)
saveRDS(info, file="~/Desktop/BreastPDTX/data/results/sensitivity/info.Rda")
