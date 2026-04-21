library(data.table)
DF <- as.data.frame(data.table::fread(here::here("data.csv")))

BMI <- DF["BMI"]
hgb <- DF["hgb"]
hgb_date <- DF["hgb_date"]
med_neg_inotrope <- DF["med_neg_inotrope"]
slope_veco2 <- DF["slope_veco2"]
fvc <- DF["fvc"]
fvc_lln <- DF["fvc_lln"]
fvc_pred <- DF["fvc_pred"]
fev1 <- DF["fev1"]
VE_pred <- fev1 * 40
fev1_lln <- DF["fev1_lln"]
fev1_pred <- DF["fev1_pred"]
ratio_lln <- DF["ratio_lln"]
ratio_pred <- DF["ratio_pred"]
dlco <- DF["dlco"]
dlco_lln <- DF["dlco_lln"]
dlco_pred <- DF["dlco_pred"]
vo2_kg <- DF["vo2_kg"]
vo2_at <- DF["vo2_at"]
vo2_peak <- DF["vo2_peak"]
vo2_pred <- DF["vo2_pred"]
max_workload <- DF["max_workload"]
hr_rest <- DF["hr_rest"]
hr_peak <- DF["hr_peak"]
hr_pred_peak <- DF["hr_pred_peak"]
O2pulse_peak <- DF["O2pulse_peak"]
O2pulse_pred <- DF["O2pulse_pred"]
VE <- DF["VE"]
VTex_rest <- DF["VTex_rest"]
VTex_max <- DF["VTex_max"]
rr_rest <- DF["rr_rest"]
rr_max <- DF["rr_max"]
RER_at <- DF["RER_at"]
RER_max <- DF["RER_max"]
spo2_rest <- DF["spo2_rest"]
spo2_max <- DF["spo2_max"]
VeCO2_at <- DF["VeCO2_at"]
PETCO2 <- DF["PETCO2"]
mode_of_exercise <- DF["mode_of_exercise"]
reason_to_end <- DF["reason_to_end"]
exercise_duration <- DF["exercise_duration"]
sbp_rest <- DF["sbp_rest"]
dbp_rest <- DF["dbp_rest"]
sbp_peak <- DF["sbp_peak"]
dbp_peak <- DF["dbp_peak"]
ekg <- DF["ekg"]

confirm_data_good <- function(){
  ensure_numeric <- c(BMI, hgb, slope_veco2, fvc, fvc_lln, fvc_pred, fev1, fev1_lln, fev1_pred, VE_pred, ratio_lln, ratio_pred, dlco, dlco_lln, dlco_pred, vo2_kg, vo2_at, vo2_peak, vo2_pred, max_workload, hr_rest, hr_peak, hr_pred_peak, O2pulse_peak, O2pulse_pred, VE, VTex_rest, VTex_max, rr_rest, rr_max, RER_at, RER_max,spo2_rest, spo2_max, VeCO2_at, PETCO2, exercise_duration, sbp_rest, dbp_rest, sbp_peak, dbp_peak)
  ensure_string <- c(hgb_date, med_neg_inotrope, mode_of_exercise, reason_to_end, ekg)
  
  
  for(i in 1:length(ensure_numeric)){
    checkmate::assert_numeric(ensure_numeric[[i]])  
  }
  
  for(i in 1:length(ensure_string)){
    checkmate::assert_string(ensure_string[[i]])  
  }
}

confirm_data_good()

