* --------------------------------- *
* Programmieren mit Stata
* Kapitel 2
* --------------------------------- *


* einlesen
use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", clear

* --------------------------------- *
* levelsof: Schleife automatisch erstellen
tab m1202
levelsof m1202
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	dis "m1202: " `lvl'
}

levelsof m1202, loc(ausb)
glo ausb `ausb'
mac l ausb

foreach lvl  of global ausb {
	dis "m1202: " `lvl'
}


foreach lvl  of global ausb {
	dis "m1202: " `lvl'
	tab S1 if m1202 == `lvl'
}

* --------------------------------- *
* strings und macros

* Wort nr# extrahieren
local phrase `" "2 guys" "1 girl" "1 pizza place" "'
mac l _phrase
di "`:word 1 of `phrase' '"

* WÖRTER zählen
local sentence "here is a sentence 7"
local len: word count `sentence'
mac list _len

* beides zu einer schleife
local phrase1 "here is a sentence of 7 words"
local len1: word count `phrase1'

forvalues i = 1(1)`len1' {
    loc word: word `i' of `phrase1'
    dis "this is word number " `i' ": `word'"
}

* Anführungszeichen machen einen Unterschied:
local phrase2 `" "here is" "a sentence" "of 7 words" "'
mac l _phrase2 // hier sind die Worte in "" gruppiert!
local len2: word count `phrase2'
forvalues i = 1(1)`len2' {
    loc word: word `i' of `phrase2'
    dis "this is word number " `i' ": `word'"
}


* --------------------------------- *
* return & ereturn
tab S1
return list
su S1, detail
return list

reg F518_SUF zpalter
ereturn list

* e() und r() sind getrennte Welten
reg az F200
su az
ereturn list



su S1
dis "Der Mittelwert beträgt: " r(mean)
dis "Der Mittelwert beträgt: " round(r(mean),.01)


gen S01 = S1-1
foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	dis "Der Frauenanteil in m1202=" `lvl' " beträgt: " round(r(mean)*100,.1) "%"
}

return list
dis  r(sum) / 3
dis  r(Var) / 3
tab m1202
return list

* rekursive Verwendung von globals
global x ""
forvalues i = 1/20 {
	global x $x `i'
	dis "${x}"
}
mac list x


glo gend ""
foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	glo gend: display "${gend}m1202=" `lvl' " " round(r(mean)*100,.1) "% "
}
mac l gend


* --------------------------------- *
* Ergebnisse speichern mit matrizen
matrix Y1 = 1, 3 
mat l Y1
matrix Y2 = 4\ 0
mat l Y2

matrix X2 = (1, 2, 3 \ 5 , 8 , 9)
mat l X2 
mat X3 = X2'
mat l X3

mat G0 = J(4,2,0)
mat l G0

* colname
mat colname G0 = var1 var2
mat list G0

* rowname
mat rowname G0 = year result
mat list G0

mat rowname G0 = year result1 result2 result3
mat list G0

* --------------------------------- *
* ergebnisse in einer matrix sammeln
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	qui su S01 if m1202 == `lvl'
	
	// 1. Spalte level von m1202
	//2.Spalte: Frauenanteil
	mat GX`lvl' = `lvl' ,r(mean)*100 
}
mat dir
mat G = GX1\GX2\GX3\GX4
mat l GX1
mat l G
mat colname G = m1202 share_w
mat l G

* --------------------------------- *
* mehrere Werte
clear matrix
mat dir
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	qui su zpalter if m1202 == `lvl', det
	mat A`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75)
}
mat dir
mat l A4
mat A = A1\A2\A3\A4
mat colname A = m1202 p25 mean median p75
mat l A

* ----------------------------------------------- *
* Labels behalten  
tab m1202
labelbook M1202

loc v m1202
local vallab1 :    label (`v') 1		 	// Value label für Wert = 1
dis "`vallab1'"     // display local "valuelab1"

mat M = c(2\"label") // Fehler: nur Zahlen in matrix ablegbar

loc lvl = 1
qui su zpalter if m1202 == `lvl', det
mat GX = `lvl', r(p25), r(mean), r(p50), r(p75)
local vallab1 :    label (m1202) `lvl' // label aufrufen
mat rowname GX =  "`vallab1'" // in Zeilenname ablegen
mat l GX

* rowname um labels zu speichern
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75)
	
	local vallab1 :    label (m1202) `lvl'
	mat rowname GX`lvl' =  "`vallab1'"
}
mat G = GX1\GX2\GX3\GX4
mat colname G = m1202 p25 mean median p75
mat l G

* -------------------------------- *
* matrix zu Datensatz
*help svmat

ssc install  xsvmat
* frame 
xsvmat G, names(col) rownames(lab) frame(res1) // erstellt frame res1



frame dir
frame change res1 // in den res1-frame
frame change default
frame dir

list , noobs clean

frame change default // wieder zurück



