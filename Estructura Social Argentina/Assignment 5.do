capture cd ""  // Put the path here <----

use "EPH_2023_S2_cruda.dta", clear
rename ch04 sexo
include fgt



/**************************************************************************************************
EXERCISE 1: Calculate indicators of unmet basic needs (UBN) similar to those used by INDEC, based on the following criteria:
a) Overcrowding: households with 4 or more persons per room.
b) Housing: households living in substandard housing.
c) Sanitary conditions: households lacking any type of flush toilet.
d) School attendance: households with a school-age child (6 to 12 years old) not attending school.
e) Subsistence capacity: households with a ratio of 4 or more persons per employed member and whose head of household has a low level of education (incomplete primary education).

(i) Calculate the percentage of households with deficiencies according to each criterion.
(ii) Calculate a UBN index using the union criterion.
(iii) Calculate a UBN index using the intersection criterion.
(iv) Repeat the previous steps, simultaneously replacing the number of persons per room in the overcrowding condition (a) with "3"; the age range in condition (d) with "6 to 17 years old"; and the educational requirement for the head of household in condition (e) with "less than complete secondary education."
(v) Discuss the differences between the results observed in (iv) and those from the previous steps (reflecting the change in the definition of deficiencies).
**************************************************************************************************/

sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre)
drop if nro_hogar==51 | nro_hogar==71
mat ej1= J(7,1,.)

*(i)
*Criterion a)
rename ix_tot members
rename ii1 rooms
replace rooms=. if rooms==99 | rooms==0
gen aux= members/rooms
gen UNB1 = 0
replace UNB1 = 1 if aux>=4
replace UNB1 = . if aux==.
drop aux
*Criterion b)
gen UNB2=1 if iv1==3 | iv1==4 | iv1==5 | iv1_esp!="" | iv12_3==1
replace UNB2=0 if iv12_3==2 & (iv1==1 | iv1==2)
*Criterion c)
sum iv10
gen UNB3=.
replace UNB3=1 if iv10!=1
replace UNB3=0 if iv10==1
*Criterion d)
rename ch06 age
replace age=0 if age<0
gen attend = 0 if ch10>=0 & ch10<=3
replace attend = 1 if ch10==1
replace attend = . if age<5
gen aux = 0
replace aux = 1 if age>=6 & age<=12 & attend==0
bys id: egen aux2=total(aux)
gen UNB4 = 0
replace UNB4 = 1 if aux2>=1 & aux2!=.
drop aux
drop aux2
*Criterio e)
gen employed = 1 if estado==1
replace employed = 0 if estado!=1
bys id: egen aux1=total(employed)
gen aux2 = members/aux1 
bys id: egen aux3=max(aux2)
*aux3 is the number of members per employee
gen ed_hea = 0
replace ed_hea = 1 if ch03==1 & (nivel_ed==7 | nivel_ed==1)
bys id: egen aux4=max(ed_hea)
*aux4 is 1 when the head of the household has a low level of education
gen UNB5 = 0
replace UNB5 = 1 if aux3>=4 & aux4==1
drop aux*
foreach n of numlist 1 2 3 4 5 {
	sum UNB`n' [w=pondera] if ch03==1
	mat ej1[`n',1]=r(mean)*100
}

*(ii)
gen UNB_U=.
replace UNB_U = 1 if UNB1==1 | UNB2==1 | UNB3==1 | UNB4==1 | UNB5==1
replace UNB_U = 0 if UNB1==0 & UNB2==0 & UNB3==0 & UNB4==0 & UNB5==0
sum UNB_U [w=pondera]
mat ej1[6,1]=r(mean)*100

*(iii)
gen UNB_I=.
replace UNB_I = 1 if UNB1==1 & UNB2==1 & UNB3==1 & UNB4==1 & UNB5==1
replace UNB_I = 0 if UNB1==0 | UNB2==0 | UNB3==0 | UNB4==0 | UNB5==0
sum UNB_I [w=pondera]
mat ej1[7,1]=r(mean)*100
*export column to Excel
preserve
   drop _all
   svmat ej1
   export excel using "Assign5_Group10.xlsx", sheetmodify sheet("sheet1") cell(B5)
restore

