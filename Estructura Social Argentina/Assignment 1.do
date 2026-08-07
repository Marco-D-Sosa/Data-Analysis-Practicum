cd ""  // Puth the pathe here <----

use "arg_eph_23s1_tp1", clear
sort id



** Exercise 1: Calculate the following basic demographic indicators for Argentina as a whole and for each of its regions

*(a) Number of observations in the EPH (persons), unweighted
sum pondera
display as text "number of unweighted national observations: " as result r(N)
sum pondera if region==1
display as text "number of unweighted GBA observations: " as result r(N)
sum pondera if region==2
display as text "number of unweighted Pampeana observations: " as result r(N)
sum pondera if region ==3
display as text "number of unweighted Cuyo observations: " as result r(N)
sum pondera if region ==4
display as text "number of unweighted NOA observations: " as result r(N)
sum pondera if region ==5
display as text "number of unweighted Patagonia observations: " as result r(N)
sum pondera if region ==6
display as text "number of unweighted NEA observations: " as result r(N)

*(b) Number of observations in the EPH (persons)
sum pondera
display as text "number of expanded national observations: " as result r(sum)
sum pondera if region==1
display as text "number of expanded GBA observations: " as result r(sum)
sum pondera if region==2
display as text "number of expanded Pampeana observations: " as result r(sum)
sum pondera if region ==3
display as text "number of expanded Cuyo observations: " as result r(sum)
sum pondera if region ==4
display as text "number of expanded NOA observations: " as result r(sum)
sum pondera if region ==5
display as text "number of expanded Patagonia observations: " as result r(sum)
sum pondera if region ==6
display as text "number of expanded NEA observations: " as result r(sum)

*(c) Average age
sum edad [w=pondera]
display as text "national average age: " as result r(mean)
sum edad [w=pondera] if region ==1
display as text "GBA average age: " as result r(mean)
sum edad [w=pondera] if region ==2
display as text "Pampeana average age: " as result r(mean)
sum edad [w=pondera] if region ==3
display as text "Cuyo average age: " as result r(mean)
sum edad [w=pondera] if region ==4
display as text "NOA average age: " as result r(mean)
sum edad [w=pondera] if region ==5
display as text "Patagonia average age: " as result r(mean)
sum edad [w=pondera] if region ==6
display as text "NEA average age: " as result r(mean)

