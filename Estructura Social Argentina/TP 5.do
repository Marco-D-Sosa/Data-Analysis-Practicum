capture cd "C:\Users\HP\Documents\ESA\TP5"
use "EPH_2023_S2_cruda.dta", clear

rename ch04 sexo
include fgt



/**************************************************************************************************

EJERCICIO 1: Calcular indicadores de necesidades básicas insatisfechas similares a los que utiliza el INDEC con los siguientes criterios:
a) Hacinamiento: hogares que tuvieran 4 o más personas por cuarto.
b) Vivienda: hogares que habitaran en una vivienda de tipo inconveniente.
c) Condiciones sanitarias: hogares que no tuvieran ningún tipo de retrete con descarga de agua.
d) Asistencia escolar: hogares que tuvieran algún niño en edad escolar (6 a 12 años) que no asista a la escuela.
e) Capacidad de subsistencia: hogares que tuvieran 4 o más personas por miembro ocupado y, además, cuyo jefe tuviera baja educación (primaria incompleta).

(i) Computar el porcentaje de hogares con carencias según cada criterio
(ii) Computar un índice de NBI con el criterio de la unión
(iii) Computar un índice de NBI con el criterio de la intersección
(iv) Repetir los puntos anteriores reemplazando simultáneamente el número de personas por cuarto de la condición de hacinamiento (a) por "3"; el rango de edad de la condición (d) por "6 a 17 años" y el requisito educativo del jefe en la condición (e) por "menos que secundaria completa".
(v) Comentar las diferencias de los resultados observados en (iv) respecto a los incisos anteriores (cambio en la definición de carencias).

**************************************************************************************************/



sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre)
drop if nro_hogar==51 | nro_hogar==71
mat ej1= J(7,1,.)

*(i)

*Criterio a)
rename ix_tot miembros
rename ii1 cuartos
replace cuartos=. if cuartos==99 | cuartos==0
gen aux= miembros/cuartos
gen NBI1 = 0
replace NBI1 = 1 if aux>=4
replace NBI1 = . if aux==.
drop aux

*Criterio b)
gen NBI2=1 if iv1==3 | iv1==4 | iv1==5 | iv1_esp!="" | iv12_3==1
replace NBI2=0 if iv12_3==2 & (iv1==1 | iv1==2)

*Criterio c)
sum iv10
gen NBI3=.
replace NBI3=1 if iv10!=1
replace NBI3=0 if iv10==1

*Criterio d)
rename ch06 edad
replace edad=0 if edad<0
gen asiste = 0 if ch10>=0 & ch10<=3
replace asiste = 1 if ch10==1
replace asiste = . if edad<5
gen aux = 0
replace aux = 1 if edad>=6 & edad<=12 & asiste==0
bys id: egen aux2=total(aux)
gen NBI4 = 0
replace NBI4 = 1 if aux2>=1 & aux2!=.
drop aux
drop aux2

*Criterio e)
gen ocupados = 1 if estado==1
replace ocupados = 0 if estado!=1
bys id: egen aux1=total(ocupados)
gen aux2 = miembros/aux1 
bys id: egen aux3=max(aux2)
*aux3 es el numero de miembros por ocupados
gen ed_jef = 0
replace ed_jef = 1 if ch03==1 & (nivel_ed==7 | nivel_ed==1)
bys id: egen aux4=max(ed_jef)
*aux4 es 1 cuando el jefe de hogar tiene baja educacion
gen NBI5 = 0
replace NBI5 = 1 if aux3>=4 & aux4==1
drop aux*

foreach n of numlist 1 2 3 4 5 {
	sum NBI`n' [w=pondera] if ch03==1
	mat ej1[`n',1]=r(mean)*100
}

*(ii)
gen NBI_U=.
replace NBI_U = 1 if NBI1==1 | NBI2==1 | NBI3==1 | NBI4==1 | NBI5==1
replace NBI_U = 0 if NBI1==0 & NBI2==0 & NBI3==0 & NBI4==0 & NBI5==0
sum NBI_U [w=pondera]
mat ej1[6,1]=r(mean)*100

*(iii)
gen NBI_I=.
replace NBI_I = 1 if NBI1==1 & NBI2==1 & NBI3==1 & NBI4==1 & NBI5==1
replace NBI_I = 0 if NBI1==0 | NBI2==0 | NBI3==0 | NBI4==0 | NBI5==0
sum NBI_I [w=pondera]
mat ej1[7,1]=r(mean)*100

*exporto columna a excel
preserve
   drop _all
   svmat ej1
   export excel using "TP5_Grupo10 (2°Entrega).xlsx", sheetmodify sheet("sheet1") cell(B5)
