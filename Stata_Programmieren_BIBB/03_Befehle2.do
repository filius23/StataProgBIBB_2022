* -------------------------- *
* Programmieren mit Stata
* Kapitel 3: Anhang
* Mehrere Modelle in frame schicken

frame change default

local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local r = 1 // Zähler 
loc uv 		// uv rücksetzen (zur sicherheit)
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
	mat D = r(table)'						// reg-tabelle transponieren & speichern 
	mat D2 = D[rownumb(D,"2.S1"),1...]		// Koeffizient für S1=2 behalten
	
	if (`r' == 1) mat R = D2 				// im ersten Durchlauf R erstellen
	if (`r' != 1) mat R = R\D2 				// danach: D2 an R anfügen
		
	loc ++r // Zähler + 1
}
mat l R // wie wissen wir jetzt, für was kontrolliert wurde?

// -> e(cmdline) mit aufzeichnen 
return list

local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local r = 1 // Zähler 
loc uv 		// uv rücksetzen (zur sicherheit)
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
	mat D = r(table)'						// reg-tabelle transponieren & speichern 
	mat D2 = D[rownumb(D,"2.S1"),1...]		// Koeffizient für S1=2 behalten
	
	mat M = `r'
	mat colname M = mod
	
	if (`r' == 1) mat R = D2 , M			// ,r -> zähler an Koeffizientzeile anfügen
	if (`r' != 1) mat R = R\(D2 , M)
	glo cmd`r' = "`e(cmdline)'"
	loc ++r // Zähler + 1
}
mat l R 

cap frame drop rmods
xsvmat R,  names(col) rownames(coef) frame(rmods)
frame change rmods

list, noobs clean

* ---------------------------------------------- *
* labeln aus globals

mac list
global allglo:  all globals "cmd*" // alle globals mit cmd.. suchen
mac l allglo // gefundene globals
mac l cmd1 

levelsof mod, loc(mnrs)
foreach m of local mnrs {
	lab def mod_lab `m' "${cmd`m'}", modify
}
lab val mod mod_lab

list, noobs clean

/*
glo export_dir 	"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\docs"
compress
save "${export_dir}/reg_results.dta", replace
*/

* beispielgrafik
graph twoway ///
	(rcap ll ul mod,horizontal lcolor("57 65 101") ) /// Konfidenzintervalle
	(scatter mod b,  mcolor("177 147 74") )  , /// Punktschätzer
	graphregion(fcolor(white)) /// Hintergundfarbe (außerhalb des eigentlichen Plots)
	ylabel(, valuelabel angle(0) labsize(tiny)) ///
	legend(off) ///
	xtitle("Einkommen (W) vs. Einkommen (M)") /// Achsentitel
	ytitle("") /// 
	title("Titel")  ///
	subtitle("Untertitel") ///
	caption("{it:Quelle: Erwerbstätigenbefragung 2018}", size(8pt) position(5) ring(5) )
	
graph export "${graph}/Regplot.png", replace /// speichern png-Datei