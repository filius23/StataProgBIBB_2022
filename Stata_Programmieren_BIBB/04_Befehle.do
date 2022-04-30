* --------------------------------- *
* Programmieren mit Stata
* Kapitel 4: variablen labels & strings
* --------------------------------- *

clear all
input str60 add
"4905 Lakeway Drive, College Station, Texas 77845 USA"
"673 Jasmine Street, Los Angeles, CA 90024"
"2376 First street, San Diego, CA 90126"
"6 West Central St, Tempe AZ 80068"
"1234 Main St. Cambridge, MA 01238-1234"
"Robert-Schuman-Platz 3, 53175 Bonn GERMANY"
"Regensburger Straße 100, 90478 Nürnberg Germany"
"  Ammerländer Heerstraße 114-118, 26129 Oldenburg GERMANY  "
end


gen x1 = substr(add,5,10) 	//  substring von add -> Zeichen 5-10
gen x2 = wordcount(add) 	  // Worte zählen
gen x3 = word(add,5) 	  // 5. Wort
gen x4 = upper(add)			// alles groß
gen x5 = lower(add)     // alles klein
gen x6 = proper(add)    // jeweiles erster Buchstabe eines Wortes groß
gen x7 = trim(add)      // Leerzeichen am Ende und Beginn raus
gen x8 = strlen(add)    // Anzahl der Zeichen in add

list
drop x*


display proper("Regensburger Straße 100, 90478 nüRnberg germany")
display proper("Regensburger Straße 100, 90478 nüRnberg germany")
display proper("Regensburger Straße 100, 90478 nüRnberg germany")
display ustrtitle("Regensburger Straße 100, 90478 nüRnberg germany")

split add, parse(" ") gen(t)

* ---------------------------------
* real() vs destring
clear all

input str2 x1
"2"
"3"
"5"
"23"
"21"
"2"
"--"
"2"
end

gen num = real(x1)
list
destring(x1), gen(num2)



* ---------------------------------------------------------------------------------
* regex

clear all
input str60 add
"4905 Lakeway Drive, College Station, Texas 77845 USA"
"673 Jasmine Street, Los Angeles, CA 90024"
"2376 First street, San Diego, CA 90126"
"6 West Central St, Tempe AZ 80068"
"1234 Main St. Cambridge, MA 01238-1234"
"Robert-Schuman-Platz 3, 53175 Bonn GERMANY"
"Regensburger Straße 100, 90478 Nürnberg Germany"
"Ammerländer Heerstraße 114-118, 26129 Oldenburg GERMANY"
end

list
* ustrregexm -> 0/1, 1 wenn Treffer
gen d = ustrregexm(add, "GERMANY") 
list
gen d2 = ustrregexm(add, "GERMANY|Germany") // ODER
list
gen d3 = ustrregexm(add, "G(ERMANY|ermany)")
list

* irgendeine ZahL?
gen d4 = ustrregexm(add, "\d")
list

* ustrregexs --> extrahieren
gen d3 = ustrregexs(0) if ustrregexm(add, "GERMANY|Germany")
gen d4 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)")  // entspricht d3
gen d5 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)|USA")
list
drop d*

* ustrregexra --> ersetzen
gen s1 = ustrregexra(add, "street", "!")
gen s2 = ustrregexra(add, "[street]", "!")
list
drop s*
list

* gen s2 = ustrregexra(add, "regress", "")


* ersetzen mit regex-Regelausdrücken
cap drop z*
gen z1 =  ustrregexra(add, "\w", "") // alle alphanumeric raus
gen z2 = ustrregexra(add, "\W", "") // alle nicht-alphanumeric raus
gen z3 =  ustrregexra(add, "\d", "") // alle Zahlen raus 
gen z4 = ustrregexra(add, "\D", "") // alle nicht-Zahlen raus 
list

cap drop z*
gen z5 = ustrregexra(add, ".+,", "") // alles vor dem Komma raus
gen z6 = ustrregexra(add, ",.+", "") // alles nach dem Komma raus
list


