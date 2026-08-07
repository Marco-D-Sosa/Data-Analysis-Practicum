clear all
capture cd ""  // Put the path here <----

use "EPH_2023_S1_cruda_old.dta"
sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre) 



* EXERCISE 1: Data from Technical Reports / Vol. 7, No. 205. Incidence of poverty and extreme poverty in 31 urban agglomerations, first half of 2023. INDEC.

* poverty line for each region and quarter
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

* destitution line for each region and quarter
gen li=. 
replace li = 25916.49333	if  trimestre==1 & region==1
replace li = 22471.69		if  trimestre==1 & region==40
replace li= 23273.38666     if  trimestre==1 & region==41
replace li= 23213.03	    if  trimestre==1 & region==42
replace li= 25719.10333   	if  trimestre==1 & region==43
replace li= 27061.92333     if  trimestre==1 & region==44
replace	li=32085.04666      if  trimestre==2 & region==1
replace li =27947.03333		if  trimestre==2 & region==40
replace li =28688.65333	    if  trimestre==2 & region==41
replace li=28810.69666	    if  trimestre==2 & region==42
replace li=31771.94333	    if  trimestre==2 & region==43
replace li= 33028.55666     if  trimestre==2 & region==44

* renamed some variables and generated the adult-equivalent scale
rename ch04 sex 
recode sex (2=0)
rename ch06 age
replace age=0 if age<0
gen ae=.
replace ae = 0.35	if age<1 
replace ae = 0.37	if age==1
replace ae = 0.46	if age==2
replace ae = 0.51	if age==3
replace ae = 0.55	if age==4
replace ae = 0.60	if age==5
replace ae = 0.64	if age==6
replace ae = 0.66	if age==7
replace ae = 0.68	if age==8
replace ae = 0.69	if age==9
replace ae = 0.79	if sex==1 & age==10 
replace ae = 0.82	if sex==1 & age==11 
replace ae = 0.85	if sex==1 & age==12 
replace ae = 0.90	if sex==1 & age==13 
replace ae = 0.96	if sex==1 & age==14 
replace ae = 1		if sex==1 & age==15 
replace ae = 1.03	if sex==1 & age==16 
replace ae = 1.04	if sex==1 & age==17 
replace ae = 0.70	if sex==0 & age==10 
replace ae = 0.72	if sex==0 & age==11 
replace ae = 0.74	if sex==0 & age==12 
replace ae = 0.76	if sex==0 & age==13 
replace ae = 0.76	if sex==0 & age==14 
replace ae = 0.77	if sex==0 & age==15 
replace ae = 0.77	if sex==0 & age==16 
replace ae = 0.77	if sex==0 & age==17 
replace ae = 1.02	if sex==1 & age>=18 & age<=29
replace ae = 1		if sex==1 & age>=30 & age<=45
replace ae = 1		if sex==1 & age>=46 & age<=60
replace ae = 0.83	if sex==1 & age>=61 & age<=75
replace ae = 0.74	if sex==1 & age>=76 & age<110
replace ae = 0.76	if sex==0 & age>=18 & age<=29
replace ae = 0.77	if sex==0 & age>=30 & age<=45
replace ae = 0.76	if sex==0 & age>=46 & age<=60
replace ae = 0.67	if sex==0 & age>=61 & age<=75
replace ae = 0.63	if sex==0 & age>=76 & age<110

* calculate the adult-equivalent income per household
egen aef= sum(ae) , by (id)
gen inc_eq=itf/aef
label var inc_eq "income per adult equivalent"

* calculate the indicators FGT(0), FGT(1), and FGT(2)
gen fgt_0=0 
replace fgt_0=1*100 if inc_eq<lp
gen fgt_1=0
replace fgt_1=(1-(inc_eq/lp))*100 if inc_eq<lp
gen fgt_2=0
replace fgt_2=((1-(inc_eq/lp))^2)*100 if inc_eq<lp

