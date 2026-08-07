capture cd ""  // Put the path here <----

use "EPH_2023_S2_cruda.dta", clear
drop if deccfr<1 | deccfr>10
drop if nro_hogar == 51 | nro_hogar==71



/**************************************************************************************************
Exercise 1: Divide the population of the following urban areas into percentiles based on per capita household income and use a graph to verify whether Lorenz dominance exists between:
(i) Viedma and Greater La Plata
(ii) Mar del Plata and Greater La Plata
(iii) Mar del Plata and Viedma
(iv) Comment on the robustness of the inequality comparisons based on the results obtained.

For each of these urban areas, calculate the ratio of average incomes between:
(v) The 100th percentile and the 1st percentile
(vi) The 90th percentile and the 10th percentile
(vii) The 10th decile and the 1st decile
(viii) The 5th quintile and the 1st quintile
**************************************************************************************************/

sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre)
sort aglomerado ipcf, stable

* cumulative population by agglomeration
by aglomerado: gen shrpop = sum(pondih)
by aglomerado : gen totshrpop=_N
by aglomerado : gen totshrpop_=shrpop[_N]
by aglomerado: replace shrpop = shrpop/shrpop[_N]

* accumulated income by agglomeration
by aglomerado: gen shrinc = sum(pondih*ipcf)
by aglomerado: replace shrinc = shrinc/shrinc[_N]

* Lorenz dominance
*i)
twoway (line shrinc shrpop if aglomerado==02) (line shrinc shrpop if aglomerado==93), legend(label(1 "Gran La Plata") label(2 "Viedma")) title("Lorenz curve") xtitle("Cumulative Population") ytitle("Accumulated income")
graph export "LorenzC1.png", replace
*ii)
twoway (line shrinc shrpop if aglomerado==34) (line shrinc shrpop if aglomerado==02), legend(label(1 "Mar del Plata") label(2 "Gran La Plata")) title("Lorenz curve")
graph export "LorenzC2.png", replace
*iii)
twoway (line shrinc shrpop if aglomerado==34) (line shrinc shrpop if aglomerado==93), legend(label(1 "Mar del Plata") label(2 "Viedma")) title("Lorenz curve")
graph export "LorenzC3.png", replace

* construction of percentiles, deciles, and quintiles 
sort aglomerado ipcf, stable
by aglomerado: gen sumpop=sum(pondih)
by aglomerado: gen double ppquintile = sumpop[_N]/5
by aglomerado: gen double pppercentile= sumpop[_N]/100
by aglomerado: gen double ppdecile = sumpop[_N]/10
generate quintile=0 
generate decile=0
generate percentile=0 

