* --------------------------------- *
* Programmieren mit Stata
* Kapitel 3: regressionsergebnisse weiterverarbeiten
* Lösungen
* --------------------------------- *

use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", replace 


* --------------------------------- *
* 1 Erstellen Sie folgendes Regressionsmodell:

reg az i.mig01 zpalter
ereturn list

* Erstellen Sie jeweils einen `display`-Befehl, der den Koeffizienten und Standardfehler für `S1` und `zpalter` mit einer Aussagekräftigen Nachricht ausgibt
dis "Der Koeffizient für mig01=1 ist " _b[1.mig01]
dis "Der Standardfehler des Koeffizienten für mig01=1 ist " _se[1.mig01]
dis "Der Koeffizient für zpalter ist " _b[zpalter]
dis "Der Standardfehler des Koeffizienten für zpalter ist " _se[zpalter]

* Wie würde das als Schleife aussehen?
foreach c in "1.mig01" zpalter {
	dis "Der Koeffizient für `c'  ist " _b[`c']
	dis "Der Standardfehler des Koeffizienten für  `c'  ist " _se[`c']    
}

* Extrahieren Sie die Regressionstabelle als `matrix` und legen sie diese als `frame` ab.
return list
mat R = r(table)'
mat l R

cap frame drop regres1
xsvmat R,  names(col) rownames(coef) frame(regres1)
frame change regres1
list, noobs clean

* Erstellen Sie zusätzlich eine Spalte mit dem Regressionsbefehl.

gen mod = "`e(cmdline)'"
list, noobs clean
frame change default
cap frame drop regres1

* --------------------------------- *
* 2 Bauen Sie folgendes Modell Schritt für Schritt auf und lassen Sie sich die Tabelle mit `esttab` ausgeben:

est clear
glo mod1 i.S1 zpalter c.zpalter#c.zpalter i.gkpol i.F1604 i.F1604##i.S1
qui regress az ${mod1}
gen smpl2 = e(sample)

local len2: word count ${mod1}
forvalues i = 1(1)`len2' {
    loc word: word `i' of ${mod1}
    dis "Modell Nr" `i' ": mit `word'"
	loc x `x' `word'
	qui reg az `x' if smpl2 == 1
	est store m`i'
}

est dir
esttab m*
