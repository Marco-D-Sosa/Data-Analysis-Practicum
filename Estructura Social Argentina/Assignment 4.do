capture cd ""  // Put the path here <----

use "EPH_2023_S2_cruda.dta", clear



/*
Exercise 1:
(a) Characterize the country's adult population (aged 25–65) based on educational attainment, using the following categories:
1. Incomplete primary education.
2. Complete primary education.
3. Incomplete secondary education.
4. Complete secondary education.
5. Incomplete higher education.
6. Complete higher education.
*/
mat ej1= J(7,6,.)
ta nivel_ed
gen level = nivel_ed
replace level=1 if nivel_ed==7
replace level=. if nivel_ed==9
label var level "educational level"
gen age = ch06
replace age=0 if age<0
table level if age>=25 & age<=65, c(sum pondera)

preserve
 table level if age>=25 & age<=65, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("A7") sheetmodify
restore

*(b) Repeat the exercise for the Argentine regions
label define regiones 1"GBA" 40"Noroeste" 41"Noreste" 42"Cuyo" 43"Pampeana" 44"Patagonia"
label values region regiones

* GBA
table level if age>=25 & age<=65 & region==1, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==1, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("D7") sheetmodify
restore

* Noroeste
table level if age>=25 & age<=65 & region==40, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==40, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("G7") sheetmodify
restore

* Noreste
table level if age>=25 & age<=65 & region==41, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==41, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("J7") sheetmodify
restore

* Cuyo
table level if age>=25 & age<=65 & region==42, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==42, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("M7") sheetmodify
restore

* Pampeana
table level if age>=25 & age<=65 & region==43, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==43, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("P7") sheetmodify
restore

* Patagonia
table level if age>=25 & age<=65 & region==44, c(sum pondera)
preserve
 table level if age>=25 & age<=65 & region==44, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat level share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "Assign4_group10.xlsx", sheet("e1_raw") cell("S7") sheetmodify
restore



* Exercise 2: Total number of pupils or students of any age enrolled at a specific level of education (net enrollment refers to the corresponding age group)

mat ej2= J(2,4,.)
ta ch10 
gen attends = . 
replace attends = 0		if  ch10==2 | ch10==3 
replace attends = 1		if  ch10==1
gen gage=.
replace gage=1 if age>=3  & age<=5
replace gage=2 if age>=6  & age<=12
replace gage=3 if age>=13 & age<=17
replace gage=4 if age>=18 & age<=23 
sort ipcf, stable
gen sumpop=sum(pondih)
gen double ppquintil=sumpop[_N]/5
gen quintile=0
replace quintile=1 if sumpop>0 & sumpop<=ppquintil
replace quintile=2 if sumpop>ppquintil & sumpop<=ppquintil*2
replace quintile=3 if sumpop>ppquintil*2 & sumpop<=ppquintil*3
replace quintile=4 if sumpop>ppquintil*3 & sumpop<=ppquintil*4
replace quintile=5 if sumpop>ppquintil*4 & sumpop<=ppquintil*5
table quintile [w=pondih], c(mean ipcf median ipcf sum ipcf) row format (%20.3f)

*(a)
table gage [w=pondera], c(mean attends)

*(b)
table gage [w=pondera] if quintile==1, c(mean attends)
table gage [w=pondera] if quintile==2, c(mean attends)
table gage [w=pondera] if quintile==3, c(mean attends)
table gage [w=pondera] if quintile==4, c(mean attends)
table gage [w=pondera] if quintile==5, c(mean attends)



* Exercise 3: Calculate labor force participation for the 25–64 age group
* To do this, it will first be necessary to generate the labor market variables

gen PEA=1 if (estado==1| estado==2)
replace PEA=0 if estado==3
label var PEA"=1 if active"
sum PEA[w=pondera]

gen age=ch06
replace age=0 if age<0

*(a) per gender
gen men=. 
replace men=0 if ch04==2
replace men=1 if ch04==1
mat ej=J(1,7,.)

forvalues s= 0/1 {
	sum PEA [w=pondera] if age>=25 & age<=64 & men==`s'
	mat ej[1,1+`s']= r(mean)*100
	
}

*(b) By educational level, classifying individuals according to whether they have low [completed primary education or less], medium [incomplete secondary to incomplete higher education], or high [completed higher education] levels of education

gen     nivedu=1     if (nivel_ed>=1 & nivel_ed<=2)| nivel_ed==7
replace nivedu=2     if nivel_ed>=3 & nivel_ed<=5
replace nivedu=3     if nivel_ed==6

forvalues n=1/3 {
	sum PEA [w=pondera] if age>=25 & age<=64 & nivedu==`n'
	mat ej[1,3+`n']=r(mean)*100
	
} 

*(c) By age group, considering the following groups: [15–24]; [25–64]; [65+]
gen age_group=.
replace age_group=1 if age>=15 & age<=24
replace age_group=2 if age>=24 & age<=64 
replace age_group=3 if age>=65 
sum PEA[w=pondera] if age_group==1
sum PEA[w=pondera] if age_group==2
sum PEA[w=pondera] if age_group==3



* Exercise 4: The following graph shows the unemployment rate for individuals aged 25 to 64 by education level and region in Argentina for the year 2020; create the same graph, replacing the education groups with:

*(a) Age groups [15–24]; [25–64]; [65+] (Do not apply the 25–64 age restriction to this item)
gen unemploy= 0 if (estado==1 | estado==3)
replace unemploy=1 if estado==2 
label var unemploy "=1 if unemployed"
gen aux_des=(unemploy/(PEA/100))*100
table region age_group [w=pondera], c(mean aux_des)

*(b) Gender, for people aged 25 to 64
table region hombre [w=pondera], c(mean aux_des)
