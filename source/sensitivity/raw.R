dose_viability <- readRDS("~/Desktop/BreastPDTX/data/dose_viability.Rda")
dose_viability <- dose_viability[, -c(1, 2)]

dose <- as.matrix(dose_viability[, 6:10])
viability <- as.matrix(dose_viability[, 1:5])

raw <- array(c(dose, viability), dim=c(2550, 5, 2),
             dimnames=list(rownames(dose_viability),
                           sprintf("doses%d", seq(1, 5)),
                           c("Dose", "Viability")))
saveRDS(raw, file="~/Desktop/BreastPDTX/data/results/sensitivity/raw.Rda")