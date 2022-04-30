* Master DoFile
cap log close
clear all
mac list
set trace off
clear matrix
clear mata

set more off,perm
set scrollbufsize 500000
set maxvar 32000, perm
set matsize 11000, perm
set linesize 250
set varabbrev off
prog drop _allado

estimates clear

* ------------------------------ *
* Pfade setzen
glo pfad 		"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\projekt"		// projekt
glo orig		"${pfad}/orig"		// wo liegen die original Datensätze?
glo data		"${pfad}/data"		// wo liegen die fertigen Datensätze?
glo log			"${pfad}/log"		// Ordner fuer log Files
glo res			"${pfad}/results"	// Ergebnisse -> Tabellen mit Koeffizienten, ORs usw.
glo graph		"${pfad}/graph"		// Graphiken
glo prog		"${pfad}/prog"		// wo liegen die doFiles?


* ----------------------------- *
*  Ordner erstellen wenn nicht bereits vorhanden
foreach dir1 in orig data log res graph	prog {
	capture cd 	"${`dir1'}"
	if _rc!=0  {
		mkdir ${`dir1'}
		display "${`dir1'} erstellt"
	}
 }

cd ${pfad}

* ----------------------------- *
* Ein Argument mitgeben
do "${prog}/051_DoFile.do"	1


* ----------------------------- *
* mit log-File
global date = string( d($S_DATE), "%tdCY-N-D" )

forvalues d = 1/4 {
	log using "${log}/01_m1202_`d'_${date}.log", replace text
	dis "Start: $S_DATE um $S_TIME"
	
	do "${prog}/051_DoFile.do"	`d'
	
	dis "Ende: $S_DATE um $S_TIME"
	cap log close
}	

* ----------------------------- *
* Mehrere Argumente mitgeben
* 1 - ausbildung
* 2 - geschlecht
* 3 - variable auf die tab angewendet wird
do "${prog}/051_DoFile2.do"	4 2 mobil