restore

*(iv)
mat ej1iv= J(7,1,.)

*Criterio a2)
gen aux= miembros/cuartos
gen nbi1 = 0
replace nbi1 = 1 if aux>=3
replace nbi1 = . if aux==.
drop aux

*Criterio b2)
gen nbi2=1 if iv1==3 | iv1==4 | iv1==5 | iv1_esp!="" | iv12_3==1
replace nbi2=0 if iv12_3==2 & (iv1==1 | iv1==2)

*Criterio c2)
gen nbi3=.
replace nbi3 = 1 if iv10!=1
replace nbi3 = 0 if iv10==1

*Criterio d2)
gen asiste2 = 0 if ch10>=0 & ch10<=3
replace asiste2 = 1 if ch10==1
replace asiste2 = . if edad<5
gen aux = 0
replace aux = 1 if edad>=6 & edad<=17 & asiste2==0
bys id: egen aux2=total(aux)
gen nbi4 = 0
replace nbi4 = 1 if aux2>=1 & aux2!=.
drop aux
drop aux2

*Criterio e2)
bys id: egen aux1=total(ocupados)
gen aux2 = miembros/aux1 
bys id: egen aux3=max(aux2)
*aux3 es el numero de miembros por ocupados
gen ed_jef2 = 0
replace ed_jef2 = 1 if ch03==1 & (nivel_ed==7 | nivel_ed==1 | nivel_ed==2 | nivel_ed==3)
bys id: egen aux4=max(ed_jef2)
*aux4 es 1 cuando el jefe de hogar tiene baja educacion
gen nbi5 = 0
replace nbi5 = 1 if aux3>=4 & aux4==1
drop aux*

foreach n of numlist 1 2 3 4 5 {
	sum nbi`n' [w=pondera] if ch03==1
	mat ej1iv[`n',1]=r(mean)*100
}

*(ii2)
gen nbi_u=.
replace nbi_u = 1 if nbi1==1 | nbi2==1 | nbi3==1 | nbi4==1 | nbi5==1
replace nbi_u = 0 if nbi1==0 & nbi2==0 & nbi3==0 & nbi4==0 & nbi5==0
sum nbi_u [w=pondera]
mat ej1iv[6,1]=r(mean)*100

*(iii2)
gen nbi_i=.
replace nbi_i = 1 if nbi1==1 & nbi2==1 & nbi3==1 & nbi4==1 & nbi5==1
replace nbi_i = 0 if nbi1==0 | nbi2==0 | nbi3==0 | nbi4==0 | nbi5==0
sum nbi_i [w=pondera]
mat ej1iv[7,1]=r(mean)*100

*exporto columna a excel
preserve
   drop _all
   svmat ej1iv
   export excel using "TP5_Grupo10 (2°Entrega).xlsx", sheetmodify sheet("sheet1") cell(D5)
restore



/**************************************************************************************************

Ejercicio 2. Suponer que un shock económico negativo (ej. la cuarentena del 2020) reduce el ingreso laboral de todos los trabajadores cuentapropistas no profesionales de y1 a y2 de forma proporcional; es decir, y2 = y1*(1-x). Calcular la tasa de pobreza y la brecha de la pobreza con la línea de pobreza moderada de Argentina (primer semestre del año 2022) para valores de x que vayan de 0 a 1 (a intervalos de 0.1). Graficar la tasa y la brecha de pobreza como función de x.

**************************************************************************************************/



recode sexo (2=0)

* Linea de pobreza oficial moderada
gen     lp_moderada = 57371.04667	if  trimestre==1 & region==1
replace lp_moderada = 46158.41		if  trimestre==1 & region==40 
replace lp_moderada = 48191.62333	if  trimestre==1 & region==41
replace lp_moderada = 54716.48		if  trimestre==1 & region==42
replace lp_moderada = 56860.36		if  trimestre==1 & region==43
replace lp_moderada = 68027.77667	if  trimestre==1 & region==44
replace	lp_moderada = 70518.15667	if  trimestre==2 & region==1
replace lp_moderada = 57040.05		if  trimestre==2 & region==40 
replace lp_moderada = 59127.90333	if  trimestre==2 & region==41
replace lp_moderada = 67447.15		if  trimestre==2 & region==42
replace lp_moderada = 69829.63333	if  trimestre==2 & region==43
replace lp_moderada = 82498.66667	if  trimestre==2 & region==44 

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

*calculamos ingreso por adulto equivalente por hogar
egen aef=total(ae), by(id)
gen ing_eq= itf/aef
label var ing_eq "ingreso oficial por adulto equivalente"
label var lp_moderada "Linea de pobreza moderada"

