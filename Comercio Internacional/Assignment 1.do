clear all
set more off
capture cd "." // Put the path here <----

use "datos_bilateral"



/*QUESTION 2

2.1. Identify the three main trading partners for each country in the years 2000 and 2019, and detail the trade volume. Have there been any changes during this period? What connection do you see between these estimates and the material covered in the lectures? Create graphs.*/

* We sort by exporter, year, and trade volume in descending order
preserve
keep if year==2000 | year==2019
bysort year exporter_iso3 (trade): gen rank_imp= _n
bysort year exporter_iso3 (trade): replace rank_imp= _N - _n + 1
sort year exporter_iso3 rank_imp
export excel year exporter_iso3 importer_iso3 trade rank_imp using "1_Group9.xlsx", sheetmodify sheet("exporter") firstrow(variables)
restore

preserve
keep if year==2000 | year==2019
bysort year importer_iso3 (trade): gen rank_exp= _n
bysort year importer_iso3 (trade): replace rank_exp= _N - _n + 1
sort year importer_iso3 rank_exp
export excel year importer_iso3 exporter_iso3 trade rank_exp using "1_Group9.xlsx", sheetmodify sheet("importer") firstrow(variables)
restore

/*2.2. The study by Anderson and Van Wincoop (2003) is one of the first to evaluate the relationship between trade and country size. Conduct a regression analysis similar to the one in that study, explaining trade volume based on country size, distance, and whether the countries share a border. Analyze the results and how they differ depending on:
Whether the size variable is GDP or population—and what happens if it is GDP per capita?
Whether year and/or trade-relationship fixed effects are included in the regressions.
*/

gen ln_trade = log(trade)
gen ln_gdp_o = log(gdp_wdi_const_o)
gen ln_gdp_d = log(gdp_wdi_const_d)
gen ln_pop_o = log(pop_o)
gen ln_pop_d = log(pop_d)
gen ln_distance = log(distance)
gen pc_o = gdp_wdi_const_o / pop_o
gen pc_d = gdp_wdi_const_d / pop_d
gen ln_pc_o = log(pc_o)
gen ln_pc_d = log(pc_d)

* Regressions by size variable type
ssc install estout

* Using total GDP
reg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity
esttab using "Reg1.txt", replace
* Using the population
reg ln_trade ln_pop_o ln_pop_d ln_distance contiguity
esttab using "Reg2.txt", replace
* Using GDP per capita
reg ln_trade ln_pc_o ln_pc_d ln_distance contiguity
esttab using "Reg3.txt", replace

* Adding fixed effects

* Bilateral relationship fixed effects
xtset id_relacion year
* Using total GDP
xtreg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, fe
esttab using "Reg4.txt", replace
* Using the population
xtreg ln_trade ln_pop_o ln_pop_d ln_distance contiguity, fe
esttab using "Reg5.txt", replace
* Using GDP per capita
xtreg ln_trade ln_pc_o ln_pc_d ln_distance contiguity,fe
esttab using "Reg6.txt", replace

* Year fixed effects
* Using total GDP
areg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, absorb(year)
esttab using "Reg7.txt", replace
* Using the population
areg ln_trade ln_pop_o ln_pop_d ln_distance contiguity, absorb(year)
esttab using "Reg8.txt", replace
* Using GDP per capita
areg ln_trade ln_pc_o ln_pc_d ln_distance contiguity, absorb(year)
esttab using "Reg9.txt", replace

* Bilateral relationship and year fixed effects
ssc install reghdfe, replace
ssc install ftools, replace
eststo clear
* Using total GDP
reghdfe ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg10.txt", replace
* Using the population
reghdfe ln_trade ln_pop_o ln_pop_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg11.txt", replace
* Using GDP per capita
reghdfe ln_trade ln_pc_o ln_pc_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg12.txt", replace
