capture cd ""  // Put the path here <----

use ajrrev.dta, clear
*ssc install estout, replace



*Figure 1
twoway (scatter loggdp urb1500, mlabel(shortnam) mlabcolor(black) msymbol(none) mlabposition(0)) ///
       (lfit loggdp urb1500, lcolor(black) lwidth(medthin)), ///
       ytitle("Log GDP per capita, PPP, 1995") xtitle("Urbanization in 1500") ///
       legend(off) ///
       ylabel(7(1)10, angle(horizontal)) xlabel(0(5)20) ///
       plotregion(margin(medium)) graphregion(color(white))	   
graph export "figura1_reversal.png", as(png) width(1600) height(1200) replace


*Figure 2 
gen lpd1500 = ln(pd1500)
twoway (scatter loggdp lpd1500, mlabel(shortnam) mlabcolor(black) msymbol(none) mlabposition(0)) ///
       (lfit loggdp lpd1500, lcolor(black) lwidth(medthin)), ///
       ytitle("Log GDP per capita, PPP, 1995") xtitle("Log Population Density in 1500") ///
       legend(off) ///
       ylabel(6(1)10, angle(horizontal)) xlabel(-5(1)5) ///
       plotregion(margin(medium)) graphregion(color(white))	   
graph export "figura2_reversal.png", as(png) width(1600) height(1200) replace


* Figures 3 and 4: We don't have urbanization data for 1995 or time-series data


*Table 3

* Create the "america" ​​dummy variable by summing Latin America (laam_bl) and the codes for the USA and CAN
gen america = 0
replace america = 1 if laam_bl == 1 | shortnam == "USA" | shortnam == "CAN"

* Column (1): Base sample
eststo col1: reg loggdp urb1500

* Column (2): Without North Africa
eststo col2: reg loggdp urb1500 if nafrica == 0

* Column (3): Without the Americas
eststo col3: reg loggdp urb1500 if america == 0

* Column (4): Just the Americas
eststo col4: reg loggdp urb1500 if america == 1

* Column (5): With continent dummies
eststo col5: reg loggdp urb1500 asia africa america

* Column (6): Without neo-Europes
eststo col6: reg loggdp urb1500 if neoeuro == 0

* Column (7): Controlling for latitude
eststo col7: reg loggdp urb1500 latitude

* Column (8): Controlling for climate (Parcial: solo temp y lluvia)
eststo col8: reg loggdp urb1500 meantemp rainmin

* Column (10): Controlling for colonial origin (Parcial: solo UK y FR)
eststo col10: reg loggdp urb1500 col_fr col_uk

* This command generates the table with the exact format of the paper:
* coefficients at the top, standard errors in parentheses below, without significance asterisks, including R-squared and the number of observations
esttab col1 col2 col3 col4 col5 col6 col7 col8 col10 using "table3_reversal.rtf", ///
    b(3) se(3) nostar ///
    keep(urb1500 asia africa america latitude meantemp rainmin col_fr col_uk) ///
    order(urb1500 asia africa america latitude meantemp rainmin col_fr col_uk) ///
    title("Table III: Urbanization in 1500 and GDP per Capita") ///
    mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(10)") ///
    stats(r2 N, fmt(2 0) labels("R2" "Number of observations")) ///
    onecell replace


* Table 5
eststo clear

* Column (1): Base sample
eststo col1: reg loggdp lpd1500

* Column (2): Without Africa
eststo col2: reg loggdp lpd1500 if africa == 0

* Column (3): Without the Americas
eststo col3: reg loggdp lpd1500 if america == 0

* Column (4): Just the Americas
eststo col4: reg loggdp lpd1500 if america == 1

* Column (5): With continent dummies
eststo col5: reg loggdp lpd1500 asia africa america

* Column (6): Without neo-Europes
eststo col6: reg loggdp lpd1500 if neoeuro == 0

* Column (7): Controlling for latitude
eststo col7: reg loggdp lpd1500 latitude

* Column (8): Controlling for climate (Parcial)
eststo col8: reg loggdp lpd1500 meantemp rainmin

* Column (10): Controlling for colonial origin (Parcial)
eststo col10: reg loggdp lpd1500 col_fr col_uk

esttab col1 col2 col3 col4 col5 col6 col7 col8 col10 using "table5_panelA.rtf", ///
    b(3) se(3) nostar ///
    keep(lpd1500 asia africa america latitude meantemp rainmin col_fr col_uk) ///
    order(lpd1500 asia africa america latitude meantemp rainmin col_fr col_uk) ///
    title("Table V (Panel A): Population Density and GDP per Capita") ///
    mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(10)") ///
    stats(r2 N, fmt(2 0) labels("R2" "Number of observations")) ///
    onecell replace
