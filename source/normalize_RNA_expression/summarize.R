library(beadarray)

chip <- readRDS("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/full_bead_after_BASH.Rda")

datasumm <- summarize(BLData=chip) # summarize() automatically does log2 transformation

rm(chip)
gc()

pdf("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/log2_intensity.pdf",
    width=30, height=15)
par(mai=c(1.5, 1, 0.2, 0.1), mfrow=c(1, 1))
boxplot(exprs(datasumm), ylab=expression(log[2](intensity)),
        las=2, outline=FALSE)
boxplot(nObservations(datasumm), ylab="number of beads",
        las=2, outline=FALSE)
dev.off()

det <- calculateDetection(datasumm)
Detection(datasumm) <- det

saveRDS(datasumm, file="~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/before_normalization.Rda")
saveRDS(det, file="~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/detection_pval.Rda")