* --------------------------------- *
* Programmieren mit Stata
* Kapitel 1: macros & locals 
* Lösungen
* --------------------------------- *



* --------------------------------- *
* 1 
loc x = 4
glo y = 1+5
loc y 1+5
dis `x' * `y'

glo t1 "Hallo"
glo t2 " zusammen"
glo t3 "! :-)"

glo t4 = "${t1},${t2}${t3}"
dis "${t4}"

* --------------------------------- *
* 2 -> siehe init.do
global allS: all globals "S*"
mac l allS 

* --------------------------------- *
* 3 FizzBuzz

forvalues n = 1/30 {
	if  mod(`n',3)  == 0 & mod(`n',5)  == 0 {  
		dis "FizzBuzz" 
	}
	else if mod(`n',3) == 0 {
		dis "Fizz"
	} 
	else if mod(`n',5) == 0 {
		dis "Buzz"
	} 
	else {
		dis `n'
	}
	
}


* --------------------------------- *
* 4
foreach n of numlist 1(1)5 {
    dis "`n'"
    if "`ferest()'" != ""  dis "Es kommen noch: `ferest()'"
	if "`ferest()'" == ""  dis "Fertig"
}




