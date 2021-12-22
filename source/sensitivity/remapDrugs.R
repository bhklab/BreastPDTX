library(data.table)

drug.annotation.all <- as.data.frame(fread("~/Code/Github/pachyderm/Annotations/drugs_with_ids.csv"))

raw_drug <- as.data.frame(fread("data/raw_drug.csv"))


drug.annotation.all$PDTX.drugid <- NA_character_


daa.matches <- match(raw_drug$DRUG_NAME,drug.annotation.all$unique.drugid)

missing.matches <- is.na(daa.matches)



matching.table <- data.frame("PDXT.drugid"=raw_drug$DRUG_NAME, 
	"unique.drugid"=drug.annotation.all$unique.drugid[daa.matches])

write.csv(matching.table, file="data/table_matching_to_annotation.csv")

#### remapping done 


matching.table.done <- as.data.frame(fread(file="data/table_matching_to_annotation_mapped.csv"))

colnames(matching.table.done)[2:3] <- c("PDTX.drugid", "unique.drugid")


mapped.matches <- match(matching.table.done$unique.drugid, drug.annotation.all$unique.drugid)

drug.annotation.all[na.omit(mapped.matches), "PDTX.drugid"] <- matching.table.done[!is.na(mapped.matches),"PDTX.drugid"]


## visual spot check
drug.annotation.all[na.omit(mapped.matches), c("unique.drugid","PDTX.drugid")]



matching.table.done[is.na(mapped.matches),]

new.rows <- drug.annotation.all[rep(NA_real_, sum(is.na(mapped.matches))),]

new.rows[,c("PDTX.drugid","unique.drugid")] <- matching.table.done[is.na(mapped.matches),c("PDTX.drugid","unique.drugid")]
new.rows$PharmacoDB.status <- 'Absent'

drug.annotation.all <- rbind(drug.annotation.all, new.rows)

write.csv(drug.annotation.all, "~/Code/Github/pachyderm/Annotations/drugs_with_ids.csv")