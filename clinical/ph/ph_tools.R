calc_pvr <- function(mPAP, PCWP, CO) {
  # PVR_dynes <- (mPAP - PCWP) / CO
  PVR <- ((mPAP - PCWP) / CO)
  
  return(PVR)
}

calc_pvr_from_table <- function(DF){
  PVR <- ((DF[["mPAP"]] - DF[["PCWP"]]) / DF[["CO"]])
  return(PVR)
}

calc_svr_from_table <- function(DF, MAP){
  # units: dynes/cm2
  SVR <- ((MAP - DF[["RA"]]) / DF[["CO"]]) * 80
  return(SVR)
}

create_rhc_table <- function(RA, RVs, RVd, sPAP, dPAP, mPAP, PCWP, CO){
  DF <- data.frame(matrix(ncol = 8, nrow = 1))
  columns <- c("RA", "RVs", "RVd", "sPAP", "dPAP", "mPAP", "PCWP", "CO")
  colnames(DF) <- columns
  DF[["RA"]] <- RA
  DF[["RVs"]] <- RVs
  DF[["RVd"]] <- RVd
  DF[["sPAP"]] <- sPAP
  DF[["dPAP"]] <- dPAP
  DF[["mPAP"]] <- mPAP
  DF[["PCWP"]] <- PCWP
  DF[["CO"]] <- CO
  
  return(DF)
}

rhc <- create_rhc_table(4, 28, 1, 28, 10, 18, 9, 4.1)
round(calc_pvr_from_table(rhc), digits = 2)
calc_svr_from_table(rhc, (106+ 2 * 67)/3)