foreach num of numlist 02 34 93 {
    
    forvalues i = 0(1)99  {
            replace percentile=`i'+1 if sumpop>pppercentile*`i' & sumpop<=pppercentile*(`i'+1) & aglomerado==`num'
                }
    forvalues i = 0(1)9  {
            replace decile=`i'+1 if sumpop>ppdecile*`i' & sumpop<=ppdecile*(`i'+1) & aglomerado==`num'
                }
         forvalues i = 0(1)4  {
            replace quintile=`i'+1 if sumpop>ppquintile*`i' & sumpop<=ppquintile*(`i'+1) & aglomerado==`num'
}
}
sort aglomerado percentile

preserve 
version 13: table percentile if aglomerado==02, c(max shrinc) replace 
export excel using "Assign6_Group10.xlsx", sheetmodify sheet("Sheet 1") cell(E3)
restore 
preserve
version 13: table percentile if aglomerado==93, c(max shrinc) replace 
export excel using "Assign6_Group10.xlsx", sheetmodify sheet("Sheet 1") cell(B3)
restore 
preserve 
version 13: table percentile if aglomerado==34, c(max shrinc) replace 
export excel using "Assign6_Group10.xlsx", sheetmodify sheet("Sheet 1") cell(H3)
restore

* calculate the ratio of average incomes between:
*(v) The 100th percentile and the 1st percentile
*(vi) The 90th percentile and the 10th percentile
*(vii) The 10th decile and the 1st decile
*(viii) The 5th quintile and the 1st quintile
mat ej1=J(4,3,.)
local cnt = 1

foreach num of numlist 93 02 34 {
    * Calculate the average per capita family income for the 100th percentile
    sum ipcf [w=pondih] if percentile == 100 & aglomerado == `num'
    local cs = r(mean)

    * Calculate the average per capita family income for the first percentile
    sum ipcf [w=pondih] if percentile == 1 & aglomerado == `num'
    local ci = r(mean)

    * Calculate the 100th percentile / 1st percentile ratio
    local ratio_100_1 = `cs' / `ci'
    display as text "Ratio of 100th percentile to 1st percentile for region `num': " as result `ratio_100_1'
        mat ej1[1,`cnt']=`ratio_100_1'
		
    * Calculate the average per capita family income for the 90th percentile
    sum ipcf [w=pondih] if percentile == 90 & aglomerado == `num'
    local cs = r(mean)

    * Calculate the average per capita family income for the 10th percentile
    sum ipcf [w=pondih] if percentile == 10 & aglomerado == `num'
    local ci = r(mean)

    * Calculate the 90th percentile / 10th percentile ratio
    local ratio_90_10 = `cs' / `ci'
    display as text "Ratio of 90th percentile to 10th percentile for the region `num': " as result `ratio_90_10'
     mat ej1[2,`cnt']=`ratio_90_10'
		
    * Calculate the average per capita family income for the 10th decile
    sum ipcf [w=pondih] if decile == 10 & aglomerado == `num'
    local cs = r(mean)

    * Calculate the average IPCF for decile 1
    sum ipcf [w=pondih] if decile == 1 & aglomerado == `num'
    local ci = r(mean)

    * Calculate the 10th decile / 1st decile ratio
    local ratio_10_1 = `cs' / `ci'
    display as text "Ratio of the 10th decile to the 1st decile for region `num': " as result `ratio_10_1'
     mat ej1[3,`cnt']=`ratio_10_1'
	
    * Calculate the average per capita family income for the fifth quintile
    sum ipcf [w=pondih] if quintile == 5 & aglomerado == `num'
    local cs = r(mean)

    * Calculate the average per capita family income for the first quintile
    sum ipcf [w=pondih] if quintile == 1 & aglomerado == `num'
    local ci = r(mean)

    * Calculate the quintile 5 / quintile 1 ratio.
    local ratio_5_1 = `cs' / `ci'
    display as text "Ratio of quintile 5 to quintile 1 for region `num': " as result `ratio_5_1'
	 mat ej1[4,`cnt']=`ratio_5_1'

local ++cnt
}

*export column to excel
preserve
   drop _all
   svmat ej1
   export excel using "Assign6_Group10.xlsx", sheetmodify sheet("Sheet 1") cell(M3)
restore



/**************************************************************************************************
Exercise 2: Calculate the Gini coefficient and the Theil index for the following distributions:
(i) Per capita household income in Viedma, Greater La Plata, and Mar del Plata.
(ii) Labor income of workers aged 25 to 55 by educational level (1. low = less than completed secondary education; 2. medium = completed secondary education and incomplete higher education; and 3. high = completed higher education).
(iii) Labor income of employed men and women aged 25 to 55.
**************************************************************************************************/

*(i) Calculate the Gini coefficient and the Theil index for per capita family income in Viedma, Greater La Plata, and Mar del Plata
run "gini.do"
run "theil.do"

*Viedma:
*Gini
gini ipcf [w=pondih] if aglomerado==93
*Theil
theil ipcf [w=pondih] if aglomerado==93

*Gran La Plata:
*Gini
gini ipcf [w=pondih] if aglomerado==02
*Theil
theil ipcf [w=pondih] if aglomerado==02

*Mar del Plata:
*Gini
gini ipcf [w=pondih] if aglomerado==34
*Theil*
theil ipcf [w=pondih] if aglomerado==34

*(ii) Calculate the Gini coefficient and Theil index for the labor income of workers aged 25 to 55 by educational level
replace p47t=. if p47t==-9
replace t_vi=. if t_vi
gen employed=0 if (estado==2 | estado==3)
replace employed=1 if estado==1
gen ilab= p47t - t_vi
replace ilab=. if employed!=1
gen edu_level=.
replace edu_level=1 if (nivel_ed==1 | nivel_ed==2 | nivel_ed==3 | nivel_ed==7)
replace edu_level=2 if (nivel_ed==4 | nivel_ed==5)
replace edu_level=3 if nivel_ed==6
gen age = ch06
replace age=0 if ch06<0

*Low Educational Level:
*Gini*
gini ilab [w=pondih] if (age>=25 & age<=55) & edu_level==1 & employed==1
*Theil*
theil ilab [w=pondih] if (age>=25 & age<=55) & edu_level==1 & employed==1

*Intermediate Education Level:
*Gini*
gini ilab [w=pondih] if  (age>=25 & age<=55) & edu_level==2 & employed==1
*Theil*
theil ilab [w=pondih] if (age>=25 & age<=55) & edu_level==2 & employed==1

