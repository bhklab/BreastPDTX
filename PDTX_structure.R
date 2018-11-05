# Get sample names
## Run the following on mordor
## export RAW_DIR="/mnt/work1/users/bhklab/Data/Breast_Cancer_PDTX"
## ls $RAW_DIR | grep ".bam" | egrep -v '.bai|RRBS|Shall' | cut -f1 -d"."

## I like to copy the list and work on my local machine, but of course you can work on the cluster as well
## If you copy it to your local machine, name it "PDX SAMPLE LIST.csv"


library(stringr)

setwd("/Users/jennywang/Desktop/")

samples <- read.csv(file="/Users/jennywang/Desktop/PDX SAMPLE LIST.csv", header=FALSE)


# Assign patient IDs
samples$MODEL <- sapply(strsplit(as.character(samples$V1), split="-"), function(x) x[1])
samples$tmp <- sapply(strsplit(as.character(samples$V1), split="-"), function(x) x[2])


# Assign sample types
samples$TYPE <- ""

samples$TYPE <- ifelse(grepl("N", samples$tmp), "NORMAL", samples$TYPE)
samples$TYPE <- ifelse(grepl("T", samples$tmp), "TUMOR", samples$TYPE)
samples$TYPE <- ifelse(grepl("X", samples$tmp), "PDX", samples$TYPE)
samples$TYPE <- ifelse(grepl("C", samples$tmp), "PDC", samples$TYPE)


# Is the sample a replicate?
samples$REPLICATE <- ifelse(grepl("R", samples$tmp), "YES", "NO")


# Assign PDTC passage number
samples$C <- ""

for (i in 1:nrow(samples)) {
  ss <- samples$tmp[i]
  if (grepl("C", ss)==FALSE) 
  {
    samples$C[i] <- NA
  }  else {
     samples$C[i] <- strsplit(ss, "C")[[1]][2]
  }
}

for (i in 1:nrow(samples)) {
  ss <- samples$tmp[i]
  if (grepl("C$", ss)==TRUE) 
  {
    samples$C[i] <- "PDC PASSAGE NUMBER NOT CLEAR"
  }
}

## Take care of normal and tumor samples
## You don't have to run this; I just like to be redundant
for (i in 1:nrow(samples)) {
  nn <- samples$tmp[i]
  if (grepl("N", nn)==TRUE)
  {
    samples$C[i] <- NA
  }
}

for (i in 1:nrow(samples)) {
  tt <- samples$tmp[i]
  if (grepl("T", tt)==TRUE)
  {
    samples$C[i] <- NA
  }
}


# Assign replicate number
samples$REPLICATE_NUMBER <- ""

for (i in 1:nrow(samples)) {
  rr <- samples$tmp[i]
  if (grepl("R", rr)==TRUE)
  {
    samples$REPLICATE_NUMBER[i] <- strsplit(rr, "R")[[1]][2]
  }
}

for (i in 1:nrow(samples)) {
  rr <- samples$tmp[i]
  if (grepl("R$", rr)==TRUE)
  {
    samples$REPLICATE_NUMBER[i] <- "REPLICATE NUMBER NOT CLEAR"
  }
}



# Assign PDTX passage number
samples$X <- ""

for (i in 1:nrow(samples)) {
  x <- samples$tmp[i]
  if (grepl("X[0-9]+$", x)==TRUE)
  {
    samples$X[i] <- strsplit(x, "X")[[1]][2]
  }
}

for (i in 1:nrow(samples)) {
  xx <- samples$tmp[i]
  if (grepl("C", xx)==TRUE)
  {
    samples$X[i] <- gsub("X", "", strsplit(xx, "C")[[1]][1])
  }
}

for (i in 1:nrow(samples)) {
  yy <- samples$tmp[i]
  if (grepl("R", yy)==TRUE)
  {
    samples$X[i] <- gsub("X", "", strsplit(yy, "R")[[1]][1])
  }
}

## Take care of normal and tumor samples
for (i in 1:nrow(samples)) {
  n <- samples$tmp[i]
  if (grepl("N", n)==TRUE)
  {
    samples$X[i] <- NA
  }
}

for (i in 1:nrow(samples)) {
  t <- samples$tmp[i]
  if (grepl("T", t)==TRUE)
  {
    samples$X[i] <- NA
  }
}


# Patient CAMBMT1 is a special case, where 5 samples were taken from 5 different spots of 1 tumor, and from each of which a single PDTX was generated
samples$CC <- ""

for (i in 1:nrow(samples)) {
  cc <- samples$V1[i]
  if (grepl("CAMBMT1", cc)==TRUE)
  {
    samples$CC[i] <- strsplit(as.character(cc), split="-")[[1]][2]
  }
}

samples$XX <- ""

for (i in 1:nrow(samples)) {
  xx <- samples$V1[i]
  if (grepl("CAMBMT1", xx)==TRUE)
  {
    samples$XX[i] <- strsplit(as.character(xx), split="-")[[1]][3]
  }
}

## Assign corrected sample types
for (i in 1:nrow(samples)) {
  ct <- samples$XX[i]
  if (grepl("X", ct)==TRUE)
  {
    samples$TYPE[i] <- "PDX"
  }
}

## Assign PDTX passage number
for (i in 1:nrow(samples)) {
  ct <- samples$XX[i]
  if (grepl("X", ct)==TRUE)
  {
    samples$X[i] <- strsplit(ct, "")[[1]][2]
  }
}

## Assign tumor replicate number
samples$CAMBMT1_TUMOR_NUMBER <- ""

for (i in 1:nrow(samples)) {
  ct <- samples$CC[i]
  if (grepl("T", ct)==FALSE)
  {
    samples$CAMBMT1_TUMOR_NUMBER[i] <- NA
  } else {
    samples$CAMBMT1_TUMOR_NUMBER[i] <- strsplit(ct, "")[[1]][2]
  }
}


# Make the summary data frame
PDTX_STRUCTURE <- cbind(as.vector(samples$V1), samples$MODEL, samples$TYPE, samples$CAMBMT1_TUMOR_NUMBER, samples$X, samples$C, samples$REPLICATE, samples$REPLICATE_NUMBER)
PDTX_STRUCTURE <- as.data.frame(PDTX_STRUCTURE)

colnames(PDTX_STRUCTURE) <- c("SAMPLE", "PATIENT", "TYPE", "CAMBMT1 TUMOR PASSAGE NUMBER", "PDX PASSAGE NUMBER", "PDC PASSAGE NUMBER", "IS REPLICATE?", "REPLICATE NUMBER")

write.csv(PDTX_STRUCTURE, file="BCaPE PDX STRUCTURE.csv")