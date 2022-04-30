use "${orig}/BIBBBAuA_2018_suf1.0.dta", clear
dis "Auszählung für `1'"
tab S1 if m1202 == `1'