*High Educational Level:
*Gini*
gini ilab [w=pondih] if (age>=25 & age<=55) & edu_level==3 & employed==1
*Theil*
theil ilab [w=pondih] if (age>=25 & age<=55) & edu_level==3 & employed==1

*(iii) Calculate the Gini coefficient and the Theil index for the labor income of employed men and women aged 25 to 55
mat ej2iii= J(2,2,.)

*Men:
*Gini
gini ilab [w=pondih] if employed==1 & (age>=25 & age<=55) & ch04==1
*Theil
theil ilab [w=pondih] if employed==1 & (age>=25 & age<=55) & ch04==1

*Women:
*Gini
gini ilab [w=pondih] if  employed==1 & (age>=25 & age<=55) & ch04==2
*Theil
theil ilab [w=pondih] if employed==1 & (age>=25 & age<=55) & ch04==2



/**************************************************************************************************
Exercise 3: Assume that a negative economic shock (e.g., the lockdown) reduces the labor income of all non-professional self-employed workers from y1 to y2 proportionally; that is, y2 = y1 * (1 - x). Calculate the distribution of per capita household income before and after the shock for x = 0.5.

(i) Check using a graph whether Lorenz dominance (based on percentiles) exists between the distributions before and after the shock.
(ii) Calculate the following indicators before and after the shock:
a. Decile 10/Decile 1 income ratio
b. Decile 10 share of total income
c. Gini coefficient
d. Theil index
(iii) Comment.
**************************************************************************************************/

local x=0.5

*(i) Verify via a graph whether Lorenz dominance (based on percentiles) exists between the distributions before and after the shock

*generate a labor income variable
gen employ = (estado==1)
replace p47t=. if p47t==-9
replace t_vi=. if t_vi==-9
gen ila=p47t-t_vi
replace ila=. if employ!=1

*Generate family employment income 
egen ila_tot= sum(ila), by (id)

*generate notional labor income (y2)
gen ila_sim=ila

*apply the restriction
replace ila_sim=ila*(1-`x') if cat_ocup==2 & (nivel_ed<=5 | nivel_ed==7)
egen ila_tot_sim= sum(ila_sim), by (id)
gen itf_sim=(itf-ila_tot + ila_tot_sim)
replace itf_sim= 0 if itf_sim<0

*new family per capita income
gen ipcf_sim= itf_sim/ix_tot
generate pipcf=0
generate pipcf_sim=0
gen dipcf=0
gen dipcf_sim=0
mat ej3=J(4,2,.)
local cny = 1
foreach var of varlist ipcf ipcf_sim {
	
capture drop sumpop
capture drop pppercentile
sort `var', stable
gen double sumpop=sum(pondih)
gen double pppercentile=sumpop[_N]/100
forvalues i =0(1)99 {
replace p`var'=`i'+1 if sumpop>pppercentile*`i' & sumpop<=pppercentile*(`i'+1)
}

*Generate accumulated income
capture drop shrinc
gen shrinc=sum(pondih*`var')
replace shrinc=shrinc/shrinc[_N]

*export
preserve
version 13: table p`var', c(max shrinc) replace
export excel using "TP6_grupo10.xlsx", sheet("3_ `var'", modify) cell(B3)
restore

*(ii)

*a) 10th decile/1st decile income ratio
capture drop pxdecile
sort `var', stable
gen double pxdecile=sumpop[_N]/10
forvalues i =0(1)9 {
replace d`var'=`i'+1 if sumpop>pxdecile*`i' & sumpop<=pxdecile*(`i'+1)
}
sum `var' [w=pondih] if  d`var' == 10
local cs =r(mean)
sum `var' [w=pondih] if  d`var' == 1 
local ci = r(mean)
mat ej3[1,`cny']= `cs'/`ci'

*b) Share of the 10th decile in total income
gen shrdecdiez=sum(pondih*`var') if d`var'==10
gen shrdec=sum(pondih*`var')
mat ej3[2,`cny']=shrdecdiez[_N]/shrdec[_N]

*c) Gini coefficient
gini `var' [w=pondih] if `var'>0 & `var'!=.
mat ej3[3,`cny']=r(gini)

*d) Theil Index
theil `var' [w=pondih] if `var'>0 & `var'!=.
mat ej3[4,`cny']=r(theil)

drop sumpop shrinc shrdecdiez shrdec
local ++cny
}

preserve
drop _all 
svmat ej3
export excel "Assign6_group10.xlsx", sheet ("Sheet 3") cell ("B3") sheetmodify
restore 
