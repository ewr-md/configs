def calc_tau(Vt, F, PIP, Pplt, PEEPtotal):
    tau = ((Vt / 1_000) / (F/60)) * ((PIP - Pplt) / (Pplt - PEEPtotal))
    return tau

def calc_max_RR(tau):
    max_RR = 60 / (3 * tau)
    return max_RR


tau = calc_tau(500, 60, 20, 10, 5)
max_RR = calc_max_RR(tau)

print("Tau:\t", tau, "\n3 Tau:\t", 3*tau, "\nMin RR:\t", max_RR) 
