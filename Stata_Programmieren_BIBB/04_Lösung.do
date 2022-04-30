* --------------------------------- *
* Programmieren mit Stata
* Kapitel 4: string Funktionen und Variablen bearbeiten
* Lösung
* --------------------------------- *

* --------------------------------- *
* 1  Verwenden Sie mit `input` die Adressdaten von oben

clear
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


* Wie kommen Sie jeweils an das vorletztes Wort aus der Adressliste?
list
gen nword = wordcount(add) 	  // Worte zählen
gen vorletz = word(add,nword-1) 	  // vorletztes Wort
gen vorletz2 = word(add,wordcount(add)-1) 	  // vorletztes Wort
gen vorl2 = word(add,-2)  	  // Worte zählen
list

* Wie kommen Sie jeweils an das 10.letzte bis 4.letzte Zeichen in der Adressliste?
* replace add = trim(add)

gen len = strlen(add)
gen zehn = strlen(add)-10
gen vier = strlen(add)-3
gen zehndreiletzt = substr(add, zehn , vier)
list
gen zehndreiletzt2 = substr(add, strlen(add)-10, strlen(add)-3)
list

help substr


* --------------------------------- *
*2 Übung
* Laden Sie den regex.dta und teilen Sie die Informationen aus address in 4 Variablen auf: Hausnummer (erste Zahl), Straße, PLZ, Region
use "https://github.com/filius23/StataProgBIBB/raw/main/docs/regex1.dta", clear

* Wandeln Sie alle Einträge in Großbuchstaben um
replace address = upper(address)
list
* Verwenden Sie split, um zwischen Adresse und PLZ & Ort zu trennen
split address, parse(",") gen(a)
list
* Wie können Sie jetzt die Zahlen vom Text trennen?
gen plz = ustrregexs(0) if ustrregexm(a2, "(\d{4})") // 4-stellige Zahl
list 
gen region = ustrregexra(a2, "\d", "")
list
gen hsnr = ustrregexs(0) if ustrregexm(a1, "\d+") 
list
gen straße = ustrregexra(a1, "\d", "")
list

* Löschen Sie ggf. Leerzeichen zu Beginn und am Ende der Variablen
foreach v of varlist * {
	replace `v' = trim(`v')
}
list

* --------------------------------- *
*3 Übung
* Laden Sie der Erwerbstätigenbefragung

use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", replace 


* Kürzen die die variable labels für alle Variablen mit “wissensintensiver Beruf” im Label (d *wib*)
    * Ersetzen Sie “wissensintensiver Beruf” in den variable labels mit “wib.”
    * Spielen Sie die Routine erst für eine Variable durch: welche Label-Befehle brauchen Sie?
    * Denken Sie an foreach ... of varlist und die Möglichkeit, wildcards zu verwenden. Alternativ hilft evtl. auch ds mit Wildcards

d *wib* 
foreach v of varlist *wib* {
	local longlabel: var label `v'        // variable label für variable m1202 suchen
	local shortlabel = ustrregexra("`longlabel'","wissensintensiver Beruf","wib.") // verändern mit regex Funktion 
	label var `v' "`shortlabel'"         // anwenden
}
d *wib* 
	
* Bearbeiten Sie das value label für nuts2 - nutzen Sie dafür die regex und string-Funktionen von oben
* Löschen Sie “Statistische” aus den den value labels und ersetzen Sie “Direktionsbezirk” durch “Bezirk”
loc v nuts2 
local lblname: value label `v'       // value label aufrufen
cap label drop `lblname'_n           // neuen Namen zur Sicherheit droppen
label copy `lblname' `lblname'_n     // kopieren

levelsof `v', loc(x)                 // Werte für die Variable aufrufen
foreach lvl of local x {
    local lab1: label (`v') `lvl'     // Value label Variable v bei Level lvl
    loc lab2 = ustrregexra("`lab1'","Statistische","")
	loc lab2 = ustrregexra("`lab2'","Direktionsbezirk","Bezirk")
    label define `lblname'_n `lvl' "`lab2'", modify // im neuen value label ändern
  }
lab val `v' `lblname'_n             // anwenden
tab nuts2


* Kehren Sie die Codierung vom m1202 um: gen m1202_n = 10 - m1202 und passen Sie die value labels entsprechend an die neue Codierung an.
 * Tipp: auch die value labels müssen dann jeweils 10 - x genommen werden.

gen m1202_n = 10 - m1202
local lblname: value label m1202       // value label aufrufen
cap label drop `lblname'_n           // neuen Namen zur Sicherheit droppen
label copy `lblname' `lblname'_n     // kopieren

levelsof m1202, loc(x)                 // Werte für die Variable aufrufen
foreach lvl of local x {
    local lab1: label (m1202) `lvl'     // Value label Variable v bei Level lvl
	loc nlvl = 10 - `lvl'
    label define `lblname'_n `nlvl' "`lab1'", modify // im neuen value label ändern
  }
lab val m1202_n `lblname'_n             // anwenden
tab m1202_n
d  m1202_n
 
* Wie könnten Sie automatisiert den Variable label für die Muttersprachenvariablen kürzen, sodass statt “Muttersprache:” nur noch “MSpr” im label steht?
foreach v of varlist F1606_* {
	local longlabel: var label `v'        // variable label für variable m1202 suchen
	local shortlabel = ustrregexra("`longlabel'","Muttersprache:","MSpr") // verändern mit regex Funktion 
	label var `v' "`shortlabel'"         // anwenden
	}

d F1606_*	
	
* --------------------------------- *
*4 Übung

* In welchen Variablen aus der Erwerbstätigenbefragung kommt der der Wert -9 vor?
* Füttern Sie diese Information in mvdecode, um die Missings zu überschreiben.
* Sammeln Sie die Information, welche Variablen -9 enthalten (Stichwort rekursive macro-Definition)
* Erstellen Sie einen mvdecode-Befehle, welcher die Information aufnimmt und in allen gefundenen Variablen -9 durch . ersetzt.

glo min9 ""
foreach v of varlist * {
  qui count if `v' == -9
  if r(N) > 0 {
  	display "`v'"
	glo min9 ${min9} `v'
  }
}
mac l min9
mvdecode ${min9}, mv(-9)


