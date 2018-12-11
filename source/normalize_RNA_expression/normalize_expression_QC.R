library(dplyr)
library(beadarray)

SS <- read.csv(file="/Users/jennywang/Desktop/BCaPE/ExpressionFullSampleSheet.csv", header=TRUE)


# Plot and summarize the signal-to-noise ratio for the arrays
setwd("/Users/jennywang/Desktop/BCaPE/ScannerMetrics")

pdf("/Users/jennywang/Desktop/BCaPE/SignaltoNoise.pdf",
    width=12, height=8)

QC <- data.frame()

alldirs <- dir()
for (i in alldirs) {
  ht12metrics <- read.table(paste(i, "/metrics.txt", sep=""), as.is=TRUE, header=TRUE, sep="\t")
  ht12snr <- ht12metrics$P95Grn / ht12metrics$P05Grn
  labs <- paste(ht12metrics[, 2], ht12metrics[, 3], sep="_")
  par(mai=c(1.5 , 0.8 , 0.3 , 0.1))
  plot(1:12, ht12snr, pch=19, ylab="P95/P05", xlab ="",
        main=paste("Signal-to-noise ratio for HT12 data ", i, sep=""), ylim=c(0, max(ht12snr)+5), axes=FALSE,
        frame.plot=TRUE)
  axis(2)
  axis(1, 1:12, labs, las=2)
  abline(h=10, col="red", lty=2)
  
  QC <- rbind(QC, data.frame("SENTRIX"=labs, "SNR"=ht12snr))
}
dev.off()


# Filter out arrays with P95/P05 values that are less than 10 and create our own sample sheet based on the QC results
quality.arrays <- filter(QC, SNR>=10)
write.csv(quality.arrays, file="/Users/jennywang/Desktop/BCaPE/high_quality_arrays.csv", row.names=FALSE)

SS <- within(SS, x <- paste(Sentrix_ID, Sentrix_Position, sep="_"))
sampleSheetFile <- SS %>%
  filter(x %in% quality.arrays$SENTRIX) %>%
  select(ID, Sample_Name, Sentrix_ID, Sentrix_Position)
write.csv(sampleSheetFile, file="/Users/jennywang/Desktop/BCaPE/sampleSheet.csv", row.names=FALSE)


# Which arrays did the authors include that we did not and vice-versa?
SS$jenny <- "NO"
SS$jenny[SS$x %in% quality.arrays$SENTRIX] <- "YES"

QC_compare <- data.frame(SS$ID, SS$x, SS$Include, SS$jenny)

QC_compare$disagree <- ""
for (i in 1:nrow(QC_compare)) {
  if (QC_compare$SS.Include[i] != QC_compare$SS.jenny[i])
  {
    QC_compare$disagree[i] <- "*"
  }
}

colnames(QC_compare) <- c("SAMPLE", "ARRAY", "INCLUDED IN AUTHORS' PIPELINE?", "INCLUDED IN JENNY'S PIPELINE?", "DISCREPANCY")
write.csv(QC_compare, file="/Users/jennywang/Desktop/BCaPE/QC_compare.csv", row.names=FALSE)