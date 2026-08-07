capture cd ""  // Put the path here <----

use "arg_eph_23s1_tp2", clear
describe



/* 
Exercise 1: Calculate some basic statistics for the distribution of per capita family income in Argentina and each of its regions:
(a) Mean
(b) Median
(c) Minimum and maximum values
(d) 5th, 25th, 75th, and 99th percentiles
(e) Fisher's coefficient of skewness
(f) Comment on the differences between regions
*/

* for Argentina
sum ipcf [w=pondih] if region !=. , d

* for regions
foreach num of numlist 1 40 41 42 43 44 {
display as text "region `num' "
 sum ipcf [w=pondih] if region ==`num' , d 
 }



* Exercise 2: Consider the distribution of per capita family income in Argentina

*(a) Divide the population into deciles and present the mean and median income for each decile
sort ipcf, stable
gen sumpop=sum(pondih)
generate double ppdecil=sumpop[_N]/10
generate decil = 0
generate decil2=0
forvalues i=0(1)9 {
	replace decil2= `i'+1 if sumpop>ppdecil*`i' & sumpop<= ppdecil*(`i'+1)
}
version 13: table decil2 [w=pondih], c(mean ipcf median ipcf sum ipcf) row format(%20.3f)

*(b) Calculate each decile's share of total income. Illustrate with a bar chart
summarize ipcf [w=pondih], d
generate share=.
local totipcf=r(sum)
sum ipcf[w=pondih] if decil2==1
replace share=(r(sum)/`totipcf')*100 if decil2==1
sum ipcf[w=pondih] if decil2==2
replace share=(r(sum)/`totipcf')*100 if decil2==2
sum ipcf[w=pondih] if decil2==3
replace share=(r(sum)/`totipcf')*100 if decil2==3
sum ipcf[w=pondih] if decil2==4
replace share=(r(sum)/`totipcf')*100 if decil2==4
sum ipcf[w=pondih] if decil2==5
replace share=(r(sum)/`totipcf')*100 if decil2==5
sum ipcf[w=pondih] if decil2==6
replace share=(r(sum)/`totipcf')*100 if decil2==6
sum ipcf[w=pondih] if decil2==7
replace share=(r(sum)/`totipcf')*100 if decil2==7
sum ipcf[w=pondih] if decil2==8
replace share=(r(sum)/`totipcf')*100 if decil2==8
sum ipcf[w=pondih] if decil2==9
replace share=(r(sum)/`totipcf')*100 if decil2==9
sum ipcf[w=pondih] if decil2==10
replace share=(r(sum)/`totipcf')*100 if decil2==10

*(c) Repeat exercise (a), dividing the population into percentiles. Present and illustrate only the mean income of each percentile
generate pppercentil=sumpop[_N]/100
generate percentil=0
forvalues i=0(1)99 {
	replace percentil= `i'+1 if sumpop>pppercentil*`i' & sumpop<= pppercentil*(`i'+1)
}
preserve
version 13: table percentil [w=pondih], c(mean ipcf) row format(%20.3f) replace
restore



* Exercise 3: Present the following graphs of the distribution of family per capita income x:

*(a) A histogram of x. Limit the support for better visualization of the plot.
sum ipcf [w=pondih], d
histogram ipcf [w=pondih] if ipcf<r(p90), frac ytitle("Proportion") scheme(s1color)
graph export "histogram_Assign2.png", replace

*(b) A histogram of the logarithm of x.
gen lipcf=ln(ipcf)
sum lipcf [w=pondih], d
histogram lipcf [w=pondih], frac ytitle("Proportion") xtitle("logarithm of per capita household income") scheme(s1color)
graph export "histogramLog_Assign2.png", replace

*(c) A non-parametric kernel estimate of the logarithm of x.
kdensity lipcf [w=pondih], xtitle("logarithm of per capita household income") ytitle("density") scheme(s1color)
graph export "Kernels_Assign2.png", replace

*(d) Pen's x-curve.
sort ipcf, stable
gen shrpop = sum(pondih)
replace shrpop = shrpop/shrpop[_N]
line ipcf shrpop, scheme(s1color)
graph export "PenCurve_Assign2.png", replace



* Exercise 4: Restrict the sample to adult "heads of household" aged 30 to 60
gen age = ch06
replace age = 0 if ch06==-1

* Compare, on the same graph, non-parametric kernel estimates of the distribution of the logarithm of per capita income for two groups: 
* (i) those with completed higher education and (ii) the rest.
gen edu_level = nivel
replace edu_level = 1 if edu_level==7
kdensity lipcf [w=pondih] if (age>=30 & age<=60) & edu_level==6 & ch04==1 & ch03==1
twoway (kdensity lipcf [w=pondih] if (age>=30 & age<=60) & edu_level==6 & ch04==1 & ch03==1) (kdensity lipcf [w=pondih] if (age>=30 & age<=60) & edu_level!=6 & ch04==1 & ch03==1)
twoway (kdensity lipcf [w=pondih] if (age>=30 & age<=60) & edu_level==6 & ch04==1 & ch03==1) (kdensity lipcf [w=pondih] if (age>=30 & age<=60) & edu_level!=6 & ch04==1 & ch03==1), legend (label(1 "Completed Higher Education") label(2 "Other Educational Levels")) ytitle("Education") xtitle("Log of household per capita income") scheme(s1color)
graph export "graph4.png", replace



* Exercise 5: divide the population into age groups: [0, 29], [30, 59], [60 or older]
gen sex= . 
replace sex= 0 if ch04==2
replace sex= 1 if ch04==1
gen age = ch06
replace age= 0 if ch06<0 
gen group_age= . 
replace group_age=1 if age>=0 & age<30
replace group_age=2 if age>=30 & age<60
replace group_age=3 if age >=60 & age!=.

* calculate the mean per capita family income for each age group
tab group_age [w=pondih], sum(ipcf)

* equivalent income E (Amsterdam scale)
gen ae=1
replace ae=.98 if sex==1 & age==14 & age<=17
replace ae=.9 if sex==0 & age>=14
replace ae=.52 if age<14
replace ae = 0 if nro_hogar>=51 & nro_hogar<=91
egen aef=sum(ae), by(id)
gen ie_1= itf / (aef)^1
gen ie_2= itf / (aef)^(0.75)
gen ie_3= itf / (aef)^(0.5)
tab group_age [w=pondih], sum(ie_1)
tab group_age [w=pondih], sum(ie_2)
tab group_age [w=pondih], sum(ie_3)