*generar el ingreso laboral familiar
replace p47t=. if p47t==-9
replace t_vi=. if t_vi==-9
gen ila = p47t - t_vi
replace ila=. if estado!=1
egen ilaf=sum(ila), by(id)
label var ilaf "Ingreso laboral familiar total"

*ingreso laboral ficticio (y2) - simulamos una caida del 10% del ingreso
mat ej2= J(11,2,.)
local cnt=1
forvalues x=0/10 {
    gen ila_sim`x'=ila
	
*afecta solo a cuentapropistas no profesionales
replace ila_sim`x'=ila*(1-`x'/10) if (cat_ocup==2 & estado==1) & ((nivel_ed>=1 & nivel_ed<=5) | nivel_ed==7)
*Generar el ingreso laboral familiar simulado
egen ilaf_sim`x'=sum(ila_sim`x'), by(id)
label var ilaf_sim`x' "Ingreso Laboral Familiar Total Simulado"
*Generar Nuevo Ingreso Familiar 
gen itf_sim`x'=(itf - ilaf + ilaf_sim`x')
replace itf_sim`x'=0 if itf_sim`x' < 0
*Generar Nuevo Ingreso Por Adulto Equivalente
gen ing_eq_sim`x' = itf_sim`x'/aef
*Calcula Tasa y Brecha
fgt ing_eq_sim`x' [w=pondih] if ing_eq_sim`x'!=., a(0) z(lp_moderada)
mat ej2[`cnt',1]=r(fgt)
fgt ing_eq_sim`x' [w=pondih] if ing_eq_sim`x'!=., a(1) z(lp_moderada)
mat ej2[`cnt',2]=r(fgt)

local ++cnt
}

*exporto columna a excel
preserve
   drop _all
   svmat ej2
   export excel using "TP5_Grupo10 (2°Entrega).xlsx", sheetmodify sheet("sheet2") cell(D5)
restore



/**************************************************************************************************

Ejercicio 3. Estimar el número de hogares beneficiarios y el costo fiscal de un bono de $50.000 por cada hogar que cumpla con los siguientes requisitos:
• No hay ningún trabajador asalariado formal en el hogar
• Ni el jefe ni su cónyuge reciben pagos por jubilaciones
Mostrar la sensibilidad de estos resultados si (i) el subsidio se otorga al jefe y cónyuge de cada hogar (en lugar de un solo beneficio por hogar); (ii) el beneficio (uno por hogar) se otorga solo a hogares con niños menores de 12 años.

**************************************************************************************************/



mat ej3=J(3,2,.)
local bono=50000

*No hay ningun trabajador asalariado formal en el hogar
gen aux1=0
replace aux1=1 if estado==1 & cat_ocup==3 & pp07h==1
bysort id: egen cond1=max(aux1)

*Ni el jefe ni su conyuge reciben pagos por jubilaciones
gen aux2=0
replace aux2=1 if (ch03==1 | ch03==2) & cat_inac==1
bysort id: egen cond2=max(aux2)

*hogares beneficiarios y Costo fiscal
gen benef=0
replace benef=1 if ch03==1 & cond1==0 & cond2==0
ta benef [w=pondera] if ch03==1
sum benef [w=pondera] if ch03==1 & benef==1
mat ej3[1,1]=r(sum_w)
mat ej3[1,2]=r(sum_w)* `bono'

*(i) el subsidio se otorga al jefe y cónyuge de cada hogar (en lugar de un solo beneficio por hogar)
gen benef_i=0
replace benef_i=1 if (ch03==1 | ch03==2) & cond1==0 & cond2==0
ta benef_i [w=pondera] if (ch03==1 | ch03==2)
sum benef_i [w=pondera] if (ch03==1 | ch03==2) & benef_i==1
mat ej3[2,1]=r(sum_w)
mat ej3[2,2]=r(sum_w)* `bono'

*(ii) el beneficio (uno por hogar) se otorga solo a hogares con niños menores de 12 años.
gen aux3=1 if edad<12
egen cond3 = count(aux3), by(id)
gen benef_ii=0 
replace benef_ii=1 if ch03==1 & cond1==0 & cond2==0 & cond3>=1
ta benef_ii [w=pondera] if ch03==1
sum benef_ii [w=pondera] if ch03==1 & benef_ii==1
mat ej3[3,1]=r(sum_w)
mat ej3[3,2]=r(sum_w)* `bono'

*expotar matriz 
preserve
drop _all
local tablas "ej3" 
foreach mat of local tablas {
*double para q sea mas exacta
svmat double `mat'
export excel using "TP5_grupo10 (2°Entrega).xlsx", sheet("sheet3") cell("B5") sheetmodify 
}
restore



