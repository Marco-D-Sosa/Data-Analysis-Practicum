capture cd "C:\Users\HP\Downloads\TP3 - Espacial"
capture cd ""
capture cd ""
capture cd ""
use "base_properati", clear



*********************************************
****************** Parte A ******************
*********************************************
ssc install geodist
ssc install outreg2

* Subte
merge m:1 id_merge using "coord_subtes_wide"
drop _merge
forvalues i = 1/90 {
	geodist lat lon lat_subte`i' long_subte`i', gen(distancia_subte`i')
} 
egen dist_lineal_min_subte = rowmin(distancia_subte*)
drop lat_subte*
drop long_subte*
drop distancia_subte*
save "Properati_distancias", replace

* Cines
merge m:1 id_merge using "coord_cines_wide"
drop _merge
forvalues i = 1/22 {
	geodist lat lon lat_cine`i' long_cine`i', gen(distancia_cine`i')
} 
egen dist_lineal_min_cine = rowmin(distancia_cine*)
drop lat_cine*
drop long_cine*
drop distancia_cine*
save "Properati_distancias", replace

* Bares
merge m:1 id_merge using "coord_bares_wide"
drop _merge
forvalues i = 1/248 {
	geodist lat lon lat_bar`i' long_bar`i', gen(distancia_bar`i')
} 
egen dist_lineal_min_bar = rowmin(distancia_bar*)
drop lat_bar*
drop long_bar*
drop distancia_bar*
save "Properati_distancias", replace

* Regresion del modelo
use "Properati_distancias", clear
local estructura "rooms bathrooms surface_total"
local locacion "dist_lineal_min_bar dist_lineal_min_cine dist_lineal_min_subte"
regress price `estructura' `locacion', robust
outreg2 using "Reg_niv.txt", replace

gen lprice = ln(price)
regress lprice `estructura' `locacion', robust
outreg2 using "Reg_log.txt", replace



*********************************************
****************** Parte B ******************
*********************************************
use "Properati_distancias", clear

* Residuos
merge m:1 id_merge using "coord_residuos_wide"
drop _merge
forvalues i = 1/139 {
	geodist lat lon lat_residuos_`i' long_residuos_`i', gen(distancia_residuos`i')
} 
egen dist_lineal_min_residuos = rowmin(distancia_residuos*)
drop lat_residuos*
drop long_residuos*
drop distancia_residuos*
save "Properati_distancias", replace

* Espacios verdes
merge m:1 id_merge using "coord_espverde_wide"
drop _merge
forvalues i = 1/102 {
	geodist lat lon lat_espverde`i' long_espverde`i', gen(distancia_espverde`i')
} 
egen dist_lineal_min_espverde = rowmin(distancia_espverde*)
drop lat_espverde*
drop long_espverde*
drop distancia_espverde*
save "Properati_distancias", replace

*Techos
merge m:1 id_merge using "coord_techos_wide"
drop _merge
forvalues i = 1/81 {
	geodist lat lon lat_techo`i' long_techo`i', gen(distancia_techo`i')
} 
egen dist_lineal_min_techo = rowmin(distancia_techo*)
drop lat_techo*
drop long_techo*
drop distancia_techo*
save "Properati_distancias", replace

* Regresion del modelo
use "Properati_distancias", clear
local estructura "rooms bathrooms surface_total"
local locacion "dist_lineal_min_bar dist_lineal_min_cine dist_lineal_min_subte"
local medioamb "dist_lineal_min_espverde dist_lineal_min_residuos dist_lineal_min_techo"
regress price `estructura' `locacion' `medioamb', robust
outreg2 using "Reg_niv_B.txt", replace

gen lprice = ln(price)
regress lprice `estructura' `locacion' `medioamb', robust
outreg2 using "Reg_log_B.txt", replace

