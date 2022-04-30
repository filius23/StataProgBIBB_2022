local ausb `1'
local gend `2'
local var  `3'
do macrodofile.do
global date = string( d($S_DATE), "%tdCY-N-D" )

log using "${log}/052_auswertung_ausb`ausb'_gend`gend'_var`var'_${date}.log", replace text

loc sleeptime = 1000*30
sleep `sleeptime'

use "${orig}/BIBBBAuA_2018_suf1.0.dta", clear
dis "Auszählung für Ausbildung = `ausb' & Geschlecht = `gend'"
tab gkpol if m1202 == `ausb' & S1 == `gend'

tab gkpol `var' if m1202 == `ausb' & S1 == `gend'

cap log close master
clear
exit, STATA clear