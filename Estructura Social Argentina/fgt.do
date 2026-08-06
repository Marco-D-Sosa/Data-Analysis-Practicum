capture program drop fgt
program define fgt, rclass
	* defino la sintaxis del programa
	syntax varlist(max=1) [iweight] [if], Alfa(real) Zeta(string)
	
	* todo lo que está entre estas llaves no se muestra en pantalla
	quietly {
		preserve
		marksample touse
		keep if `touse' == 1
		 
		tempvar each
		* varlist es la variable que el usuario ingresa
		* zeta y alfa son los parametros que el usuario ingresa
		gen `each' = ( 1 - `varlist' / `zeta' ) ^ `alfa' if `varlist' < `zeta' 
		replace `each' = 0 if `each' == .
		summarize `each' [`weight'`exp'] 

		local fgt = (r(sum)/r(sum_w))*100
		restore
	}
	
	display as text "FGT (alfa=`alfa',Z=`zeta') = " as result %6.3f `fgt'
	* lo guardo en r(fgt)
	return scalar fgt = `fgt'

end