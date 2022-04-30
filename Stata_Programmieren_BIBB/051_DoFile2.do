local ausb `1'
local gend `2'
local var  `3'

use "${orig}/BIBBBAuA_2018_suf1.0.dta", clear
dis "Auszählung für Ausbildung = `ausb' & Geschlecht = `gend'"
tab gkpol if m1202 == `ausb' & S1 == `gend'

tab gkpol `var' if m1202 == `ausb' & S1 == `gend'