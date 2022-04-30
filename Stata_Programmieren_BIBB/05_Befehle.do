* --------------------------------- *
* Programmieren mit Stata
* Kapitel 5: Dateienverwaltung und DoFile-Organisation
* --------------------------------- *


* Dateien

glo pfad "D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\projekt"

global filelist: dir "${pfad}" files "*.*"			//Lister aller Dateien
mac l filelist

global dtalist: dir "${pfad}" files "data*.dta" // Liste aller .dta-Dateien
mac l dtalist


	loc usefile `: word 1 of ${dtalist}' 				// erster Eintrag aus der Liste
	dis "${pfad}/`usefile'"
	
	use "${pfad}/`usefile'", clear 						// dta laden
	loc n_datasets : list sizeof global(dtalist)		// anzahl weiterer listen
	foreach i of numlist 2(1)`n_datasets' {
		loc appendfile `: word `i' of ${dtalist}'		// name aus list aufrufen
		append using "${pfad}/`appendfile'"				// append
		dis "`appendfile' appended"						// show it worked
	}
	
	
	

	
* csv files einlesen:
global csvlist: dir "${pfad}" files "data*.csv" // Liste aller .dta-Dateien
mac l csvlist
	
	loc n_csvs : list sizeof global(csvlist)		// anzahl weiterer listen
	foreach i of numlist 1(1)`n_csvs' {
	loc usefile `: word `i' of ${csvlist}' 				// erster Eintrag aus der Liste
	import delimited "${pfad}/`usefile'", delimiter(";") encoding(ISO-8859-2) clear
	
	loc savef = ustrregexra("`usefile'","csv","dta")
	save "${pfad}/`savef'", replace
	
	dis "`savef' saved"						// show it worked
	}
	
* ---------------------------------- *
* copy 
global dtalist: dir "${pfad}" files "data*.dta" // Liste aller .dta-Dateien
mac l dtalist

loc usefile `: word 1 of ${dtalist}' 				// erster Eintrag aus der Liste
loc copyfile "copy_`usefile'"
dis "`usefile'"
dis "`copyfile'"

copy ${pfad}/`usefile' ${pfad}/`copyfile' , replace

// hat das geklappt?
global dtalist2: dir "${pfad}" files "data*.dta" // Liste aller .dta-Dateien
mac l dtalist
mac l dtalist2


* ---------------------------------- *
* erase
loc usefile `: word 1 of ${dtalist}' 				// erster Eintrag aus der Liste
loc copyfile "copy_`usefile'"
erase ${pfad}/`copyfile'

// hat auch das geklappt?
global dtalist3: dir "${pfad}" files "data*.dta" // Liste aller .dta-Dateien
mac l dtalist
mac l dtalist2
mac l dtalist3

* ------------ * 
glo pfad "D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\projekt"
mkdir "${pfad}/test"


