library(stringr)

calc_z_score <- function(MEASURED, LLN, MEAN){
  Z_LLN <- -1.645
  SD <- (LLN - MEAN) / Z_LLN
  
  Z_MEASURED <- (MEASURED - MEAN) / SD
  
  return(Z_MEASURED)
}

spirometry_extra_text <- function(STATUS){
  if(STATUS != 'normal'){
    STATUS <- paste0(sprintf('%sly reduced', STATUS))
  }
  return(STATUS)
}


status_ve_response <- function(REST, MAX){
  result <- REST / MAX
  LLN <- 2
  ULN <- 3
  if(result >= LLN && result <= ULN){
    status <- 'normal'
  }
  else if(result < LLN){
    status <- 'blunted'
  }
  else if (result > ULN){
    status <- 'excessive'
  }
  return(status)
}

status_z_score <- function(Z){
  z_mild <- -1.65
  z_mod <- -2.50
  z_sev <- -4.1
  
  if(Z <= z_sev){
    status <- 'severe'
  }
  else if(Z > z_sev && Z <= z_mod){
    status <- 'moderate'
  }
  else if(Z > z_mod && Z <= z_mild){
    status <- 'mild'
  }
  else{
    status <- 'normal'
  }
  
  return(status)
}

calc_abnormality_present <- function(MEASURED, LLN, PRED){
  z <- calc_z_score(MEASURED, LLN, PRED)
  z_status <- status_z_score(z)
  if(z_status != 'normal'){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


status_spirometry <- function(FVC, FVC_LLN, FVC_PRED, FEV1, FEV1_LLN, FEV1_PRED, RATIO_LLN, RATIO_PRED){
  ratio <- FEV1/FVC
  status_restriction <- calc_abnormality_present(FVC, FVC_LLN, FVC_PRED)
  status_obstruction <- calc_abnormality_present(ratio, RATIO_LLN, RATIO_PRED)
  
  if(status_restriction == TRUE){
    z <- calc_z_score(FVC, FVC_LLN, FVC_PRED)
    status <- paste0(sprintf('%s restriction', status_z_score(z)))
  }
  else if(status_obstruction == TRUE){
    z <- calc_z_score(FEV1, FEV1_LLN, FEV1_PRED)
    status <- paste0(sprintf('%s restriction', status_z_score(z)))
  }
  else {
    status <- 'normal spirometry'
  }
  
  return(status)
}

is_hr_max_abnormal <- function(CALC_PRED_HR){
  if(CALC_PRED_HR >= 0.85){
    return(FALSE)
    }
  else if(CALC_PRED_HR < 0.85){
    return(TRUE)
    }
}

calc_chronotropic_index <- function(HR_PEAK, HR_REST, HR_PRED_PEAK) {
  return((HR_PEAK - HR_REST)/(HR_PRED_PEAK - HR_REST))
}

status_sbp_response <- function(SBP_REST, SBP_PEAK){
  if(SBP_PEAK >220){
    status <- 'excessive (SBP >220 mmHg), indicating a hypertensive response to exercise'
  }
  else if(SBP_PEAK < 130 || SBP_PEAK - SBP_REST < 10){
    status <- 'insufficient (SBP < 130 mmHg or decrease >10 mmHg with exercise), suggesting possible left heart dysfunction or ischemia'
  }
  else{
    status <- 'normal'
  }
  return(status)
}

status_dbp_response <- function(DBP_REST, DBP_PEAK){
  DBP_INCREASE <- DBP_PEAK - DBP_REST
  if(DBP_INCREASE <= 10){
    status <- 'normal (increase by 10 mmHg or less)'
  }
  if(DBP_INCREASE > 10 || DBP_PEAK > 100){
    status <- 'excessive (increased more than 10 mmHg, or above 90--100 mmHg)'
  }
  else{
    status <- 'normal'
  }
  return(status)
}

is_spo2_abnormal <- function(SPO2_REST, SPO2_MAX){
  spo2_diff <- abs(SPO2_REST - SPO2_MAX)
  if (spo2_diff >3){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

calc_spo2_desat <- function(SPO2_REST, SPO2_MAX){
  spo2_diff <- abs(SPO2_REST - SPO2_MAX)
  if (spo2_diff >3){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

status_spo2_desat <- function(spo2_diff){
  if (spo2_diff == TRUE){
    return('present')
  }
  else{
    return('absent')
  }
}

is_rer_abnormal <- function(RER){
  if(RER >= 1.1)
  {
    return(FALSE)
  }
  else if(RER <1.1){
    return(TRUE)
  }
}

status_rer <- function(RER){
  if(RER >= 1.1){
    return('an adequate')
  }
  else{
    return('a submaximal')
  }
}

is_vo2_at_abnormal <- function(VO2_AT, VO2_PEAK){
  vo2_at_threshold <- calc_predicted(VO2_AT, VO2_PEAK)
  
  if(vo2_at_threshold < 0.40){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

status_vo2_at <- function(vo2_at, vo2_peak){
  
  if(is_vo2_at_abnormal(vo2_at, vo2_peak) == TRUE){
    status <- 'present, based on reduced VO2 at anaerobic threshold'
  }
  else{
    status <- 'absent'
  }
  return(status)
}

status_vo2 <- function(VO2_MAX, VO2_PRED){
  result <- calc_predicted(VO2_MAX, VO2_PRED)
  normal_lln <- 0.80
  mild <- 0.60
  moderate <- 0.40
  supranormal <- 1.20
  
  if(result >= supranormal){
    status <- 'supranormal oxygen uptake (>120% predicted)'
  }
  else if(result < moderate){
    status <- 'severe aerobic impairement (<40% predicted)'
  }
  else if(result < mild && result >= moderate){
    status <- 'moderate aerobic impairement (40--59% predicted)'
  }
  else if(result >= mild && result < normal_lln){
    status <- 'mild aerobic impairement (60--79% predicted)'
  } 
  else{
    status <- 'normal exercise tolerance (80--119% predicted)'
  }
  
  return(status)
}

is_max_ve_abnormal <- function(CALC_PRED_VE){
  # high VE (>=0.85) indicates being limited by ability to ventilate
  if(CALC_PRED_VE >= 0.85){
    return(TRUE)
  }
  else if(CALC_PRED_VE < 0.85){
    return(FALSE)
  }
}

is_veco2_abnormal <- function(VeCO2_at){
  if (VeCO2_at >= 35.0) {
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

status_slope_veco2 <- function(slope_veco2){
  if(slope_veco2 >34){
    status <- 'elevated (>34)'
  }
  else{
    status <- 'normal'
  }
  return(status)
}

is_petco2_abnormal <- function(PETCO2){
  normal <- 35
  if(PETCO2 < normal){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}


status_petco2 <- function(PETCO2){
  normal <- 35
  mild <- 30
  moderate <- 25
  if (PETCO2 >= normal){
    status <- 'normal (35 mmHg or greater)'
  }
  else if (PETCO2 < moderate){
    status <- 'severely reduced (<25 mmHg)'
  }
  else if(PETCO2 >= moderate && PETCO2 < normal){
    if (PETCO2 < mild){
      status <- 'moderately reduced (25--30 mmHg)'
    }
    else if(PETCO2 >= mild){
      status <- 'mildly reduced (30--35 mmHg)'
    }
  }
  
  return(status)
}

status_vo2_kg <- function(VO2_KG){
  contraindicated <- 10
  increased_risk <- 15
  functional_limitation <- 25
  
  if(VO2_KG > functional_limitation){
    status <- 'low surgical risk (VO2 > 25 ml/kg/min)'
  }
  else if(VO2_KG <= functional_limitation){
    if(VO2_KG >= increased_risk){
      status <- 'functional limitation with low surgical risk (VO2 15--25 ml/kg/min)'
    }
    else if(VO2_KG >= contraindicated){
      status <- 'increased risk for surigcal procedures (VO2 10--15 ml/kg/min)'
    }
    else{
      status <- 'surgery is contraindicated (VO2 < 10 ml/kg/min)'
    }
  }
  
  return(status)
}

is_o2pulse_abnormal <- function(calc_predicted){
  if(calc_predicted < 0.8){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}

is_ci_abnormal <- function(CI){
  if(CI < 0.80 || CI > 1.3){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
}



status_chronotropic_index <- function(CI){
  normal_lln <- 0.8
  normal_uln <- 1.3
  if(CI >= normal_lln){
    if(CI <=normal_uln){
      status <- 'normal (0.8--1.3)'
    }
    if(CI >normal_uln){
      status <- 'elevated (>1.3), suggesting a steep heart rate response and reliance on heart rate to increase cardiac output'
    }
  }
  else if(CI < normal_lln){
    status <- 'reduced (<0.8), suggesting a blunted heart rate response'
  }
  return(status)
}

calc_predicted <- function(MEASURED, PREDICTED){
  RESULT <- MEASURED / PREDICTED
  return(RESULT)
}

print_predicted <- function(RESULT) {
  PERCENT <- paste0(sprintf('%.1f%%', RESULT * 100))
  return(PERCENT)
}

status_circulatory_response <- function(O2PULSE_ABNORMAL, CI_ABNORMAL){
  if(O2PULSE_ABNORMAL == TRUE){
    if(CI_ABNORMAL == TRUE){
      status <- 'abnormal, based on reduced maximum O2 pulse (<80% predicted) and based on an abnormal chronotropic index'
    }
    else if (CI_ABNORMAL == FALSE){
      status <- 'abnormal, based on reduced maximum O2 pulse (<80% predicted)'
    }
  }
  else if(O2PULSE_ABNORMAL == FALSE){
    if(CI_ABNORMAL == TRUE){
      status <- 'abnormal, based on an abnormal chronotropic index'
    }
    else if(O2PULSE_ABNORMAL == FALSE){
      status <- 'normal'
    }
  }
  
  return(status)
}

status_o2pulse <- function(is_o2pulse_abnormal){
  if(is_o2pulse_abnormal == FALSE){
    status <- 'normal (80% predicted or greater)'
  }
  else if (is_o2pulse_abnormal == TRUE){
    status <- 'reduced (<80% predicted)'
  }
  return(status)
}

status_anaerobic_threshold <- function(is_vo2_at_abnormal){
  if(is_vo2_at_abnormal == TRUE){
    status <- 'earlier than expected'
  }
  else{
    status <- 'within expected limits'
  }
  return(status)
}

is_test_adequate <- function(vo2_at, vo2_peak, VE, VE_pred, spo2_rest, spo2_max, RER_max, hr_peak, hr_pred_peak){
  # if any of these are normal (i.e., abnormal == FALSE), return test is adequate
  if(is_vo2_at_abnormal(vo2_at, vo2_peak) == FALSE || is_max_ve_abnormal(calc_predicted(VE, VE_pred)) == FALSE ||  is_spo2_abnormal(spo2_rest, spo2_max) == FALSE ||  is_rer_abnormal(RER_max) == FALSE || is_hr_max_abnormal(calc_predicted(hr_peak, hr_pred_peak)) == FALSE){
    return(TRUE)  
  }
  else{
    return(FALSE)
  }
}

concat_comma_list <- function(COUNTER, str_buffer, to_add){
  if(COUNTER <=1){
    str_buffer <- paste0(sprintf('%s', to_add))
  }
  else if (COUNTER >1) {
    str_buffer <- paste0(sprintf('%s, %s', str_buffer, to_add))
  }
  
  return(str_buffer)
}


status_test_adequate <- function(vo2_at, vo2_peak, VE, VE_pred, spo2_rest, spo2_max, RER_max, hr_peak, hr_pred_peak) {
  counter <- 0
  str_buffer <- ''
  
  # adequate test (TRUE) if VO2_at is normal (good effort), abnormal VE change, desat present,
  # RER is high (>1.1), or HR response is good (at least 85% predicted)
  if(is_vo2_at_abnormal(vo2_at, vo2_peak) == FALSE || is_max_ve_abnormal(calc_predicted(VE, VE_pred)) == TRUE ||  is_spo2_abnormal(spo2_rest, spo2_max) == TRUE ||  is_rer_abnormal(RER_max) == FALSE || is_hr_max_abnormal(calc_predicted(hr_peak, hr_pred_peak)) == FALSE){
    STATUS <- TRUE  
  }
  else{
    STATUS <- FALSE
  }

  if(STATUS == TRUE){
    if(is_vo2_at_abnormal(vo2_at, vo2_peak) == FALSE){
      to_add <- 'maxiumum VO2 of 80% predicted or greater'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(is_max_ve_abnormal(calc_predicted(VE, VE_pred)) == TRUE){
      to_add <- 'maximum minute ventilation (VE) 85% predicted or greater'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(is_spo2_abnormal(spo2_rest, spo2_max) == TRUE){
      to_add <- 'SaO2 decrease of 3% or greater during exercise'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(is_rer_abnormal(RER_max) == FALSE){
      to_add <- 'RER >1.10'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(is_hr_max_abnormal(calc_predicted(hr_peak, hr_pred_peak)) == FALSE){
      to_add <- 'maxiumum achieved heart rate 85% of predicted or greater'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
  }
  
  return(str_buffer)
}

print_test_adequacy <- function(vo2_at, vo2_peak, VE, VE_pred, spo2_rest, spo2_max, RER_max, hr_peak, hr_pred_peak){
  
}

status_ventilatory_limitation <- function(VE, VE_pred){
  if(is_max_ve_abnormal(calc_predicted(VE, VE_pred))){
    status <- 'present (maximum VE 85% of predicted or greater)'
    }
  else {
    status <- 'absent'
    }
  return(status)
}

status_ventilatory_response <- function(rr_rest, rr_max){
  counter <- 0
  str_buffer <- ''
  
  rr_increase <- rr_max / rr_rest
  if(rr_max < 25 || rr_increase < 2 || (rr_increase >5 || rr_max > 40)){
    if(rr_max < 25){
      to_add <- 'abnormal due to blunted respiratory rate response (< 25/min)'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(rr_increase < 2){
      to_add <- 'abnormal due to blunted tidal volume (increased to less than twice resting value)'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
    if(rr_increase >5 || rr_max > 40){
      to_add <- 'abnormal due to excessive respiratory rate response'
      counter <- counter + 1
      str_buffer <- concat_comma_list(counter, str_buffer, to_add)
    }
  }
  else {
    str_buffer <- 'normal'
  }

  return(str_buffer)
}

status_rr_response <- function(rr_rest, rr_max) {
  rr_multiplier <- rr_max / rr_rest
  min <- 2
  max <- 4
  if(rr_multiplier < min){
    status <- 'blunted'
  }
  else if(rr_multiplier >= min && rr_multiplier < max){
    status <- 'normal'
  }
  else if(rr_multiplier > max){
    status <- 'excessive'
  }
  return(status)
}

print_sigfig <- function(VALUE, SIGFIG){
  return(round(VALUE, digits = SIGFIG))

}

status_ventilatory_inefficiency <- function(VeCO2_at, PETCO2){
  counter <- 0
  str_buffer <- ''

  if(is_veco2_abnormal(VeCO2_at) == TRUE){
    to_add <- 'present based on elevated VE/VCO2 at AT (>35)'
    counter <- counter + 1
    str_buffer <- concat_comma_list(counter, str_buffer, to_add)
  }
  if(is_petco2_abnormal(PETCO2) == TRUE){
    to_add <- 'present based on reduced maximum PETCO2'
    counter <- counter + 1
    str_buffer <- concat_comma_list(counter, str_buffer, to_add)
  }
  
  if (is_petco2_abnormal(PETCO2) == FALSE && is_veco2_abnormal(VeCO2_at) == FALSE) {
    str_buffer <- 'absent'
  }
  return(str_buffer)
}

status_gas_exchange_limitation <- function(spo2_rest, spo2_max, VeCO2_at, dlco, dlco_lln, dlco_pred){
  if(is_spo2_abnormal(spo2_rest, spo2_max) == TRUE){
    if(is_veco2_abnormal(VeCO2_at) == TRUE){
      if(calc_abnormality_present(dlco, dlco_lln, dlco_pred) == TRUE){
        status <- 'present, based on a decrease in SaO2 by > 3%. Together with high VE/VCO2 at AT and decreased DLCO, this may suggest pulmonary vascular disease'
      }
      else {
        status <- 'present, based on a decrease in SaO2 by > 3%'
      }
    }
    else {
      status <- 'absent'
    }
  }
  else {
    status <- 'absent'
  }
  
  return(status)
}