** Ejercicio 2 **
cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"
use "DataJobID - Ej2", replace

*Ajusto la base
sort Year ProductCode
rename TradeValuein1000USD trade_value
rename Year year

*Comparar las exportaciones e importaciones totales en los períodos 2018-2019 y 2021-2022*
mat EI = J(4, 1, .)
*Expos e impos totales 2018-2019
total trade_value if (year==2018 | year==2019) & TradeFlowCode==6
mat EI[1,1] = 4964845
total trade_value if (year==2018 | year==2019) & TradeFlowCode==5
mat EI[2,1] = 4346055
*Expos e impos totales 2021-2022
total trade_value if (year==2021 | year==2022) & TradeFlowCode==6
mat EI[3,1] = 5781777
total trade_value if (year==2021 | year==2022) & TradeFlowCode==5
mat EI[4,1] = 4095146
*exporto los datos 
preserve
   drop _all
   svmat EI
   export excel using "Comparacion_expoimpo.xlsx", sheetmodify sheet("Ejercicio2") cell(B2)
restore

*Identificar los 5 productos más afectados a una desagregación de 2 dígitos del Sistema Armonizado, tanto en términos del monto exportado como importado*

*Para exportaciones
preserve
gen periodo = .
replace periodo = 1 if inrange(year, 2018, 2019)
replace periodo = 2 if inrange(year, 2021, 2022)
keep if TradeFlowCode == 6 & inlist(periodo, 1, 2)
collapse (sum) trade_value, by(ProductCode periodo)
reshape wide trade_value, i(ProductCode) j(periodo)

gen caida_abs = trade_value2 - trade_value1
sort caida_abs
list ProductCode trade_value1 trade_value2 caida_abs in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value1 trade_value2 caida_abs using "productos_top5_caida.xlsx" if top5, sheet("caidas_expo") firstrow(variables) sheetreplace
restore

*Para importaciones
preserve
gen periodo = .
replace periodo = 1 if inrange(year, 2018, 2019)
replace periodo = 2 if inrange(year, 2021, 2022)
keep if TradeFlowCode == 5 & inlist(periodo, 1, 2)
collapse (sum) trade_value, by(ProductCode periodo)
reshape wide trade_value, i(ProductCode) j(periodo)

gen caida_abs = trade_value2 - trade_value1
sort caida_abs
list ProductCode trade_value1 trade_value2 caida_abs in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value1 trade_value2 caida_abs using "productos_top5_caida.xlsx" if top5, sheet("caidas_impo") firstrow(variables) sheetreplace
restore

clear all


*** Ejercicio 3 ***
cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"
use "DataJobID - Ej3", replace
rename TradeValuein1000USD trade_value

*5 productos mas exportados totales
preserve
keep if PartnerName == 1
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_expo.xlsx" if top5, sheet("totales") firstrow(variables) sheetreplace
restore

*5 productos mas exportados a inglaterra
preserve
keep if PartnerName == 2
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_expo.xlsx" if top5, sheet("Inglaterra") firstrow(variables) sheetreplace
restore

mat E3 = J(2,1,.)
*total de exportaciones 
total trade_value if PartnerName==1
mat E3[1,1] = 619000000
*total de exportaciones a inglaterra
total trade_value if PartnerName==2
mat E3[2,1] = 3141741
*exporto
preserve
   drop _all
   svmat E3
   export excel using "top5_expo.xlsx", sheetmodify sheet("Totales expo") cell(B2)
restore

clear all


**** Ejercicio 4 ****
cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"
use "DataJobID - Ej4", replace
rename TradeValuein1000USD trade_value

*5 productos mas importados totales
preserve
keep if PartnerName == 1
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_impo.xlsx" if top5, sheet("totales") firstrow(variables) sheetreplace
restore

*5 productos mas importados a inglaterra
preserve
keep if PartnerName == 2
collapse (sum) trade_value, by(ProductCode)
gsort -trade_value
list ProductCode trade_value in 1/5, clean
gen top5 = _n <= 5
export excel ProductCode trade_value using "top5_impo.xlsx" if top5, sheet("Inglaterra") firstrow(variables) sheetreplace
restore

mat E4 = J(2,1,.)
*total de importaciones 
total trade_value if PartnerName==1
mat E4[1,1] = 626000000
*total de importaciones a inglaterra
total trade_value if PartnerName==2
mat E4[2,1] = 2706281
*exporto
preserve
   drop _all
   svmat E4
   export excel using "top5_impo.xlsx", sheetmodify sheet("Totales impo") cell(B2)
restore

clear all


***** Ejercicio 5 *****
cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"
use "DataJobID - Ej5", replace
rename TradeValuein1000USD trade_value

*10 principales socios de exportacion
preserve
keep if TradeFlowCode == 6
collapse (sum) trade_value, by (PartnerName)
gsort -trade_value
list PartnerName trade_value in 1/10, clean
gen top10 = _n <= 10
export excel PartnerName trade_value using "top10_paises.xlsx" if top10, sheet("expos") firstrow(variables) sheetreplace
*posicion de UK
gen rank_export = _n
list PartnerName trade_value rank_export if PartnerName==206
restore

*10 principales socios de importacion
preserve
keep if TradeFlowCode == 5
collapse (sum) trade_value, by (PartnerName)
gsort -trade_value
list PartnerName trade_value in 1/10, clean
gen top10 = _n <= 10
export excel PartnerName trade_value using "top10_paises.xlsx" if top10, sheet("impos") firstrow(variables) sheetreplace
*posicion de UK
gen rank_import = _n
list PartnerName trade_value rank_import if PartnerName==206
restore

mat E5 = J(2,1,.)
*expos totales
total trade_value if TradeFlowCode==6
mat E5[1,1] = 619000000
*impos totales
total trade_value if TradeFlowCode==5
mat E5[2,1] = 626000000
*exporto
preserve
   drop _all
   svmat E5
   export excel using "top10_paises.xlsx", sheetmodify sheet("Totales") cell(B2)
restore

clear all


****** Ejercicio 6 ******
cd "C:\Users\HP\Downloads\TP Internacional\Bases_datos"

*indice VCR por producto
use "DataJobID - Ej6Productos", replace
rename TradeValuein1000USD trade_value
collapse (sum) trade_value, by(ReporterName ProductCode)
reshape wide trade_value, i(ProductCode) j(ReporterName)
egen total_mundo = total(trade_value1)
egen total_mexico = total(trade_value2)
gen vcr = (trade_value2 / total_mexico) / (trade_value1 / total_mundo)
gsort -vcr
list ProductCode trade_value2 trade_value1 vcr if trade_value2 > 0 & trade_value1 > 0, clean noobs
export excel ProductCode vcr using "vcr.xlsx", sheet("productos") firstrow(variables) sheetreplace

*indice VCR por grupo
use "DataJobID - Ej6Grupos", replace
rename TradeValuein1000USD trade_value
collapse (sum) trade_value, by(ReporterName ProductCode)
reshape wide trade_value, i(ProductCode) j(ReporterName)
egen total_mundo = total(trade_value1)
egen total_mexico = total(trade_value2)
gen vcr = (trade_value2 / total_mexico) / (trade_value1 / total_mundo)
gsort -vcr
list ProductCode trade_value2 trade_value1 vcr if trade_value2 > 0 & trade_value1 > 0, clean noobs
export excel ProductCode vcr using "vcr.xlsx", sheet("Grupos") firstrow(variables) sheetreplace

