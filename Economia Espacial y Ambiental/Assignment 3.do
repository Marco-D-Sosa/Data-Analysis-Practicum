**********************************************
**************** Assignment 3 ****************
**********************************************

capture cd ""  // Put the path here <----

use "base_properati", clear
*ssc install geodist
*ssc install outreg2



*********************************************
****************** Part A ******************
*********************************************

* Subways
merge m:1 id_merge using "coord_subtes_wide"
drop _merge
forvalues i = 1/90 {
	geodist lat lon lat_subte`i' long_subte`i', gen(dist_subway`i')
} 
egen min_linear_dist_subway = rowmin(dist_subway*)
drop lat_subte*
drop long_subte*
drop dist_subway*
save "Properati_distancias", replace

* Cinemas
merge m:1 id_merge using "coord_cines_wide"
drop _merge
forvalues i = 1/22 {
	geodist lat lon lat_cine`i' long_cine`i', gen(dist_cinema`i')
} 
egen min_linear_dist_cinema = rowmin(dist_cinema*)
drop lat_cine*
drop long_cine*
drop dist_cinema*
save "Properati_distancias", replace

* Bars
merge m:1 id_merge using "coord_bares_wide"
drop _merge
forvalues i = 1/248 {
	geodist lat lon lat_bar`i' long_bar`i', gen(dist_bar`i')
} 
egen min_linear_dist_bar = rowmin(dist_bar*)
drop lat_bar*
drop long_bar*
drop dist_bar*
save "Properati_distancias", replace

* Regression of the model
local structure "rooms bathrooms surface_total"
local location "min_linear_dist_bar min_linear_dist_cinema min_linear_dist_subway"
regress price `structure' `location', robust
outreg2 using "Reg_lev.txt", replace

gen lprice = ln(price)
regress lprice `structure' `location', robust
outreg2 using "Reg_log.txt", replace



*********************************************
****************** Part B ******************
*********************************************

* Trash
merge m:1 id_merge using "coord_residuos_wide"
drop _merge
forvalues i = 1/139 {
	geodist lat lon lat_residuos_`i' long_residuos_`i', gen(dist_trash`i')
} 
egen min_linear_dist_trash = rowmin(dist_trash*)
drop lat_residuos*
drop long_residuos*
drop dist_trash*
save "Properati_distancias", replace

* Green spaces
merge m:1 id_merge using "coord_espverde_wide"
drop _merge
forvalues i = 1/102 {
	geodist lat lon lat_espverde`i' long_espverde`i', gen(dist_greensp`i')
} 
egen min_linear_dist_greensp = rowmin(dist_greensp*)
drop lat_espverde*
drop long_espverde*
drop dist_greensp*
save "Properati_distancias", replace

* Roofs
merge m:1 id_merge using "coord_techos_wide"
drop _merge
forvalues i = 1/81 {
	geodist lat lon lat_techo`i' long_techo`i', gen(dist_roof`i')
} 
egen min_linear_dist_roof = rowmin(dist_roof*)
drop lat_techo*
drop long_techo*
drop dist_roof*
save "Properati_distancias", replace

* Regression of the model
local environment "min_linear_dist_greensp min_linear_dist_trash min_linear_dist_roof"
regress price `structure' `location' `environment', robust
outreg2 using "Reg_lev_B.txt", replace

regress lprice `structure' `location' `environment', robust
outreg2 using "Reg_log_B.txt", replace
