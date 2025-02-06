#########################################
#  Print specified significant figures  #
#########################################
print_sigfigs <- function(sigFigs, dataVar){
  sprintf("%#.*f", as.numeric(sigFigs), as.numeric(dataVar))
}


##################################
#  Handler for p value printing  #
##################################
check_pvalue_sigfigs <- function(arg_pvalue){
  #cutoff values to decide sigfigs
  pvalue_cutoff_high <- 0.01
  pvalue_cutoff_medium <- 0.005
  pvalue_cutoff_low <- 0.001
  
  pvalue_sigfigs_high <- 2
  pvalue_sigfigs_medium <- 2

  if(arg_pvalue >= pvalue_cutoff_high){
    myReturn <- paste(print_sigfigs(pvalue_sigfigs_high, arg_pvalue))
  } 
  else if(arg_pvalue < pvalue_cutoff_high & arg_pvalue >= pvalue_cutoff_medium){
    myReturn <-  paste(print_sigfigs(pvalue_sigfigs_medium, arg_pvalue))
  }
  else if(arg_pvalue < pvalue_cutoff_medium & arg_pvalue> pvalue_cutoff_low){
    myReturn <- "<0.01"
  }
  else if(arg_pvalue<= pvalue_cutoff_low){
    myReturn <- "<0.001"
  }
  return(myReturn)
}

######################################
#  Handler for printing percentages  #
######################################

#function to calculate percentage
calc_percent <- function(num, total){
  percentage <- (num/total) * 100
  return(percentage)
}

#func to print percentage, using func:sigfigs_percent
print_percent <- function(arg, numTotal, sigFigs){
  paste0(print_sigfigs(sigFigs, calc_percent(arg, numTotal)), "%")
  }

########################################
#  Handler to calculate and print ORs  #
########################################

#func: calculates OR
calc_oddsratio <- function(outcome, comparator){
  oddsRatio <- outcome/comparator
  return(oddsRatio)
}

#func: print OR from calcuated value from calc_oddsratio
print_oddsratio <- function(sigs, outcome, comparator){
  paste0("OR ", print_sigfigs(sigs, calc_oddsratio(outcome, comparator)))
}

##############################
#  Handler for printing CIs  #
##############################
# Normal version
print_confint_brackets <- function(sigs, lowerCI, upperCI){
  paste0("95% CI [", print_sigfigs(sigs, lowerCI), ", ", print_sigfigs(sigs, upperCI), "]")
}

#Shortened version
print_confint_short <- function(sigs, lowerCI, upperCI){
  paste0(" [", print_sigfigs(sigs, lowerCI), ", ", print_sigfigs(sigs, upperCI), "]")
}

# Percentage version
print_confint_percent <- function(sigs, lowerCI, upperCI){
  paste0("95% CI ", print_sigfigs(sigs, lowerCI), "--", print_sigfigs(sigs, upperCI), "%")
}