*(iv)
mat ej1iv= J(7,1,.)
*Criterion a2)
gen aux= members/rooms
gen UNB1 = 0
replace UNB1 = 1 if aux>=3
replace UNB1 = . if aux==.
drop aux
*Criterion b2)
gen UNB2=1 if iv1==3 | iv1==4 | iv1==5 | iv1_esp!="" | iv12_3==1
replace UNB2=0 if iv12_3==2 & (iv1==1 | iv1==2)
*Criterion c2)
gen UNB3=.
replace UNB3 = 1 if iv10!=1
replace UNB3 = 0 if iv10==1
*Criterion d2)
gen asiste2 = 0 if ch10>=0 & ch10<=3
replace asiste2 = 1 if ch10==1
replace asiste2 = . if age<5
gen aux = 0
replace aux = 1 if age>=6 & age<=17 & asiste2==0
bys id: egen aux2=total(aux)
gen UNB4 = 0
replace UNB4 = 1 if aux2>=1 & aux2!=.
drop aux
drop aux2
*Criterio e2)
bys id: egen aux1=total(employed)
gen aux2 = members/aux1 
bys id: egen aux3=max(aux2)
*aux3 is the number of members per employee.
gen ed_jef2 = 0
replace ed_jef2 = 1 if ch03==1 & (nivel_ed==7 | nivel_ed==1 | nivel_ed==2 | nivel_ed==3)
bys id: egen aux4=max(ed_jef2)
*aux4 is 1 when the head of the household has a low level of education.
gen UNB5 = 0
replace UNB5 = 1 if aux3>=4 & aux4==1
drop aux*
foreach n of numlist 1 2 3 4 5 {
	sum UNB`n' [w=pondera] if ch03==1
	mat ej1iv[`n',1]=r(mean)*100
}

*(ii2)
gen unb_u=.
replace unb_u = 1 if UNB1==1 | UNB2==1 | UNB3==1 | UNB4==1 | UNB5==1
replace unb_u = 0 if UNB1==0 & UNB2==0 & UNB3==0 & UNB4==0 & UNB5==0
sum unb_u [w=pondera]
mat ej1iv[6,1]=r(mean)*100

*(iii2)
gen unb_i=.
replace unb_i = 1 if UNB1==1 & UNB2==1 & UNB3==1 & UNB4==1 & UNB5==1
replace unb_i = 0 if UNB1==0 | UNB2==0 | UNB3==0 | UNB4==0 | UNB5==0
sum unb_i [w=pondera]
mat ej1iv[7,1]=r(mean)*100
*export column to Excel
preserve
   drop _all
   svmat ej1iv
   export excel using "Assign5_Group10.xlsx", sheetmodify sheet("sheet1") cell(D5)
restore



/**************************************************************************************************
Exercise 2: Assume that a negative economic shock (e.g., the 2020 lockdown) reduces the labor income of all non-professional self-employed workers from y1 to y2 proportionally; that is, y2 = y1*(1-x). Calculate the poverty rate and the poverty gap using Argentina's moderate poverty line (first half of 2022) for values ​​of x ranging from 0 to 1 (in increments of 0.1). Plot the poverty rate and the poverty gap as a function of x.
**************************************************************************************************/

recode sexo (2=0)

* Official moderate poverty line
gen     pl_moderate = 57371.04667	if  trimestre==1 & region==1
replace pl_moderate = 46158.41		if  trimestre==1 & region==40 
replace pl_moderate = 48191.62333	if  trimestre==1 & region==41
replace pl_moderate = 54716.48		if  trimestre==1 & region==42
replace pl_moderate = 56860.36		if  trimestre==1 & region==43
replace pl_moderate = 68027.77667	if  trimestre==1 & region==44
replace	pl_moderate = 70518.15667	if  trimestre==2 & region==1
replace pl_moderate = 57040.05		if  trimestre==2 & region==40 
replace pl_moderate = 59127.90333	if  trimestre==2 & region==41
replace pl_moderate = 67447.15		if  trimestre==2 & region==42
replace pl_moderate = 69829.63333	if  trimestre==2 & region==43
replace pl_moderate = 82498.66667	if  trimestre==2 & region==44 

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
replace ae = 0.79	if sexo==1 & age==10 
replace ae = 0.82	if sexo==1 & age==11 
replace ae = 0.85	if sexo==1 & age==12 
replace ae = 0.90	if sexo==1 & age==13 
replace ae = 0.96	if sexo==1 & age==14 
replace ae = 1		if sexo==1 & age==15 
replace ae = 1.03	if sexo==1 & age==16 
replace ae = 1.04	if sexo==1 & age==17 
replace ae = 0.70	if sexo==0 & age==10 
replace ae = 0.72	if sexo==0 & age==11 
replace ae = 0.74	if sexo==0 & age==12 
replace ae = 0.76	if sexo==0 & age==13 
replace ae = 0.76	if sexo==0 & age==14 
replace ae = 0.77	if sexo==0 & age==15 
replace ae = 0.77	if sexo==0 & age==16 
replace ae = 0.77	if sexo==0 & age==17 
replace ae = 1.02	if sexo==1 & age>=18 & age<=29
replace ae = 1		if sexo==1 & age>=30 & age<=45
replace ae = 1		if sexo==1 & age>=46 & age<=60
replace ae = 0.83	if sexo==1 & age>=61 & age<=75
replace ae = 0.74	if sexo==1 & age>=76 & age<110
replace ae = 0.76	if sexo==0 & age>=18 & age<=29
replace ae = 0.77	if sexo==0 & age>=30 & age<=45
replace ae = 0.76	if sexo==0 & age>=46 & age<=60
replace ae = 0.67	if sexo==0 & age>=61 & age<=75
replace ae = 0.63	if sexo==0 & age>=76 & age<110

