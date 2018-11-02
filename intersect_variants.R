# Reformat VCF files and concatenate all samples for authors' results 
library(VariantAnnotation)
setwd("/mnt/work1/users/bhklab/Users/jenny/author/VCF")
allF <- dir(pattern="vcf.gz$")
SNVs <- NULL
for (i in allF) {
    x <- readVcf(i, "hg19")
    if (file.info(i)$size>0) {
    if (nrow(geno(x)$GT) > 0) {
        ID <- sapply(strsplit(i, ".", fixed=TRUE),
                     function(x) x[1])
        res <- do.call("rbind", geno(x)$AD)
        ref <- res[,1]
        alt <- res[,2]
        tmp <- data.frame(Genotype=geno(x)$GT[,1], ID=ID,
                          Ref=ref, Alt=alt)
        rownames(tmp) <- paste(ID, rownames(tmp), sep=";")
        SNVs <- rbind(SNVs, tmp)
    }
}
    cat(i, " done\n")
}


# Reformat VCF file and concatenate all samples for my results
setwd("/mnt/work1/users/bhklab/Users/jenny/author/VCF")
filenames <- dir(pattern="vcf.gz$")
jennySNVs <- NULL
  for (filename in filenames) {
    zz <- readVcf(filename, "hg19")
    if (file.info(filename)$size>0) {
    if (nrow(geno(zz)$GT) > 0) {
        id <- sapply(strsplit(filename, ".", fixed=TRUE),
                     function(zz) zz[1])
        if (geno(zz)$AD >= 0) {
        RES <- do.call("rbind", geno(zz)$AD)
        REF <- res[,1]
        ALT <- res[,2]
        TMP <- data.frame(Genotype=geno(zz)$GT[,1], ID=id,
                          Ref=REF, Alt=ALT)
        rownames(TMP) <- paste(ID, rownames(TMP), sep=";")
        jennySNVs <- rbind(jennySNVs, TMP)
    }
}
    cat(filename, " done\n")
}


# Extract common lines from both
library(dplyr)
inner_join(jennySNVs, SNVs)
