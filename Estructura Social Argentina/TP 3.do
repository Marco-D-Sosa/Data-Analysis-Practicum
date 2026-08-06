clear all
capture cd "C:\Users\raldu\Downloads"
use "EPH_2023_S1_cruda_old.dta"
sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre) 




*EJERCICIO 1*
*datos usados de Informes tÃ©cnicos / Vol. 7, nÂ° 205.Incidencia de la pobreza y la indigencia en 31 aglomerados urbanos Primer semestre de 2023. INDEC


**linea de pobreza para cada region y trimestre. 
gen lp=.
replace lp = 57371.04667	if  trimestre==1 & region==1     //GBA
replace lp = 46158.41		if  trimestre==1 & region==40   // NOA 
replace lp = 48191.62333	if  trimestre==1 & region==41  // NEA
replace lp= 54716.48		if  trimestre==1 & region==42  // Cuyo
replace lp= 56860.36		if  trimestre==1 & region==43  // Pampeana
replace lp= 68027.77667	    if  trimestre==1 & region==44  // Patagonia
replace	lp= 70518.15667	    if  trimestre==2 & region==1   //GBA
replace lp= 57040.05		if  trimestre==2 & region==40  // NOA 
replace lp= 59127.90333	    if  trimestre==2 & region==41  // NEA
replace lp= 67447.15		if  trimestre==2 & region==42  // Cuyo
replace lp= 69829.63333  	if  trimestre==2 & region==43  // Pampeana
replace lp= 82498.66667	    if  trimestre==2 & region==44   // Patagonia


**linea de la indigencia para cada region y trimestre
gen li=. 
replace li = 25916.49333	if  trimestre==1 & region==1 //GBA
replace li = 22471.69		if  trimestre==1 & region==40  // NOA 
replace li= 23273.38666     if  trimestre==1 & region==41 // NEA
replace li= 23213.03	    if  trimestre==1 & region==42 // Cuyo
replace li= 25719.10333   	if  trimestre==1 & region==43 // Pampeana
replace li= 27061.92333     if  trimestre==1 & region==44 // Patagonia
replace	li=32085.04666      if  trimestre==2 & region==1 //GBA
replace li =27947.03333		if  trimestre==2 & region==40  // NOA 
replace li =28688.65333	    if  trimestre==2 & region==41 // NEA
replace li=28810.69666	    if  trimestre==2 & region==42 // Cuyo
replace li=31771.94333	    if  trimestre==2 & region==43 // Pampeana
replace li= 33028.55666     if  trimestre==2 & region==44 // Patagonia 


**renombramos algunas variables y generamos la escala para adulto equivalente.
rename ch04 sexo 
recode sexo (2=0)
rename ch06 edad
replace edad=0 if edad<0

gen ae=.
replace ae = 0.35	if edad<1 
replace ae = 0.37	if edad==1
replace ae = 0.46	if edad==2
replace ae = 0.51	if edad==3
replace ae = 0.55	if edad==4
replace ae = 0.60	if edad==5
replace ae = 0.64	if edad==6
replace ae = 0.66	if edad==7
replace ae = 0.68	if edad==8
replace ae = 0.69	if edad==9
replace ae = 0.79	if sexo==1 & edad==10 
replace ae = 0.82	if sexo==1 & edad==11 
replace ae = 0.85	if sexo==1 & edad==12 
replace ae = 0.90	if sexo==1 & edad==13 
replace ae = 0.96	if sexo==1 & edad==14 
replace ae = 1		if sexo==1 & edad==15 
replace ae = 1.03	if sexo==1 & edad==16 
replace ae = 1.04	if sexo==1 & edad==17 
replace ae = 0.70	if sexo==0 & edad==10 
replace ae = 0.72	if sexo==0 & edad==11 
replace ae = 0.74	if sexo==0 & edad==12 
replace ae = 0.76	if sexo==0 & edad==13 
replace ae = 0.76	if sexo==0 & edad==14 
replace ae = 0.77	if sexo==0 & edad==15 
replace ae = 0.77	if sexo==0 & edad==16 
replace ae = 0.77	if sexo==0 & edad==17 
replace ae = 1.02	if sexo==1 & edad>=18 & edad<=29
replace ae = 1		if sexo==1 & edad>=30 & edad<=45
replace ae = 1		if sexo==1 & edad>=46 & edad<=60
replace ae = 0.83	if sexo==1 & edad>=61 & edad<=75
replace ae = 0.74	if sexo==1 & edad>=76 & edad<110
replace ae = 0.76	if sexo==0 & edad>=18 & edad<=29
replace ae = 0.77	if sexo==0 & edad>=30 & edad<=45
replace ae = 0.76	if sexo==0 & edad>=46 & edad<=60
replace ae = 0.67	if sexo==0 & edad>=61 & edad<=75
replace ae = 0.63	if sexo==0 & edad>=76 & edad<110


**calculo el ingreso de adulto equivalente por hogar
egen aef= sum(ae) , by (id)
gen ing_eq=itf/aef
label var ing_eq "ingreso por adulto equivalente"


**calculo los indicadores, FGT(0),FGT(1) Y FGT (2) **
gen fgt_0=0 
replace fgt_0=1*100 if ing_eq<lp
gen fgt_1=0
replace fgt_1=(1-(ing_eq/lp))*100 if ing_eq<lp
gen fgt_2=0
replace fgt_2=((1-(ing_eq/lp))^2)*100 if ing_eq<lp

