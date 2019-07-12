library(beadarray)

chipPath <- "~/Desktop/bruna_expression/"
list.files(chipPath)
sampleSheetFile <- paste(chipPath, "/sampleSheet.csv", sep="")
readLines(sampleSheetFile)
chip <- readIllumina(dir=chipPath, sampleSheet=sampleSheetFile,
                     useImages=FALSE, illuminaAnnotation="Humanv4")

SS <- read.csv("~/Desktop/bruna_expression/sampleSheet.csv", skip=7)
SS$Sentrix_Position <- toupper(SS$Sentrix_Position)

pdf("~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/control_probes.pdf",
    width=12, height=6)
for (i in 1:nrow(SS)) {
  print(combinedControlPlot(chip, array=i))
}
dev.off()

saveRDS(chip, file="~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/full_bead_before_BASH.Rda")

for (i in 1:nrow(SS)) {
  BASHoutput <- BASH(chip, array=i)
  chip <- setWeights(chip, wts=BASHoutput$wts, array=i)
}
saveRDS(chip, file="~/Desktop/BreastPDTX/data/results/normalize_RNA_expression/full_bead_after_BASH.Rda")

# expressionQCPipeline(chip, horizontal=TRUE)