*calculate income per adult equivalent per household
egen aef=total(ae), by(id)
gen inc_eq= itf/aef
label var inc_eq "official income per adult equivalent"
label var pl_moderate "Moderate poverty line"

*generate family labor income
replace p47t=. if p47t==-9
replace t_vi=. if t_vi==-9
gen ila = p47t - t_vi
replace ila=. if estado!=1
egen ilaf=sum(ila), by(id)
label var ilaf "Total family labor income"

*hypothetical labor income (y2) – we simulate a 10% drop in income
mat ej2= J(11,2,.)
local cnt=1
forvalues x=0/10 {
    gen ila_sim`x'=ila
	
*it affects only non-professional self-employed individuals
replace ila_sim`x'=ila*(1-`x'/10) if (cat_ocup==2 & estado==1) & ((nivel_ed>=1 & nivel_ed<=5) | nivel_ed==7)
*Generate the family labor income simulation
egen ilaf_sim`x'=sum(ila_sim`x'), by(id)
label var ilaf_sim`x' "Simulated Total Family Labor Income"
*Generate New Family Income 
gen itf_sim`x'=(itf - ilaf + ilaf_sim`x')
replace itf_sim`x'=0 if itf_sim`x' < 0
*Generate New Income per Adult Equivalent
gen inc_eq_sim`x' = itf_sim`x'/aef
*Calculate Rate and Gap
fgt inc_eq_sim`x' [w=pondih] if inc_eq_sim`x'!=., a(0) z(pl_moderate)
mat ej2[`cnt',1]=r(fgt)
fgt inc_eq_sim`x' [w=pondih] if inc_eq_sim`x'!=., a(1) z(pl_moderate)
mat ej2[`cnt',2]=r(fgt)

local ++cnt
}

*export column to Excel
preserve
   drop _all
   svmat ej2
   export excel using "Assign5_Group10.xlsx", sheetmodify sheet("sheet2") cell(D5)
restore



/**************************************************************************************************
Exercise 3: Estimate the number of beneficiary households and the fiscal cost of a $50,000 bonus for each household meeting the following requirements:
• There is no formal wage earner in the household.
• Neither the head of household nor their spouse receives pension payments.
Show the sensitivity of these results if (i) the subsidy is granted to the head of household and the spouse (instead of a single benefit per household); (ii) the benefit (one per household) is granted only to households with children under the age of 12.
**************************************************************************************************/

mat ej3=J(3,2,.)
local bonus=50000

*There is no formal wage earner in the household
gen aux1=0
replace aux1=1 if estado==1 & cat_ocup==3 & pp07h==1
bysort id: egen cond1=max(aux1)

*Neither the boss nor their spouse receives retirement payments
gen aux2=0
replace aux2=1 if (ch03==1 | ch03==2) & cat_inac==1
bysort id: egen cond2=max(aux2)

*beneficiary households and fiscal cost
gen benef=0
replace benef=1 if ch03==1 & cond1==0 & cond2==0
ta benef [w=pondera] if ch03==1
sum benef [w=pondera] if ch03==1 & benef==1
mat ej3[1,1]=r(sum_w)
mat ej3[1,2]=r(sum_w)* `bonus'

*(i) The subsidy is granted to the head and spouse of each household (instead of a single benefit per household)
gen benef_i=0
replace benef_i=1 if (ch03==1 | ch03==2) & cond1==0 & cond2==0
ta benef_i [w=pondera] if (ch03==1 | ch03==2)
sum benef_i [w=pondera] if (ch03==1 | ch03==2) & benef_i==1
mat ej3[2,1]=r(sum_w)
mat ej3[2,2]=r(sum_w)* `bonus'

*(ii) The benefit (one per household) is granted only to households with children under the age of 12
gen aux3=1 if age<12
egen cond3 = count(aux3), by(id)
gen benef_ii=0 
replace benef_ii=1 if ch03==1 & cond1==0 & cond2==0 & cond3>=1
ta benef_ii [w=pondera] if ch03==1
sum benef_ii [w=pondera] if ch03==1 & benef_ii==1
mat ej3[3,1]=r(sum_w)
mat ej3[3,2]=r(sum_w)* `bonus'

*export matrix
preserve
drop _all
local tablas "ej3" 
foreach mat of local tablas {
svmat double `mat'
export excel using "Assign5_group10.xlsx", sheet("sheet3") cell("B5") sheetmodify 
}
restore