*(d) Percentage of women
sum sexo [w=pondera]
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2
display as text "national percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==1
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==1 
display as text "GBA percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==2
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==2
display as text "Pampeana percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==3
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==3
display as text "Cuyo percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==4
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==4
display as text "NOA percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==5
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==5
display as text "Patagonia percentage of women: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==6
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==6 
display as text "NEA percentage of women: " as result (r(sum_w)/`total')*100

*(e) Percentage of children under 13 (excluding those aged 13)
sum edad [w=pondera]
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region !=.
display as text "national percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==1
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==1
display as text "GBA percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==2
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==2
display as text "Pampeana percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==3
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==3
display as text "Cuyo percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==4
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==4
display as text "NOA percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==5
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==5
display as text "Patagonia percentage of children under 13: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==6
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==6
display as text "NEA percentage of children under 13: " as result (r(sum_w)/`total')*100

*(f) Percentage of adults over the age of 64 (excluding those aged 64)
sum edad [w=pondera] 
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region !=.
display as text "national percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==1
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==1
display as text "GBA percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==2
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==2
display as text "Pampeana percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==3
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==3
display as text "Cuyo percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==4
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==4
display as text "NOA percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==5
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==5
display as text "Patagonia percentage of adults over 64: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==6
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==6
display as text "NEA percentage of adults over 64: " as result (r(sum_w)/`total')*100



* Exercise 2: The following graph shows the percentage of men and women by age group for Ecuador in 2018.
* Using the following groups—[0-9], [10-19], [20-29], [30-39], [40-49], [50-59], [60-69], [70-79], [80-89], [90 and over]—you are asked to:
gen group_age=.
replace group_age=1 if edad>=0 & edad<10
replace group_age=2 if edad>=10 & edad<20
replace group_age=3 if edad>=20 & edad<30
replace group_age=4 if edad>=30 & edad<40
replace group_age=5 if edad>=40 & edad<50
replace group_age=6 if edad>=50 & edad<60
replace group_age=7 if edad>=60 & edad<70
replace group_age=8 if edad>=70 & edad<80
replace group_age=9 if edad>=80 & edad<90
replace group_age=10 if edad>=90 & edad!=.

*(a) Create the graph for the total for Argentina
sum group_age [w=pondera] if region !=.
local total = r(sum_w)
sum group_age [w=pondera] if group_age ==1 & sexo ==2
display as text "Percentage of females aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==1 & sexo ==1
display as text "Percentage of males aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==2
display as text "Percentage of females aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==1
display as text "Percentage of males aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==2
display as text "Percentage of females aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==1
display as text "Percentage of males aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==2
display as text "Percentage of females aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==1
display as text "Percentage of males aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==2
display as text "Percentage of females aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==1
display as text "Percentage of males aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==2
display as text "Percentage of females aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==1
display as text "Percentage of males aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==2
display as text "Percentage of females aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==1
display as text "Percentage of males aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==2
display as text "Percentage of females aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==1
display as text "Percentage of males aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==2
display as text "Percentage of females aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==1
display as text "Percentage of males aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==2
display as text "Percentage of females aged 90 and over: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==1
display as text "Percentage of males aged 90 and over: " as result (r(sum_w)/`total')*100

*(b) Create the graph for "Capital Federal" and for the Northwest (NOA)

* NOA
sum group_age [w=pondera] if region ==4
local total = r(sum_w)
sum group_age [w=pondera] if group_age ==1 & sexo ==2 & region ==4
display as text "Percentage of females aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==1 & sexo ==1 & region ==4
display as text "Percentage of males aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==2 & region ==4
display as text "Percentage of females aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==1 & region ==4
display as text "Percentage of males aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==2 & region ==4
display as text "Percentage of females aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==1 & region ==4
display as text "Percentage of males aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==2 & region ==4
display as text "Percentage of females aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==1 & region ==4
display as text "Percentage of males aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==2 & region ==4
display as text "Percentage of females aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==1 & region ==4
display as text "Percentage of males aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==2 & region ==4
display as text "Percentage of females aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==1 & region ==4
display as text "Percentage of males aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==2 & region ==4
display as text "Percentage of females aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==1 & region ==4
display as text "Percentage of males aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==2 & region ==4
display as text "Percentage of females aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==1 & region ==4
display as text "Percentage of males aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==2 & region ==4
display as text "Percentage of females aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==1 & region ==4
display as text "Percentage of males aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==2 & region ==4
display as text "Percentage of females aged 90 and over: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==1 & region ==4
display as text "Percentage of males aged 90 and over: " as result (r(sum_w)/`total')*100

* Capital Federal
sum group_age [w=pondera] if region ==1
local total = r(sum_w)
sum group_age [w=pondera] if group_age ==1 & sexo ==2 & region ==1
display as text "Percentage of females aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==1 & sexo ==1 & region ==1
display as text "Percentage of males aged 0 to 9: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==2 & region ==1
display as text "Percentage of females aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==2 & sexo ==1 & region ==1
display as text "Percentage of males aged 10 to 19: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==2 & region ==1
display as text "Percentage of females aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==3 & sexo ==1 & region ==1
display as text "Percentage of males aged 20 to 29: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==2 & region ==1
display as text "Percentage of females aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==4 & sexo ==1 & region ==1
display as text "Percentage of males aged 30 to 39: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==2 & region ==1
display as text "Percentage of females aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==5 & sexo ==1 & region ==1
display as text "Percentage of males aged 40 to 49: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==2 & region ==1
display as text "Percentage of females aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==6 & sexo ==1 & region ==1
display as text "Percentage of males aged 50 to 59: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==2 & region ==1
display as text "Percentage of females aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==7 & sexo ==1 & region ==1
display as text "Percentage of males aged 60 to 69: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==2 & region ==1
display as text "Percentage of females aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==8 & sexo ==1 & region ==1
display as text "Percentage of males aged 70 to 79: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==2 & region ==1
display as text "Percentage of females aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==9 & sexo ==1 & region ==1
display as text "Percentage of males aged 80 to 89: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==2 & region ==1
display as text "Percentage of females aged 90 and over: " as result (r(sum_w)/`total')*100
sum group_age [w=pondera] if group_age ==10 & sexo ==1 & region ==1
display as text "Percentage of males aged 90 and over: " as result (r(sum_w)/`total')*100



* Exercise 3: Present an age profile of per capita family income (variable *ipcf*) similar to the following graph. Use a second-degree polynomial (in Excel) to smooth the series (red line)

forvalues r = 0/99 {
sum ipcf [w=pondera] if edad ==`r'
display as text "ingreso per capita familiar para edad `r': " r(mean)
}



* Exercise 4: Present a table showing some basic housing characteristics. Carry out the exercise only for "heads of household." Report:

* National Total 
*(4.1) Percentage of homeowners
sum propieta [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)
sum propieta [w=pondera] if jefe==1 & propieta==1 & region!=. 
display as text "Percentage of homeowners nationwide:" as result (r(sum_w)/`tot')*100
*(4.2) Average number of rooms
sum habita [w=pondera] if jefe==1 & region!=.
display as text "Average number of rooms nationwide:" as result r(mean)
*(4.3) Percentage with access to water
sum agua [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)
sum agua [w=pondera] if jefe==1 & agua==1 & region!=.
display as text "Percentage with access to water:" as result (r(sum_w)/`tot')*100
*(4.4) Percentage with access to the sewer system
sum cloaca [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)
sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region!=. 
display as text "Percentage with access to the sewer system:" as result (r(sum_w)/`tot')*100

* NEA
*(4.1) Percentage of homeowners 
sum propieta [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)
sum propieta [w=pondera] if jefe==1 & propieta==1 & region==6
display as text "Percentage of homeowners in the NEA region:" as result (r(sum_w)/`tot')*100
*(4.2) Average number of rooms
sum habita [w=pondera] if jefe==1 & region==6
display as text "Average number of rooms in the NEA:" as result r(mean)
*(4.3) Percentage with access to water
sum agua [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)
sum agua [w=pondera] if jefe==1 & agua==1 & region==6
display as text "Percentage of access to water in the NEA region:" as result (r(sum_w)/`tot')*100
*(4.4) Percentage with access to the sewer system
sum cloaca [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)
sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region==6
display as text "Percentage of access to the sewer system in the NEA region:" as result (r(sum_w)/`tot')*100

* Patagonia
*(4.1) Percentage of homeowners
sum propieta [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)
sum propieta [w=pondera] if jefe==1 & propieta==1 & region==5
display as text "Percentage of homeowners in Patagonia:" as result (r(sum_w)/`tot')*100
*(4.2) Average number of rooms
sum habita [w=pondera] if jefe==1 & region==5
display as text "Average number of rooms in Patagonia:" as result r(mean)
*(4.3) Percentage with access to water 
sum agua [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)
sum agua [w=pondera] if jefe==1 & agua==1 & region==5
display as text "Percentage of access to water in Patagonia:" as result (r(sum_w)/`tot')*100
*(4.4) Percentage with access to the sewer system
sum cloaca [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)
sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region==5
display as text "Percentage of access to the sewer system in Patagonia:" as result (r(sum_w)/`tot')*100
