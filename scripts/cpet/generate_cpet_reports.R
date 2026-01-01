#################
# LIBRARY calls #
#################
library(data.table)
library(here)
library(dplyr)
library(checkmate)
source(here::here("cpet_tools.R"))


########################
# VARIABLE definitions #
########################
df <- data.table::fread(here::here("cpet_values.csv"))

head_vent_resp <- "Ventilatory Response"
head_gas_ex <- "Gas Exchange"
head_sum <- "Summary"
head_interpretation <- "Interpretation"
head_cir_resp <- "Circulatory Response"

fvc_results <- spirometry_extra_text(status_z_score(calc_z_score(df[["fvc"]], df[["fvc_lln"]], df[["fvc_pred"]])))
fev1_results <- spirometry_extra_text(status_z_score(calc_z_score(df[["fev1"]], df[["fev1_lln"]], df[["fev1_pred"]])))
spirometry_results <- status_spirometry(df[["fvc"]], df[["fvc_lln"]], df[["fvc_pred"]], df[["fev1"]], df[["fev_lln"]], df[["fev1_pred"]], df[["ratio_lln"]], df[["ratio_pred"]])
diffusion_results <- spirometry_extra_text(status_z_score(calc_z_score(df[["dlco"]], df[["dlco_lln"]], df[["dlco_pred"]])))

mmv <- df[["fev1"]] * 40
pred_VE <- print_predicted(calc_predicted(df[["VE"]], df[["VE_pred"]]))

pred_vo2 <- print_predicted(calc_predicted(df[["vo2_peak"]], df[["vo2_pred"]]))
status_vo2 <- status_vo2(df[["vo2_peak"]], df[["vo2_pred"]])
status_vo2_kg <- status_vo2_kg(df[["vo2_kg"]])
status_spo2_desat <- status_spo2_desat(calc_spo2_desat(df[["spo2_rest"]], df[["spo2_max"]]))

status_vt_response <- status_rr_response(df[["VTex_rest"]], df[["VTex_max"]])
status_rr_response <- status_rr_response(df[["rr_rest"]], df[["rr_max"]])
status_rer <- status_rer(df[["RER_max"]])

status_petco2 <- status_petco2(df[["PETCO2"]])
status_slope_veco2 <- status_slope_veco2(df[["slope_veco2"]])

per_hr_pred <- print_predicted(calc_predicted(df[["hr_peak"]], df[["hr_pred_peak"]]))

status_vo2 <- status_vo2(df[["vo2_peak"]], df[["vo2_pred"]])

status_gas_exchange_limitation <- status_gas_exchange_limitation(df[["spo2_rest"]], df[["spo2_max"]], df[["VeCO2_at"]], df[["dlco"]], df[["dlco_lln"]], df[["dlco_pred"]])

status_ventilatory_inefficiency <- status_ventilatory_inefficiency(df[["VeCO2_at"]], df[["PETCO2"]])

status_ventilatory_limitation <- status_ventilatory_limitation(df[["VE"]], df[["VE_pred"]])
status_ventilatory_response <- status_ventilatory_response(df[["rr_rest"]], df[["rr_max"]])

########################
# FUNCTION definitions #
########################

print_heading <- function(HEADING) {
  n_head <- nchar(HEADING)

  for(i in 1:n_head){
    cat(sprintf("="))
  }
  cat(sprintf("\n%s\n", HEADING))
  for(i in 1:n_head){
    cat(sprintf("="))
  }
  return(MESSAGE)
}

generate_demographics <- function(){
    cat(sprintf("The patient tolerated a maximum workload of %d Watts, exercising on a %s for a total of %d minutes while breathing ambient room air.",
    df[["max_workload"]],
    df[["mode_of_exercise"]],
    df[["exercise_duration"]]
  ))

  cat(sprintf("\n\nBMI:\t%d kg/m2", df[["bmi"]]))

  cat(sprintf(
    "\n\nMost recent hemoglobin:\t%d (date: %s)",
    df[["hgb"]],
    df[["hgb_date"]]
  ))

  cat(sprintf(
    "\n\nNegative chronotropic medications (per chart review):\t%s",
    df[["med_neg_inotrope"]]
  ))

  cat(sprintf(
      "\n\nBaseline spirometry is notable for a %s FVC and %s FEV1.",
      fvc_results,
      fev1_results
  ))

  cat(sprintf(
      "Overall impression of spirometry is %s.",
      spirometry_results
  ))

  cat(sprintf(
    "Diffusion capacity is %s.",
    diffusion_results
  ))
}