* regex-Regeln
* Zahlen suchen
cap drop r* 
gen r1 = ustrregexs(0) if ustrregexm(add, "\d")	 // Zahl
gen r2 = ustrregexs(0) if ustrregexm(add, "\d+") // Zahlenfolge
gen r3 = ustrregexs(0) if ustrregexm(add, "(\d{5})") // 5-stellige Zahl
gen r4 = ustrregexs(0) if ustrregexm(add, "^(\d+)") // Zahlenfolge am Anfang
gen r5 = ustrregexs(0) if ustrregexm(add, "(\d+).*(\d+)") // Zahlenfolgen und alles was dazwischen kommt 
gen r6 = ustrregexs(0) if ustrregexm(r5, "(\d+)$") // Zahlenfolge am Ende -> aus r5!
list


* Suche/ersetze Funktion in regex
loc x = "das ist ein zweiter String"
dis ustrregexra("`x'", "ein", "EIN") 

* ---------------------------------------------------------------------------------
* label/Variablen bearbeiten

use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", replace 

tab m1202
d  m1202

* information abspeichern
loc v m1202
local vartype:     type `v' 		  // Variablen "storage type" (byte etc)
local varlab:      variable label `v' // variable label
local vallabname:  value label `v' 	  // Name des value label
local vallab1 :    label (`v') 1	  // Value label für Wert = 1

*anzeigen
di "`vartype'"     // display local "vartype"
di "`varlab'"      // display local "varlabel"
di "`vallabname'"  // display local "valuelabname"
di "`vallab1'"     // display local "valuelab1"


*direkt anzeigen
loc v m1202
di "`: type `v''" 			  // "storage type" (byte etc) der Variable
di "`: variable label `v''"  // variable label
di "`: value label `v''" 	 // Name des value label
di "`: label (`v') 1'" 		 // Value label für Wert = 1

* Variablenlabel abkürzen:
local longlabel: var label m1202       			// variable label für variable m1202 suchen
local shortlabel = substr("`longlabel'",1,10) 	// verändern mit string Funktion
label var m1202 "`shortlabel'"        			// anwenden

* value labels
local lblname: value label m1202	// value labels für variable m1202 suchen
cap label drop `lblname'_n			//neuen namen droppen zur Sicherheit
label copy `lblname' `lblname'_n	// value labelbook kopieren

* value label abrufen und verarbeiten
local lab1: label (m1202) 2 					// value label für Wert = 2 aufrufen
loc lab2 = upper("`lab1'")  					// dieses value labels verändern
label define `lblname'_n  2 "`lab2'", modify // in neues value labelbook einfügen
labelbook `lblname' `lblname'_n 				// vergleich alt vs neu


loc v m1202
local lblname: value label `v'       // value label aufrufen
cap label drop `lblname'_n           // neuen Namen zur Sicherheit droppen
label copy `lblname' `lblname'_n     // kopieren

levelsof `v', loc(x)                 // Werte für die Variable aufrufen
foreach lvl of local x {
	local lab1: label (`v') `lvl'     // Value label Variable v bei Level lvl
	loc lab2 = substr("`lab1'",1,8)         // kürzen
	label define `lblname'_n `lvl' "`lab2'", modify // im neuen value label ändern
  }
lab val `v' `lblname'_n             // anwenden

tab m1202

* --------------------------------------
* abgleiche -> existiert eine Variable oder hat sie eine bestimmte Eigenschaft
capture confirm  variable lm02
if !_rc dis "ja"
if _rc 	dis	"nein"


capture confirm numeric variable az
if !_rc dis "ja"
if _rc 	dis	"nein"


* wo kommt überall -4 vor?
quietly ds
local varlist1 `r(varlist)'
*display "`varlist1'"

foreach v of varlist1 {
  qui count if `v' == -4
  if r(N) > 0 display "`v'"
}

foreach v of varlist * {
  qui count if `v' == -4
  if r(N) > 0 display "`v'"
}


* -------------------------
* Anhang
ds, has(type byte)
loc bytevars `r(varlist)'
foreach v of local bytevars {
	rename `v' b_`v'
}