gen fgti_0=0 
replace fgti_0=1*100 if ing_eq<li
gen fgti_1=0
replace fgti_1=(1-(ing_eq/lp))*100 if ing_eq<li
gen fgti_2=0
replace fgti_2=((1-(ing_eq/lp))^2)*100 if ing_eq<li

**a) Y b)
sum fgt_0 fgt_1 fgt_2 fgti_0 fgti_1 fgti_2 [w=pondih]




****************************************************************************************************


*EJERCICIO 2*

*Generamos nueva línea de pobreza"
gen lp_moderada_2=lp*1.3
gen ing_eq_2=1.2*ing_eq

gen fgt_0_alt=0
replace fgt_0_alt=1 if ing_eq_2<lp_moderada_2
gen fgt_1_alt=0
replace fgt_1_alt=(1-(ing_eq_2/lp_moderada_2)) if ing_eq_2<lp_moderada_2
gen fgt_2_alt=0
replace fgt_2_alt=(1-(ing_eq_2/lp_moderada_2))^2 if ing_eq_2<lp_moderada_2
replace fgt_0_alt= fgt_0_alt*100
replace fgt_1_alt= fgt_1_alt*100
replace fgt_2_alt= fgt_2_alt*100
tabstat fgt_0_alt fgt_1_alt fgt_2_alt [w=pondih]



****************************************************************************************************

*EJERCICIO 3*

*a)Gráfico de barras de las regiones argentinas ordenadas según sus niveles de pobreza de menor a mayor
graph bar (mean) fgt_0 [w=pondih], over(region, sort(1)) ///
ytitle("tasa de pobreza") title("tasa de pobreza por region") graphregion (color(white))
graph export "GraficoTP3_a.png", replace


*b)Repetir el ejercicio con la brecha de la pobreza
graph bar (mean) fgt_1 [w=pondih], over(region, sort(1)) ///
ytitle("brecha de la pobreza") title("brecha de la pobreza por region") graphregion(color(white))
graph export "GraficoTP3_b.png", replace


*c)Construir la función de distribución del ingreso equivalente para cada región y evaluar si hay dominancia estocástica de primer orden
sort region ing_eq, stable
by region: gen share=sum(pondih)
by region: replace share=share/share[_N]

twoway (line share ing_eq if region==1) (line share ing_eq if region==40) (line share ing_eq if region==41) ///
(line share ing_eq if region==42) (line share ing_eq if region==43) (line share ing_eq if region==44), ///
legend(label(1 "GBA") label(2 "NOA") label(3 "NEA") label (4 "Cuyo") label(5 "Pampeana") label(6 "Patagonia")) xtitle("ingreso por AE") scheme(s1color)
*no es util

gen l_ing = log(ing_eq)
twoway (line share l_ing if region==1) (line share l_ing if region==40) (line share l_ing if region==41) ///
(line share l_ing if region==42) (line share l_ing if region==43) (line share l_ing if region==44), ///
legend(label(1 "GBA") label(2 "NOA") label(3 "NEA") label (4 "Cuyo") label(5 "Pampeana") label(6 "Patagonia")) xtitle("ingreso por AE") scheme(s1color)
graph export "GraficoTP3_c.png", replace 




****************************************************************************************************

*EJERCICIO 4*

label var lp "Linea de pobreza moderada oficial" 
gen grupo_edad = . 
replace grupo_edad = 1 if edad >=0 & edad <=12
replace grupo_edad = 2 if edad >=65 & edad <=80


*a)
forvalues g = 1/2 { 
    sum fgt_0 [w=pondih] if grupo_edad==`g' 
}  
* b)
matrix fgt = J(2,3,.)
local theta1 = 0.75
local theta2 = 0.5
local theta3 = 0.25
forvalues t = 1/3 {
   gen ing_`t' = itf / aef^`theta`t'' 
   gen fgt_0_`t' = 0
   replace fgt_0_`t' = 1 if ing_`t' < lp
}
*Bucle dentro de otro bucle
local cnt= 1
forvalues t = 1/3 {
        forvalues g = 1/2 {
		     sum fgt_0_`t' [w=pondih] if grupo_edad==`g'
			 mat fgt[`g',`cnt']=r(mean)*100
			 }
			 local ++cnt
}
mat list fgt




****************************************************************************************************

*EJERCICIO 5*

gen count = 1
table region [w=pondih], c(sum count mean fgt_0 mean fgt_1 mean fgt_2) replace row
rename table1 pob
rename table2 fgt_0
rename table3 fgt_1
rename table4 fgt_2

* Contribucion a la pobreza de cada region 
gen prop_pob = pob/pob[1] 
gen prop_fgt0 = fgt_0/fgt_0[1]
gen prop_fgt1 = fgt_1/fgt_1[1]
gen prop_fgt2 = fgt_2/fgt_2[1]
gen aporte0 = (prop_pob*prop_fgt0)*100
gen aporte1 = (prop_pob*prop_fgt1)*100
gen aporte2 = (prop_pob*prop_fgt2)*100
keep region pob fgt_0 fgt_1 aporte0 aporte1 aporte2
order region pob fgt_0 fgt_1 aporte0 aporte1 aporte2




****************************************************************************************************
