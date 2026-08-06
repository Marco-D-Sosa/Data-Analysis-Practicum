capture cd "C:\Users\HP\Documents\ESA\TP4"
use "EPH_2023_S2_cruda.dta", clear




/***************************************************************************************************
********************************************EJERCICIO 1:********************************************
****************************************************************************************************


(A) Caracterizar a la población adulta (25-65 años) del total del país en función de su nivel educativo en las siguientes categorías:
1.Primaria incompleta.
2.Primaria completa.
3.Secundaria incompleta.
4.Secundaria completa.
5.Superior incompleta.
6.Superior completa.
*/
mat ej1= J(7,6,.)
ta nivel_ed
gen nivel=nivel_ed
replace nivel=1 if nivel_ed==7
replace nivel=. if nivel_ed==9
label var nivel "nivel educativo"
gen edad = ch06
replace edad=0 if edad<0

table nivel if edad>=25 & edad<=65, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("A7") sheetmodify
restore


*(B) Repetir el ejercicio para las regiones argentinas.
label define regiones 1"GBA" 40"Noroeste" 41"Noreste" 42"Cuyo" 43"Pampeana" 44"Patagonia"
label values region regiones

*GBA
table nivel if edad>=25 & edad<=65 & region==1, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==1, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("D7") sheetmodify
restore

*Region Noroeste
table nivel if edad>=25 & edad<=65 & region==40, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==40, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("G7") sheetmodify
restore

*Noreste
table nivel if edad>=25 & edad<=65 & region==41, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==41, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("J7") sheetmodify
restore

*Cuyo
table nivel if edad>=25 & edad<=65 & region==42, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==42, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("M7") sheetmodify
restore

*Pampeana
table nivel if edad>=25 & edad<=65 & region==43, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==43, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("P7") sheetmodify
restore

*Patagonia
table nivel if edad>=25 & edad<=65 & region==44, c(sum pondera)
preserve
 table nivel if edad>=25 & edad<=65 & region==44, c(sum pondera) replace row
 gen share=(table1/table1[1])*100
 mkmat nivel share, mat(tabla)
 mat tabla2 = tabla
 drop _all
 svmat tabla2
 export excel using "TP4_grupo10.xlsx", sheet("ej1_raw") cell("S7") sheetmodify
restore


*(c) Comentar los resultados.

*Ejercicio 2

mat ej2= J(2,4,.)

* N�mero total de alumnos o estudiantes de cualquier edad matriculados en un determinado nivel de enseñanza (neta es con la edad correspondiente)

ta ch10 

gen asiste = . 
replace asiste = 0		if  ch10==2 | ch10==3 
replace asiste = 1		if  ch10==1

gen gedad=.
replace gedad=1 if edad>=3  & edad<=5
replace gedad=2 if edad>=6  & edad<=12
replace gedad=3 if edad>=13 & edad<=17
replace gedad=4 if edad>=18 & edad<=23 


sort ipcf, stable
gen sumpop=sum(pondih)
gen double ppquintil=sumpop[_N]/5
gen quintil=0
replace quintil=1 if sumpop>0 & sumpop<=ppquintil
replace quintil=2 if sumpop>ppquintil & sumpop<=ppquintil*2
replace quintil=3 if sumpop>ppquintil*2 & sumpop<=ppquintil*3
replace quintil=4 if sumpop>ppquintil*3 & sumpop<=ppquintil*4
replace quintil=5 if sumpop>ppquintil*4 & sumpop<=ppquintil*5
table quintil [w=pondih], c(mean ipcf median ipcf sum ipcf) row format (%20.3f)

*(a)
table gedad [w=pondera], c(mean asiste)
*(b)
table gedad [w=pondera] if quintil==1, c(mean asiste)
table gedad [w=pondera] if quintil==2, c(mean asiste)
table gedad [w=pondera] if quintil==3, c(mean asiste)
table gedad [w=pondera] if quintil==4, c(mean asiste)
table gedad [w=pondera] if quintil==5, c(mean asiste)




*Ejercicio 3. Calcular la participación laboral para el grupo de personas de entre 25 y 64 años
**Para ello sera necesario primero generar las variables del mercado laboral 

gen PEA=1 if (estado==1| estado==2)
replace PEA=0 if estado==3
label var PEA"=1 si activo"

sum PEA[w=pondera]

gen edad=ch06

replace edad=0 if edad<0

*(a) Por género
gen hombre=. 
replace hombre=0 if ch04==2
replace hombre=1 if ch04==1

mat ej=J(1,7,.)

forvalues s= 0/1 {
	sum PEA [w=pondera] if edad>=25 & edad<=64 & hombre==`s'
	mat ej[1,1+`s']= r(mean)*100
	
}

*(b) Por nivel educativo, dividiendo a las personas según tengan educación baja [primaria completa o menos], media [secundaria incompleta a superior incompleta] o alta [superior completa]

gen     nivedu=1     if (nivel_ed>=1 & nivel_ed<=2)| nivel_ed==7
replace nivedu=2     if nivel_ed>=3 & nivel_ed<=5
replace nivedu=3     if nivel_ed==6

forvalues n=1/3 {
	sum PEA [w=pondera] if edad>=25 & edad<=64 & nivedu==`n'
	mat ej[1,3+`n']=r(mean)*100
	
} 

*(c) Por grupo etario, considerando los siguientes grupos: [15-24]; [25-64]; [+65].

gen grupoetario=.
replace grupoetario=1 if edad>=15 & edad<=24
replace grupoetario=2 if edad>=24 & edad<=64 
replace grupoetario=3 if edad>=65 

sum PEA[w=pondera] if grupoetario==1
sum PEA[w=pondera] if grupoetario==2
sum PEA[w=pondera] if grupoetario==3

*Ejercicio 4. El siguiente gráfico reporta la tasa de desempleo para personas de
entre 25 y 64 años por nivel educativo y por región para Argentina en el año 2020.

*Realizar el mismo gráfico reemplazando los grupos educativos por:
(a) Grupos etarios [15-24]; [25-64]; [+65] (No condicionar en este inciso por la restricción etaria de 25 a 64 años)

gen desocupa= 0 if (estado==1 | estado==3)
replace desocupa=1 if estado==2 
label var desocupa "=1 si desocupado"

gen aux_des=(desocupa/(PEA/100))*100

table region grupoetario [w=pondera], c(mean aux_des)

*(b) Género, para personas de entre 25 y 64 años.

table region hombre [w=pondera], c(mean aux_des)





