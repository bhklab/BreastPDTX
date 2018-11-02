library(stringr)

setwd("/Users/jennywang/Desktop/")

samples <- read.csv(file="/Users/jennywang/Desktop/PDTX STRUCTURE.csv", header=FALSE)

samples$MODEL <- sapply(strsplit(as.character(samples$V1), split="-"), function(x) x[1])

samples$tmp <- sapply(strsplit(as.character(samples$V1), split="-"), function(x) x[2])


samples$TYPE <- ifelse(grepl("^N", samples$tmp), "NORMAL", samples$TYPE)

samples$TYPE <- ifelse(grepl("^T", samples$tmp), "TUMOR", samples$TYPE)

samples$REPLICATE <- ifelse(grepl("R", samples$tmp), "YES", "NO")

samples$tmp1 <- ifelse(grepl("^X[0-9]+$", samples$tmp), "(?<=^X)[0-9]+", NA)