generate_ventilatory <- function(variables) {
  print_heading(head_vent_resp)

  cat(sprintf(
    "Maximum predicted minute ventilation (FEV1 of %d L x 40) is %d L/min. Achieved maximum minute ventilation was %d L/min, pred_VE of predicted.",
    df[["fev1"]],
    df[["mmv"]],
    df[["VE"]],
    df[["pred_VE"]]
  ))

  cat(sprintf(
    "Resting tidal volume was %d liters. This increased to %d liters at peak exercise, which is a %s response. Respiratory rate at rest was %d/min. This increased to %d/min at peak exercise, which is a %s response.",
    df[["VTex_rest"]],
    df[["VTex_max"]],
    status_vt_response,
    df[["rr_rest"]],
    df[["rr_max"]],
    status_rr_response
  ))

  cat(sprintf(
    "\n\nMaximum oxygen uptake (VO2) was %d L/min, which is %s of predicted. This indicates a %s. This is equal to %d mL/kg/min, suggesting %s.",
    df[["vo2_peak"]],
    pred_vo2,
    status_vo2,
    df[["vo2_kg"]],
    status_vo2_kg
  ))

  cat(sprintf("\n\nA clear VO2 plateau was {sjc.cpet.present.absent:50364}."))

  cat(sprintf(
    "\n\nOxygen saturation was %d%% at rest and %d%% at peak exercise; a significant desaturation (>3%%) was %s.",
    df[["spo2_rest"]],
    df[["spo2_max"]],
    status_spo2_desat
  ))
}

################
# MAIN program #
################


cat(sprintf(
  "RER at peak exercise was %d, reflecting %s test.",
  RER_max,
  status_rer
))



cat(sprintf(
  "Maximal PETCO2 was %d. VE/VCO2 slope was %d. VE/VCO2 slope was %d.",
  status_petco2,
  VE/VCO2,
  status_slope_veco2
))


{
print_heading(head_cir_resp)

  cat(sprintf(
    "Maximum predicted heart rate was %d/min. Heart rate with peak exercise was %d/min, which was %s of predicted.",
    df[["hr_pred_peak"]],
    df[["hr_peak"]],
    per_hr_pred
  ))
  

"The chronotropic index of `r round(calc_chronotropic_index(hr_peak, hr_rest, hr_pred_peak), digits = 2)` was `r status_chronotropic_index(calc_chronotropic_index(hr_peak, hr_rest, hr_pred_peak))`."

"Resting BP was `r sbp_rest`/`r dbp_rest`, which rose to `r sbp_peak`/`r dbp_peak` at peak exercise. Systolic blood pressure response is `r status_sbp_response(sbp_rest, sbp_peak)`. Diastolic blood pressure response is `r status_dbp_response(dbp_rest, dbp_peak)`."

"Anaerobic threshold was verified using the dual methods approach. Anaerobic threshold was achieved at VO2 that was `r status_anaerobic_threshold(is_vo2_at_abnormal(vo2_at, vo2_peak))` (VO2_AT / VO2_max = `r round(calc_predicted(vo2_at, vo2_peak), digits = 2)`, which is greater than or equal to 0.40)."

"Heart rate-VO2 pattern was {sjc.cpet.hrvo2.pattern:50372}. Oxygen pulse pattern showed {sjc.cpet.o2pulse.pattern:50373}. The maximum oxygen pulse was `r O2pulse_peak` ml/beat, which is `r print_predicted(calc_predicted(O2pulse_peak, O2pulse_pred))` of predicted, which is `r status_o2pulse(is_o2pulse_abnormal(calc_predicted(O2pulse_peak, O2pulse_pred)))`."
}

{
print_heading(head_interpretation)

"The patient's maximum VO2 was `r print_predicted(calc_predicted(vo2_peak, vo2_pred))` of predicted, which indicates `r status_vo2(vo2_peak, vo2_pred)`. The test was terminated due to `r reason_to_end`."

"The test was `r ifelse(is_test_adequate(vo2_at, vo2_peak, VE, VE_pred, spo2_rest, spo2_max, RER_max, hr_peak, hr_pred_peak), 'adequate', 'submaximal')`. This is based on `r status_test_adequate(vo2_at, vo2_peak, VE, VE_pred, spo2_rest, spo2_max, RER_max, hr_peak, hr_pred_peak)`."

cat(sprintf(
  "A ventilatory limitation to exercise was %s. The ventilatory response to exercise was %s.",
  status_ventilatory_limitation,
  status_ventilatory_response  
))



cat(sprintf(
  "A gas exchange limitation was %s. Evidence of inefficient ventilation was %s.",
  status_gas_exchange_limitation,
  status_ventilatory_inefficiency
))


status_vo2_at <- status_vo2_at(df[["vo2_at"]], df[["vo2_peak"]])

"A circulatory limitation to exercise was `r status_vo2_at(vo2_at, vo2_peak)`. The circulatory response to exercise was `r status_circulatory_response(is_o2pulse_abnormal(calc_predicted(O2pulse_peak, O2pulse_pred)), is_ci_abnormal(calc_chronotropic_index(hr_peak, hr_rest, hr_pred_peak)))`. The systolic blood pressure response was `r status_sbp_response(sbp_rest, sbp_peak)`. The diastolic blood pressure response was `r status_dbp_response(dbp_rest, dbp_peak)`. Clinical or ECG evidence of ischemia: `r ekg`."
}

generate_summary <- function()
{
  print_heading(head_sum)
  cat(sprintf(
    "Cardiopulmonary exercise testing showed %s.",
    status_vo2  
  ))
  
  cat(sprintf(
    "The primary exercise limitation was {sjc.cpet.limit.type:50384}. There was a secondary {sjc.cpet.limit.type:50384} limitation to exercise."    
  ))
}
