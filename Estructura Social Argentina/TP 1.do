cd "C:\Users\HP\Documents\ESA\TP1"
use "arg_eph_23s1_tp1", clear
sort id




**Ejercicio 1**
*Calcular los siguientes indicadores demograficos basicos para el total de Argentina y para cada una de sus regiones


*(a). numero de observaciones en la EPH (personas), no expandido
sum pondera
display as text "cantidad de observaciones no expandido nacional: " as result r(N)
sum pondera if region==1
display as text "cantidad de observaciones no expandido GBA: " as result r(N)
sum pondera if region==2
display as text "cantidad de observaciones no expandido Pampeana: " as result r(N)
sum pondera if region ==3
display as text "cantidad de observaciones no expandido Cuyo: " as result r(N)
sum pondera if region ==4
display as text "cantidad de observaciones no expandido NOA: " as result r(N)
sum pondera if region ==5
display as text "cantidad de observaciones no expandido Patagonia: " as result r(N)
sum pondera if region ==6
display as text "cantidad de observaciones no expandido NEA: " as result r(N)


*(b). Número de observaciones en la EPH (personas)
sum pondera
display as text "cantidad de observaciones expandido nacional: " as result r(sum)
sum pondera if region==1
display as text "cantidad de observaciones expandido GBA: " as result r(sum)
sum pondera if region==2
display as text "cantidad de observaciones expandido Pampeana: " as result r(sum)
sum pondera if region ==3
display as text "cantidad de observaciones expandido Cuyo: " as result r(sum)
sum pondera if region ==4
display as text "cantidad de observaciones expandido NOA: " as result r(sum)
sum pondera if region ==5
display as text "cantidad de observaciones expandido Patagonia: " as result r(sum)
sum pondera if region ==6
display as text "cantidad de observaciones expandido NEA: " as result r(sum)


*(c). Edad promedio
sum edad [w=pondera]
display as text "edad promedio nacional: " as result r(mean)
sum edad [w=pondera] if region ==1
display as text "edad promedio GBA: " as result r(mean)
sum edad [w=pondera] if region ==2
display as text "edad promedio Pampeana: " as result r(mean)
sum edad [w=pondera] if region ==3
display as text "edad promedio Cuyo: " as result r(mean)
sum edad [w=pondera] if region ==4
display as text "edad promedio NOA: " as result r(mean)
sum edad [w=pondera] if region ==5
display as text "edad promedio Patagonia: " as result r(mean)
sum edad [w=pondera] if region ==6
display as text "edad promedio NEA: " as result r(mean)


