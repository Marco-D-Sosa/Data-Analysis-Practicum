cd ""  // Put the path here <----

use benin.dta, clear
*ssc install moremata, replace
*ssc install bidensity



* This dataset includes results regarding the welfare effects of tariff elimination, calculated in the paper "Trading-off the income gains and the inequality costs of trade policy" (Journal of International Economics). Specifically, the exercise posits the elimination of all tariffs on all products and calculates the effects on prices, followed by the effects on expenditures and income.

* Adjust the scale to match that of the slides
replace welfare_effect_net = welfare_effect_net * 100
label variable lpce0 "log per capita expenditure"
label variable welfare_effect_net "welfare effects"

* Calculate the densities and polynomials
bidensity welfare_effect_net lpce0 [aw=weight], level(15) saving("bidensity_BEN.dta", replace) mname(BEN)
getmata BEN_x, force
lpoly welfare_effect_net lpce0 [aw=weight], at(BEN_x) nosc generate(BEN_s) se(BEN_se)
drop if missing(BEN_x)
sort BEN_x
ge BEN_05 = BEN_s - 1.96*BEN_se
ge BEN_95 = BEN_s + 1.96*BEN_se
save "lpoly_BEN.dta", replace

* Prepare the database for the chart
use "bidensity_BEN.dta", clear
rename _lpce0 BEN_x
sort BEN_x
merge m:1 BEN_x using "lpoly_BEN.dta"
drop _merge
sort _welf BEN_x

* Graphic
twoway (contourline _d _welf BEN_x, colorlines scolor(ltblue) ecolor(blue) levels(15) clegend(off) plegend(off)) ///
       (line BEN_s BEN_x, sort lcolor(red) lwidth(medthick)) ///
       (line BEN_05 BEN_x, sort lcolor(red) lpattern(shortdash) lwidth(medthin)) ///
       (line BEN_95 BEN_x, sort lcolor(red) lpattern(shortdash) lwidth(medthin)), ///
       graphregion(color(white)) bgcolor(white) plotregion(fcolor(white)) ///
       ylabel(-15(5)10, nogrid) yline(0, lcolor(black) lstyle(vvthin)) ///
       scheme(s1color) ytitle("welfare effects") xtitle("log per capita expenditure") legend(off)

graph export "BEN_unequal.pdf", as(pdf) replace


* 2° graphic
use "benin.dta", clear
tempname memhold
postfile `memhold' epsilon g_epsilon using "tradeoff_simple.dta", replace

forvalues e = 0(0.5)10 {
    
    tempvar sw_weight
    quietly gen `sw_weight' = weight * (yreal0^(-`e'))
    quietly mean welfare_effect_net [iw=`sw_weight']
    matrix b = e(b)
    post `memhold' (`e') (b[1,1] * 100)
    
    drop `sw_weight'
}

postclose `memhold'

use "tradeoff_simple.dta", clear
twoway (line g_epsilon epsilon, lcolor(red) lwidth(thick)), ///
       yline(0, lcolor(black) lwidth(thin)) ///
       ylabel(-6(2)4, angle(0) nogrid) ///
       xlabel(0(2)10) ///
       xtitle("inequality aversion, {&epsilon}") ///
       ytitle("inequality adjusted gains, G({&epsilon})") ///
       title("average income gains with increasing inequality costs", size(medium) pos(11)) ///
       graphregion(color(white)) bgcolor(white) ///
       legend(off)

graph export "TO_Atkinson.pdf", as(pdf) replace
