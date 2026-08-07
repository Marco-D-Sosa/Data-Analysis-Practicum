capture program drop gini
program define gini, rclass
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
local average=r(mean)
local obs=r(sum_w)
sort `varlist'
tempvar each i aux
gen `aux'=sum(`wt')
gen `i'=(2*`aux'-`wt'+1)/2
gen `each'=`varlist'*(`obs'-`i'+1)
summ `each' [`weight'`exp']
local gini=1+(1/`obs') - (2/(`average'*`obs'^2)) * r(sum)
return scalar gini= `gini'
restore
}
display as text "Gini `varlist'=" as result %5.4f `gini'
end
