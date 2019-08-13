library(DNAcopy)

setwd("/mnt/work1/users/bhklab/Users/jenny/CNA/3_copycaller")

called <- dir(pattern=".copynumber.called$")

segmented_dir <- "/mnt/work1/users/bhklab/Users/jenny/CNA/4_segmented"

for (i in called) {
  cn <- read.table(i, header=TRUE)
  CNA.object <-CNA(genomdat=cn[, 7], chrom=cn[, 1], maploc=cn[, 2], data.type="logratio")
  CNA.smoothed <- smooth.CNA(CNA.object)
  CNA.object.smoothed.seg <- segment(CNA.smoothed, verbose=0, min.width=2)
  seg.pvalue <- segments.p(CNA.object.smoothed.seg, ngrid=100, tol=1e-6, alpha=0.05,
                           search.range=100, nperm=1000)
  write.table(seg.pvalue, file=paste(paste(segmented_dir, i, sep="/"), "segmented", sep="."),
              row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
  
  print(paste("Segmentation for", i, "done", sep=" "))

# segmented = CNA.object.smoothed.seg$output
# write.table(segmented[, 2:6], file="/mnt/work1/users/bhklab/Users/jenny/CNA/cbs_P1",
#             row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
}