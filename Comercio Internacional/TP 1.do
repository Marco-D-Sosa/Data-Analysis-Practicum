clear all
set more off
capture cd "C:\"
capture cd "C:\"
capture cd "C:\Users\HP\Downloads\TP1 - Internacional"
capture cd "C:\Users\renat\OneDrive\Escritorio\Eco. internacional\TP1"
use "datos_bilateral"



/*PREGUNTA 2

2.1. Especificar tres principales socios comerciales de cada país en los años 2000 y 2019, detallar volumen de comercio. ¿existen cambios en ese periodo?¿qué relación se le ocurre entre estas estimaciones y lo visto en clases teóricas? Realizar gráficos */

*Ordenamos por exportador, año y volumen de comercio en orden descendente
keep if year==2000 | year==2019
bysort year exporter_iso3 (trade): gen rank_imp= _n
bysort year exporter_iso3 (trade): replace rank_imp= _N - _n + 1
sort year exporter_iso3 rank_imp
export excel year exporter_iso3 importer_iso3 trade rank_imp using "TP1_Grupo9.xlsx", sheetmodify sheet("exporter") firstrow(variables)

use "datos_bilateral", clear

keep if year==2000 | year==2019
bysort year importer_iso3 (trade): gen rank_exp= _n
bysort year importer_iso3 (trade): replace rank_exp= _N - _n + 1
sort year importer_iso3 rank_exp
export excel year importer_iso3 exporter_iso3 trade rank_exp using "TP1_Grupo9.xlsx", sheetmodify sheet("importer") firstrow(variables)


/*2.2. El trabajo de Anderson y Van Wincoop (2003) es uno de los primeros en evaluar la relación entre comercio y tamaño de los países. Realizar un análisis de regresión similar al de ese trabajo que explique el volumen de comercio por el tamaño de los países, la distancia y el hecho de ser limítrofes. Analice los resultados y cómo son diferentes estos dependiendo de:
Si es el PBI o la población de los países la variable de tamaño, ¿y si es el PBI per cápita?
Si se incluyen efectos fijos por año y/o relación comercial en las regresiones
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


*Regresiones por tipo de variable de tamaño
ssc install estout

*Usando PBI total
reg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity
esttab using "Reg1.txt", replace
*Usando la población
reg ln_trade ln_pop_o ln_pop_d ln_distance contiguity
esttab using "Reg2.txt", replace
*Usando el PBI per cápita
reg ln_trade ln_pc_o ln_pc_d ln_distance contiguity
esttab using "Reg3.txt", replace

*Agregando efectos fijos

*Efectos fijos por relación bilateral
xtset id_relacion year
*Usando PBI total
xtreg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, fe
esttab using "Reg4.txt", replace
*Usando la población
xtreg ln_trade ln_pop_o ln_pop_d ln_distance contiguity, fe
esttab using "Reg5.txt", replace
*Usando el PBI per cápita
xtreg ln_trade ln_pc_o ln_pc_d ln_distance contiguity,fe
esttab using "Reg6.txt", replace

*Efectos fijos por año
*Usando PBI total
areg ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, absorb(year)
esttab using "Reg7.txt", replace
*Usando la población
areg ln_trade ln_pop_o ln_pop_d ln_distance contiguity, absorb(year)
esttab using "Reg8.txt", replace
*Usando el PBI per cápita
areg ln_trade ln_pc_o ln_pc_d ln_distance contiguity, absorb(year)
esttab using "Reg9.txt", replace

*Efectos fijos por relación bilateral y año
ssc install reghdfe, replace
ssc install ftools, replace
eststo clear
*Usando PBI total
reghdfe ln_trade ln_gdp_o ln_gdp_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg10.txt", replace
*Usando la población
reghdfe ln_trade ln_pop_o ln_pop_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg11.txt", replace
*Usando el PBI per cápita
reghdfe ln_trade ln_pc_o ln_pc_d ln_distance contiguity, absorb(id_relacion year)
esttab using "Reg12.txt", replace
