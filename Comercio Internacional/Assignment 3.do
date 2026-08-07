cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"  // Put the path here <----



**** Exercise 2 ****
use "DataJobID - Ej2", replace

* Adjust the base
sort Year ProductCode
rename TradeValuein1000USD trade_value
rename Year year

* Compare total exports and imports for the 2018–2019 and 2021–2022 periods
mat EI = J(4, 1, .)
* Total exports and imports 2018–2019
total trade_value if (year==2018 | year==2019) & TradeFlowCode==6
mat EI[1,1] = 4964845
total trade_value if (year==2018 | year==2019) & TradeFlowCode==5
mat EI[2,1] = 4346055
* Total exports and imports 2021–2022
total trade_value if (year==2021 | year==2022) & TradeFlowCode==6
mat EI[3,1] = 5781777
total trade_value if (year==2021 | year==2022) & TradeFlowCode==5
mat EI[4,1] = 4095146
* export the data
preserve
   drop _all
   svmat EI
   export excel using "Comparison_expoimpo.xlsx", sheetmodify sheet("Exercise2") cell(B2)
restore

* Identify the five products most affected at the 2-digit level of the Harmonized System, in terms of both export and import values

* For exports
preserve
gen period = .
replace period = 1 if inrange(year, 2018, 2019)
replace period = 2 if inrange(year, 2021, 2022)
keep if TradeFlowCode == 6 & inlist(period, 1, 2)
collapse (sum) trade_value, by(ProductCode period)
reshape wide trade_value, i(ProductCode) j(period)
gen abs_fall = trade_value2 - trade_value1
sort abs_fall
list ProductCode trade_value1 trade_value2 abs_fall in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value1 trade_value2 abs_fall using "top_5_loss_products.xlsx" if top5, sheet("falls_expo") firstrow(variables) sheetreplace
restore

* Para importaciones
preserve
gen period = .
replace period = 1 if inrange(year, 2018, 2019)
replace period = 2 if inrange(year, 2021, 2022)
keep if TradeFlowCode == 5 & inlist(period, 1, 2)
collapse (sum) trade_value, by(ProductCode period)
reshape wide trade_value, i(ProductCode) j(period)
gen abs_fall = trade_value2 - trade_value1
sort abs_fall
list ProductCode trade_value1 trade_value2 abs_fall in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value1 trade_value2 abs_fall using "top_5_loss_products.xlsx" if top5, sheet("falls_impo") firstrow(variables) sheetreplace
restore

clear all



**** Exercise 3 ****
use "DataJobID - Ej3", replace
rename TradeValuein1000USD trade_value

* Top 5 total exported products
preserve
keep if PartnerName == 1
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_expo.xlsx" if top5, sheet("totals") firstrow(variables) sheetreplace
restore

* 5 most exported products to England
preserve
keep if PartnerName == 2
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_expo.xlsx" if top5, sheet("England") firstrow(variables) sheetreplace
restore

mat E3 = J(2,1,.)
* total exports 
total trade_value if PartnerName==1
mat E3[1,1] = 619000000
* total exports to England
total trade_value if PartnerName==2
mat E3[2,1] = 3141741
* export
preserve
   drop _all
   svmat E3
   export excel using "top5_expo.xlsx", sheetmodify sheet("Totals expo") cell(B2)
restore

clear all



**** Exercise 4 ****
use "DataJobID - Ej4", replace
rename TradeValuein1000USD trade_value

* Top 5 most imported products (total)
preserve
keep if PartnerName == 1
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_impo.xlsx" if top5, sheet("totals") firstrow(variables) sheetreplace
restore

* The 5 most imported products into England
preserve
keep if PartnerName == 2
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_impo.xlsx" if top5, sheet("England") firstrow(variables) sheetreplace
restore

mat E4 = J(2,1,.)
* total imports 
total trade_value if PartnerName==1
mat E4[1,1] = 626000000
* Total imports to England
total trade_value if PartnerName==2
mat E4[2,1] = 2706281
* export
preserve
   drop _all
   svmat E4
   export excel using "top5_impo.xlsx", sheetmodify sheet("Totals impo") cell(B2)
restore

clear all



**** Exercise 5 ****
use "DataJobID - Ej5", replace
rename TradeValuein1000USD trade_value

* Top 10 export partners
preserve
keep if TradeFlowCode == 6
collapse (sum) trade_value, by (PartnerName)
gsort -trade_value
list PartnerName trade_value in 1/10, clean
gen top10 = _n <= 10
export excel PartnerName trade_value using "top10_countries.xlsx" if top10, sheet("expos") firstrow(variables) sheetreplace
* UK position
gen rank_export = _n
list PartnerName trade_value rank_export if PartnerName==206
restore

* Top 10 import partners
preserve
keep if TradeFlowCode == 5
collapse (sum) trade_value, by (PartnerName)
gsort -trade_value
list PartnerName trade_value in 1/10, clean
gen top10 = _n <= 10
export excel PartnerName trade_value using "top10_countries.xlsx" if top10, sheet("impos") firstrow(variables) sheetreplace
* UK position
gen rank_import = _n
list PartnerName trade_value rank_import if PartnerName==206
restore

mat E5 = J(2,1,.)
* total expos
total trade_value if TradeFlowCode==6
mat E5[1,1] = 619000000
* total impos
total trade_value if TradeFlowCode==5
mat E5[2,1] = 626000000
* export
preserve
   drop _all
   svmat E5
   export excel using "top10_countries.xlsx", sheetmodify sheet("Totals") cell(B2)
restore

clear all



**** Ejercicio 6 ****

* VCR index by product
use "DataJobID - Ej6Productos", replace
rename TradeValuein1000USD trade_value
collapse (sum) trade_value, by(ReporterName ProductCode)
reshape wide trade_value, i(ProductCode) j(ReporterName)
egen total_mundo = total(trade_value1)
egen total_mexico = total(trade_value2)
gen vcr = (trade_value2 / total_mexico) / (trade_value1 / total_mundo)
gsort -vcr
list ProductCode trade_value2 trade_value1 vcr if trade_value2 > 0 & trade_value1 > 0, clean noobs
export excel ProductCode vcr using "vcr.xlsx", sheet("products") firstrow(variables) sheetreplace

* VCR index by group
use "DataJobID - Ej6Grupos", replace
rename TradeValuein1000USD trade_value
collapse (sum) trade_value, by(ReporterName ProductCode)
reshape wide trade_value, i(ProductCode) j(ReporterName)
egen total_mundo = total(trade_value1)
egen total_mexico = total(trade_value2)
gen vcr = (trade_value2 / total_mexico) / (trade_value1 / total_mundo)
gsort -vcr
list ProductCode trade_value2 trade_value1 vcr if trade_value2 > 0 & trade_value1 > 0, clean noobs
export excel ProductCode vcr using "vcr.xlsx", sheet("Groups") firstrow(variables) sheetreplace
