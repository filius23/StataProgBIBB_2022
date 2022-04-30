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

global date = string( d($S_DATE), "%tdCY-N-D" )

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

adopath ++ ${prog}
which mdesc				

*erstelle doFile fuer macros -> kurzes doFile um Pfade in Schleifen richtig zu setzen, wird dann in Schleifen immer aufgerufen
file open macros using ${prog}\macrodofile.do, write replace
file write macros "glo pfad 	${pfad}   "		_n
file write macros "glo orig	  	${orig}   "		_n
file write macros "glo data	  	${data}   "		_n
file write macros "glo log		${log}    "		_n
file write macros "glo res		${results}"	    _n
file write macros "glo graph	${graph}  "		_n
file write macros "glo prog	  	${prog}   "		_n
file close macros 
								
di "$S_DATE $S_TIME"



* ----------------------------- *
* in neuer Session starten
cd ${prog}
winexec `c(sysdir_stata)'StataSE-64.exe do "${prog}/052_DoFile1.do"	4 2 mobil

* ----------------------------- *
* parallele Sessions starten
forvalues s = 1/2{
	cd ${prog}
	winexec `c(sysdir_stata)'StataSE-64.exe do "${prog}/052_DoFile1.do"	4 `s' mobil
}
