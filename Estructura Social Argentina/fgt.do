capture program drop fgt
program define fgt, rclass
	syntax varlist(max=1) [iweight] [if], Alfa(real) Zeta(string)
	
	quietly {
		preserve
		marksample touse
		keep if `touse' == 1
		 
		tempvar each
		gen `each' = ( 1 - `varlist' / `zeta' ) ^ `alfa' if `varlist' < `zeta' 
		replace `each' = 0 if `each' == .
		summarize `each' [`weight'`exp'] 

		local fgt = (r(sum)/r(sum_w))*100
		restore
	}
	
	display as text "FGT (alfa=`alfa',Z=`zeta') = " as result %6.3f `fgt'
	return scalar fgt = `fgt'

end