gen fgti_0=0 
replace fgti_0=1*100 if inc_eq<li
gen fgti_1=0
replace fgti_1=(1-(inc_eq/lp))*100 if inc_eq<li
gen fgti_2=0
replace fgti_2=((1-(inc_eq/lp))^2)*100 if inc_eq<li

* a) Y b)
sum fgt_0 fgt_1 fgt_2 fgti_0 fgti_1 fgti_2 [w=pondih]



****************************************************************************************************
* Exercise 2

* Establish a new poverty line
gen lp_moderada_2=lp*1.3
gen ing_eq_2=1.2*inc_eq
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
* Exercise 3

*a) Bar chart of Argentine regions ordered by poverty levels from lowest to highest
graph bar (mean) fgt_0 [w=pondih], over(region, sort(1)) ///
ytitle("poverty rate") title("poverty rate by region") graphregion (color(white))
graph export "GraphAssign3_a.png", replace

*b) Repeat the exercise with the poverty gap
graph bar (mean) fgt_1 [w=pondih], over(region, sort(1)) ///
ytitle("poverty gap") title("poverty gap per region") graphregion(color(white))
graph export "GraphAssign3_b.png", replace

*c) Construct the equivalent income distribution function for each region and evaluate whether first-order stochastic dominance exists.
sort region inc_eq, stable
by region: gen share=sum(pondih)
by region: replace share=share/share[_N]
twoway (line share inc_eq if region==1) (line share inc_eq if region==40) (line share inc_eq if region==41) ///
(line share inc_eq if region==42) (line share inc_eq if region==43) (line share inc_eq if region==44), ///
legend(label(1 "GBA") label(2 "NOA") label(3 "NEA") label (4 "Cuyo") label(5 "Pampeana") label(6 "Patagonia")) xtitle("income per AE") scheme(s1color)
* It's not useful

gen l_ing = log(inc_eq)
twoway (line share l_ing if region==1) (line share l_ing if region==40) (line share l_ing if region==41) ///
(line share l_ing if region==42) (line share l_ing if region==43) (line share l_ing if region==44), ///
legend(label(1 "GBA") label(2 "NOA") label(3 "NEA") label (4 "Cuyo") label(5 "Pampeana") label(6 "Patagonia")) xtitle("income per AE") scheme(s1color)
graph export "GraphAssign3_c.png", replace 



****************************************************************************************************
* Exercise 4

label var lp "Official moderate poverty line" 
gen group_age = . 
replace group_age = 1 if age >=0 & age <=12
replace group_age = 2 if age >=65 & age <=80

*a)
forvalues g = 1/2 { 
    sum fgt_0 [w=pondih] if group_age==`g' 
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

* Loop within a loop
local cnt= 1
forvalues t = 1/3 {
        forvalues g = 1/2 {
		     sum fgt_0_`t' [w=pondih] if group_age==`g'
			 mat fgt[`g',`cnt']=r(mean)*100
			 }
			 local ++cnt
}
mat list fgt



****************************************************************************************************
* Exercise 5

gen count = 1
table region [w=pondih], c(sum count mean fgt_0 mean fgt_1 mean fgt_2) replace row
rename table1 pob
rename table2 fgt_0
rename table3 fgt_1
rename table4 fgt_2

* Contribution of each region to poverty 
gen prop_pob = pob/pob[1] 
gen prop_fgt0 = fgt_0/fgt_0[1]
gen prop_fgt1 = fgt_1/fgt_1[1]
gen prop_fgt2 = fgt_2/fgt_2[1]
gen aporte0 = (prop_pob*prop_fgt0)*100
gen aporte1 = (prop_pob*prop_fgt1)*100
gen aporte2 = (prop_pob*prop_fgt2)*100
keep region pob fgt_0 fgt_1 aporte0 aporte1 aporte2
order region pob fgt_0 fgt_1 aporte0 aporte1 aporte2
