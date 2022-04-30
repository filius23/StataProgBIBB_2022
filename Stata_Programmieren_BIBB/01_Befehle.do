* --------------------------------- *
* Programmieren mit Stata
* Kapitel 1: macros & locals 
* --------------------------------- *

* global und locals definieren:
global xg = 1
local xl = 2

dis ${xg}
dis `xl'


glo x = 1
loc y = 2
mac list x
mac list _y

* geht, aber ist nicht zu empfehlen:
glo yx = 1
loc yx = 2
mac list yx
mac list _yx


* achtung bei Rechnungen:
local m1   2+2
local m2 = 2+2
display `m1'
display `m2'
mac list _m1 _m2

display `m1' * 3
display `m2' * 3


* auch bei globals
global gm1 2+2
global gm2 = 2+2
display $gm1
display $gm2
display "$gm1"
display "$gm2"

mac list gm1 gm2

display $gm1 *3
display $gm2 *3 

display "2 text 6"
display 2 text 6


* ------------ 
* text in macros
glo t1 "Hallo"
glo t2 " zusammen"
glo t3 "! :-)"

glo t4 = "${t1}${t2}${t3}"
 
dis "${t4}"


glo pfad "D:\Projekt\daten\BIBB_BAuA" // wo liegt der Datensatz?
use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes


* --------------------------------------------------------------------------
* Dateipfade erstellen 

glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?
glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
glo prog "${pfad}/prog"
glo data "${pfad}/data"
glo log  "${pfad}/log"

mac l pfad prog data log
use "${data}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes

* mkdir erstellt ein Verzeichnis:
mkdir ${log}
* Mit `cap cd` können wir das vorher überprüfen:
capture cd 	"${log}"
	if _rc!=0  {
		mkdir ${log}
		display "${log} erstellt"
	} 

* ----------------- 
* vordefinierte macros
mac list

dis "$S_DATE"
dis "$S_TIME"

log using "${log}/logfile.txt", text replace
*log using "${log}/logfile.txt", text replace


dis "Start: $S_DATE um $S_TIME"
* Hier kommen aufwändige Modelle
dis "Ende: $S_DATE um $S_TIME"
cap log close

* log file benennen
global date = string( d($S_DATE), "%tdCY-N-D" )
* help datetime_display_formats // für andere Datumsformate

mac l date

cap log close
log using "${log}/01_macro_loops_${date}.log", replace text
log close 


dis "`c(username)'"
dis "`c(machine_type)'"
dis "`c(os)'"


* ---------------------------
* if-Bedingungen

if ("`c(username)'" == "Filser")  display "Du bist Filser"
if ("`c(username)'" != "Fischer") display "Du bist nicht Fischer"

if ("`c(username)'" == "Alex")   glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
if ("`c(username)'" == "Micha")  glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?

glo prog "${pfad}/prog"
glo data "${pfad}/data"
glo log  "${pfad}/log"
use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes


loc x = 20
if `x' >= 20 & `x' <= 30 display "& yes"
if inrange(`x',20,30) display "inrange yes"

loc x = 19
if inrange(`x',20,30) display "yes"

loc x = 20
if `x' == 18 | `x' == 20 | `x' == 22 | `x' == 28 display "| yes"
if inlist(`x',18,20,22,28) display "inlist yes"

* ---------------------------
* macros also variablennamen und befehle
local n 200
su F`n'


loc t tab
`t' mobil

loc opt ja
if inlist(`opt',"ja","JA","Ja","ok") tab mobil

loc opt ja
if inlist("`opt'","ja","JA","Ja","ok") tab mobil

* -------------------------------------
* globals durchsuchen
glo x1 = 2
glo x2 "das ist x2"
glo x 291

global allglo:  all globals "x*"
global allglo2: all globals "x?"

mac l allglo2 allglo

glo  d 2+2
glo d2: display 2+2

mac list d d2

* --------------------------------------------------------------------------
* if und else
loc n = 2

if `n'==1 {
	local word "one"
     }
else if `n'==2 {
	local word "two"
}
else if `n'==3 {
	local word "three"
}
else {
	local word "big"
}

display "`word'"


* Pfad mit if/else zusammenbauen

if "`c(username)'" == "Alex" {
  glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
	}
else if "`c(username)'" == "Micha" {
  glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?
}
else {
 display as error "Hier fehlt der passende Pfad"
 exit
}
tab mobil


tab S1 if zpalter <= 19
tab S1 if zpalter <= 24
tab S1 if zpalter <= 29

* --------------------------------------------------------
* Schleifen

foreach v of numlist 19(5)29 {
	display "Alter bis `v'"
	tab S1 if zpalter <= `v'
}


foreach lname listtype list {

  Befehle

}


*foreach lname in any_list {
*foreach lname of local    local      {
*foreach lname of global   global     {
*foreach lname of varlist  variablen  { //auch Wildcards möglich - analog zu d F2**
*foreach lname of newlist  newvarlist { //wenn variablen erst generiert werden
*foreach lname of numlist  numlist    {

* vllt seltenere(?) numlist:
foreach n of numlist 1/3 6(1)9  {
    dis "`n'"
}

foreach n of numlist 6 4: -4  {
    dis "`n'"
}

* -------------------------------------
* ferest
foreach n of numlist 1(1)5 {
    dis "`n'"
    dis "Es kommen noch: `ferest()' "

}

`ferest()' == ""

* -------------------------------------
* weitere schleifentypen
forvalues d = 0(2)8 {
	dis "`d'"
}

loc i = 1
while `i' <= 5 {
  display "`i'"
  loc i = `i' + 1
}

* ++i
loc i = 1
while `i' <= 5 {
  display "`i'"
  loc ++i
}


* -------------------------------------
* Anwendung
qui use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", clear
foreach v of numlist 19(5)35 {
	display "Alter bis `v'"
	tab S1 if zpalter <= `v'
}

foreach v of numlist 19(5)35 {
	display "Alter " `v' - 4 " bis " `v'
 	tab S1 if inrange(zpalter,`v'-4, `v')
}




* -------------------------------------
*  Schleifen aufbauen
loc n = 5
if trunc(`n'/2) == `n'/2 display "ja"
if trunc(`n'/2) != `n'/2 display "nein"



dis mod(4,2)

forvalues n = 1/10 {
	if  mod(`n',2)  == 0 dis "`n' ist gerade"
	if  mod(`n',2)  >  0  dis "`n' ist ungerade"
}


forvalues n = 1/10 {
	if  mod(`n',2)  == 0 {  
		dis "`n' ist gerade" 
	}
	else if mod(`n',2)  > 0 {
		dis "`n' ist ungerade"
	}
}

* -------------------------------------
* nested loop
set trace on
foreach x of numlist 1(1)5 {
	foreach y of numlist 6(1)10 {
	dis "y=`y' und x = `x'"
	}
}
set trace off

* -------------------------------------
* display vs macro list
global labormarket LABOUR
display "${labormarket}"
display "${labourmarket}"
mac list labormarket
mac list labourmarket