*(d). Porcentaje de mujeres
sum sexo [w=pondera]
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2
display as text "porcentaje de mujeres nacional: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==1
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==1 
display as text "porcentaje de mujeres GBA: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==2
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==2
display as text "porcentaje de mujeres Pampeana: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==3
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==3
display as text "porcentaje de mujeres Cuyo: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==4
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==4
display as text "porcentaje de mujeres NOA: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==5
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==5
display as text "porcentaje de mujeres Patagonia: " as result (r(sum_w)/`total')*100
sum sexo [w=pondera] if region ==6
local total= r(sum_w)
sum sexo [w=pondera] if sexo==2 & region ==6 
display as text "porcentaje de mujeres NEA: " as result (r(sum_w)/`total')*100


*(e). Porcentaje de niños menores de 13 (no incluye los de 13)
sum edad [w=pondera]
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region !=.
display as text "porcentaje de niños menores de 13 nacional: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==1
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==1
display as text "porcentaje de niños menores de 13 GBA: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==2
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==2
display as text "porcentaje de niños menores de 13 Pampeana: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==3
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==3
display as text "porcentaje de niños menores de 13 Cuyo: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==4
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==4
display as text "porcentaje de niños menores de 13 NOA: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==5
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==5
display as text "porcentaje de niños menores de 13 Patagonia: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==6
local total = r(sum_w)
sum edad [w=pondera] if edad < 13 & region ==6
display as text "porcentaje de niños menores de 13 NEA: " as result (r(sum_w)/`total')*100


*(f). Porcentaje de adultos mayores de 64 años (no incluye los de 64)
sum edad [w=pondera] 
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region !=.
display as text "porcentaje de adultos mayores de 64 nacional: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==1
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==1
display as text "porcentaje de adultos mayores de 64 GBA: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==2
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==2
display as text "porcentaje de adultos mayores de 64 Pampeana: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==3
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==3
display as text "porcentaje de adultos mayores de 64 Cuyo: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==4
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==4
display as text "porcentaje de adultos mayores de 64 NOA: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==5
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==5
display as text "porcentaje de adultos mayores de 64 Patagonia: " as result (r(sum_w)/`total')*100
sum edad [w=pondera] if region ==6
local total = r(sum_w)
sum edad [w=pondera] if edad > 64 & region ==6
display as text "porcentaje de adultos mayores de 64 NEA: " as result (r(sum_w)/`total')*100




*Ejercicio 2* El siguiente gráfico reporta el porcentaje de hombres y mujeres por grupo de edad, para Ecuador en el año 2018.
*Tomando los siguientes grupos:[0-9], [10-19], [20-29], [30-39], [40-49], [50-59],[60-69], [70-79], [80-89], [90 y más], se pide:
gen grupo_edad=.
replace grupo_edad=1 if edad>=0 & edad<10
replace grupo_edad=2 if edad>=10 & edad<20
replace grupo_edad=3 if edad>=20 & edad<30
replace grupo_edad=4 if edad>=30 & edad<40
replace grupo_edad=5 if edad>=40 & edad<50
replace grupo_edad=6 if edad>=50 & edad<60
replace grupo_edad=7 if edad>=60 & edad<70
replace grupo_edad=8 if edad>=70 & edad<80
replace grupo_edad=9 if edad>=80 & edad<90
replace grupo_edad=10 if edad>=90 & edad!=.


*(a) Realizar el gráfico para el total de Argentina
sum grupo_edad [w=pondera] if region !=.
local total = r(sum_w)
sum grupo_edad [w=pondera] if grupo_edad ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==1 & sexo ==1
display as text "Porcentaje de hombres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & sexo ==2
display as text "Porcentaje de mujeres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & sexo ==1
display as text "Porcentaje de hombres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & sexo ==2
display as text "Porcentaje de mujeres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & sexo ==1
display as text "Porcentaje de hombres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & sexo ==1
display as text "Porcentaje de hombres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & sexo ==2
display as text "Porcentaje de mujeres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & sexo ==1
display as text "Porcentaje de hombres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & sexo ==2
display as text "Porcentaje de mujeres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & sexo ==1
display as text "Porcentaje de hombres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & sexo ==2
display as text "Porcentaje de mujeres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & sexo ==1
display as text "Porcentaje de hombres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & sexo ==2
display as text "Porcentaje de mujeres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & sexo ==1
display as text "Porcentaje de hombres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & sexo ==2
display as text "Porcentaje de mujeres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & sexo ==1
display as text "Porcentaje de hombres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & sexo ==2
display as text "Porcentaje de mujeres entre 90 y + años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & sexo ==1
display as text "Porcentaje de hombres entre 90 y + años: " as result (r(sum_w)/`total')*100


*(b) Realizar el gráfico para Capital Federal y para el Noroeste (NOA)

*NOA
sum grupo_edad [w=pondera] if region ==4
local total = r(sum_w)
sum grupo_edad [w=pondera] if grupo_edad ==1 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==1 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & region ==4 & sexo ==2
display as text "Porcentaje de mujeres entre 90 y + años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & region ==4 & sexo ==1
display as text "Porcentaje de hombres entre 90 y + años: " as result (r(sum_w)/`total')*100

*Capital Federal

sum grupo_edad [w=pondera] if region ==1
local total = r(sum_w)
sum grupo_edad [w=pondera] if grupo_edad ==1 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==1 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 0 y 9 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==2 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 10 y 19 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==3 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 20 y 29 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==4 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 30 y 39 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==5 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 40 y 49 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==6 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 50 y 59 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==7 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 60 y 69 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==8 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 70 y 79 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==9 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 80 y 89 años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & region ==1 & sexo ==2
display as text "Porcentaje de mujeres entre 90 y + años: " as result (r(sum_w)/`total')*100
sum grupo_edad [w=pondera] if grupo_edad ==10 & region ==1 & sexo ==1
display as text "Porcentaje de hombres entre 90 y + años: " as result (r(sum_w)/`total')*100

*(c) Comentar las diferencias observadas en el punto (b).




*Ejercicio 3*
*Presentar un perfil etario del ingreso per cápita familiar (variable ipcf) semejante al siguiente gráfico. Utilizar (en Excel) un polinomio de grado 2 para suavizar la serie (línea en rojo)


forvalues r = 0/99 {

sum ipcf [w=pondera] if edad ==`r'
display as text "ingreso per capita familiar para edad `r': " r(mean)

}




* Ejercicio 4*
*Presentar un cuadro de algunas características habitacionales básicas. Realizar el ejercicio solo para los “jefes de hogar”. Reportar:


***Total Pais**
***(4.1)Porcentaje de propietarios de su vivienda 
sum propieta [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)

sum propieta [w=pondera] if jefe==1 & propieta==1 & region!=. 
display as text "Porcentaje de Propietarios de su vivienda en el total país:" as result (r(sum_w)/`tot')*100

***(4.2)Número promedio de habitaciones
sum habita [w=pondera] if jefe==1 & region!=.
display as text "Número promedio de habitaciones en el total país:" as result r(mean)

***(4.3)Porcentaje con acceso al agua 
sum agua [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)

sum agua [w=pondera] if jefe==1 & agua==1 & region!=.
display as text "Porcentaje con acceso al agua:" as result (r(sum_w)/`tot')*100

***(4.4)Porcentaje con acceso a cloacas 
sum cloaca [w=pondera] if jefe==1 & region!=.
local tot= r(sum_w)

sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region!=. 
display as text "Porcentaje con acceso a cloaca:" as result (r(sum_w)/`tot')*100

**NEA**
***(4.1)Porcentaje de propietarios de su vivienda 
sum propieta [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)

sum propieta [w=pondera] if jefe==1 & propieta==1 & region==6
display as text "Porcentaje de Propietarios de su vivienda en NEA:" as result (r(sum_w)/`tot')*100


***(4.2)Número promedio de habitaciones
sum habita [w=pondera] if jefe==1 & region==6
display as text "Número promedio de habitaciones en NEA:" as result r(mean)


***(4.3)Porcentaje con acceso al agua 
sum agua [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)

sum agua [w=pondera] if jefe==1 & agua==1 & region==6
display as text "Porcentaje de acceso al agua en la NEA:" as result (r(sum_w)/`tot')*100

***(4.4)Porcentaje con acceso a cloacas 
sum cloaca [w=pondera] if jefe==1 & region==6
local tot= r(sum_w)

sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region==6
display as text "Porcentaje de acceso a cloacas en NEA:" as result (r(sum_w)/`tot')*100

**Patagonia**
***(4.1)Porcentaje de propietarios de su vivienda 
sum propieta [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)

sum propieta [w=pondera] if jefe==1 & propieta==1 & region==5
display as text "Porcentaje de propietarios de la vivienda en la Patagonia:" as result (r(sum_w)/`tot')*100

***(4.2)Número promedio de habitaciones
sum habita [w=pondera] if jefe==1 & region==5
display as text "Número promedio de habitaciones en la Patagonia:" as result r(mean)

***(4.3)Porcentaje con acceso al agua 
sum agua [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)

sum agua [w=pondera] if jefe==1 & agua==1 & region==5
display as text "Porcentaje de acceso al agua en la Patagonia:" as result (r(sum_w)/`tot')*100

***(4.4)Porcentaje con acceso a cloacas 
sum cloaca [w=pondera] if jefe==1 & region==5
local tot= r(sum_w)

sum cloaca [w=pondera] if jefe==1 & cloaca==1 & region==5
display as text "Porcentaje de acceso a cloacas en la Patagonia:" as result (r(sum_w)/`tot')*100


