capture program drop theil
program define theil, rclass
syntax varlist(max=1) [if] [iweight]
quietly {
preserve
marksample touse
keep if `touse'==1
local wt : word 2 of `exp'
if "`wt'"=="" {
local wt = 1
}
summarize `varlist' [`weight'`exp']
local vmed= r(mean)
gen each = `varlist'/`vmed'*ln(`varlist'/`vmed') 
sum each [w=pondih]
local theil = (r(sum)/r(sum_w)) 
return scalar theil= `theil'
restore
}
display as text "Theil `varlist'=" as result %5.4f `theil'
end



