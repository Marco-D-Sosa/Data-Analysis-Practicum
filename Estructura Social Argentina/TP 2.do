capture cd "C:\Users\HP\Documents\ESA\TP2"
use "arg_eph_23s1_tp2", clear
describe




**Ejercicio 1: Calcular algunas estadísticas básicas de la distribución del ingreso per cápita familiar de Argentina y de cada una de sus regiones:
*(a)Media
*(b)Mediana
*(c)Valores mínimos y máximos
*(d)Percentiles 5, 25, 75 y 99
*(e)Coeficiente de asimetría de Fisher
*(f)Comentar las diferencias entre regiones

*para Argentina
sum ipcf [w=pondih] if region !=. , d

*para regiones
foreach num of numlist 1 40 41 42 43 44 {

display as text "region `num' "
 sum ipcf [w=pondih] if region ==`num' , d
 
 }
 *



*Ejercicio 2. Considerar la distribución del ingreso per cápita familiar de Argentina.

 *(a) Dividir a la población en deciles y presentar el ingreso promedio y mediano de cada decil
sort ipcf, stable
gen sumpop=sum(pondih)
generate double ppdecil=sumpop[_N]/10
generate decil = 0

generate decil2=0
forvalues i=0(1)9 {
	replace decil2= `i'+1 if sumpop>ppdecil*`i' & sumpop<= ppdecil*(`i'+1)
		
}
version 13: table decil2 [w=pondih], c(mean ipcf median ipcf sum ipcf) row format(%20.3f)

*(b) Computar la participación de cada decil en el ingreso total. Ilustrar con un gráfico de barras
summarize ipcf [w=pondih], d
generate participacion=.
local totipcf=r(sum)

sum ipcf[w=pondih] if decil2==1
replace participacion=(r(sum)/`totipcf')*100 if decil2==1
sum ipcf[w=pondih] if decil2==2
replace participacion=(r(sum)/`totipcf')*100 if decil2==2
sum ipcf[w=pondih] if decil2==3
replace participacion=(r(sum)/`totipcf')*100 if decil2==3
sum ipcf[w=pondih] if decil2==4
replace participacion=(r(sum)/`totipcf')*100 if decil2==4
sum ipcf[w=pondih] if decil2==5
replace participacion=(r(sum)/`totipcf')*100 if decil2==5
sum ipcf[w=pondih] if decil2==6
replace participacion=(r(sum)/`totipcf')*100 if decil2==6
sum ipcf[w=pondih] if decil2==7
replace participacion=(r(sum)/`totipcf')*100 if decil2==7
sum ipcf[w=pondih] if decil2==8
replace participacion=(r(sum)/`totipcf')*100 if decil2==8
sum ipcf[w=pondih] if decil2==9
replace participacion=(r(sum)/`totipcf')*100 if decil2==9
sum ipcf[w=pondih] if decil2==10
replace participacion=(r(sum)/`totipcf')*100 if decil2==10

*(c) Repetir el ejercicio (a) dividiendo a la población en percentiles. Presentar e ilustrar solo el ingreso medio de cada percentil.
generate pppercentil=sumpop[_N]/100
generate percentil=0

forvalues i=0(1)99 {
	replace percentil= `i'+1 if sumpop>pppercentil*`i' & sumpop<= pppercentil*(`i'+1)
}

preserve
version 13: table percentil [w=pondih], c(mean ipcf) row format(%20.3f) replace
 
restore
 


 
*Ejercicio 3. Presentar los siguientes gr?ficos de la distribuci?n del ingreso per c?pita familiar x:

*(a) Un histograma de x. Acotar el soporte para una mejor visualizaci?n del gr?fico
sum ipcf [w=pondih], d
histogram ipcf [w=pondih] if ipcf<r(p90), frac ytitle("Proporcion") scheme(s1color)
graph export "histograma_TP2.png", replace

*(b)Un histograma del logaritmo de x.
gen lipcf=ln(ipcf)
sum lipcf [w=pondih], d
histogram lipcf [w=pondih], frac ytitle("Proporcion") xtitle("logaritmo de ipcf") scheme(s1color)
graph export "histogramaLog_TP2.png", replace

*(c) Una estimaci?n no param?trica por kernels del logaritmo de x.
kdensity lipcf [w=pondih], xtitle("logaritmo de ipcf") ytitle("densidad") scheme(s1color)
graph export "Kernels_TP2.png", replace

*(d) La curva de Pen de x.
sort ipcf, stable
gen shrpop = sum(pondih)
replace shrpop = shrpop/shrpop[_N]

line ipcf shrpop, scheme(s1color)
graph export "CurvaPen_TP2.png", replace




* 4 Restringir la muestra a adultos “jefes de hogar” entre 30 y 60 años
gen años = ch06
replace años = 0 if ch06==-1

*Comparar en un mismo gráfico estimaciones no paramétricas por kernels de la distribución del logaritmo del ingreso per cápita de dos grupos: 
*(i) los que tienen educación superior completa y (ii) el resto.
gen nivel_edu = nivel
replace nivel_edu = 1 if nivel_edu==7
kdensity lipcf [w=pondih] if (años>=30 & años<=60) & nivel_edu==6 & ch04==1 & ch03==1
twoway (kdensity lipcf [w=pondih] if (años>=30 & años<=60) & nivel_edu==6 & ch04==1 & ch03==1) (kdensity lipcf [w=pondih] if (años>=30 & años<=60) & nivel_edu!=6 & ch04==1 & ch03==1)
twoway (kdensity lipcf [w=pondih] if (años>=30 & años<=60) & nivel_edu==6 & ch04==1 & ch03==1) (kdensity lipcf [w=pondih] if (años>=30 & años<=60) & nivel_edu!=6 & ch04==1 & ch03==1), legend (label(1 "Educacion Superior Completa") label(2 "Resto de los Niveles Educativos")) ytitle("Eduacion") xtitle("Log del Ingreso per capita familiar") scheme(s1color)
graph export "grafico4.png", replace




* 5 dividir a la poblaci?n por grupos etarios: [0, 29], [30, 59], [60 o m?s]
gen sexo= . 
replace sexo= 0 if ch04==2
replace sexo= 1 if ch04==1

gen edad = ch06
replace edad= 0 if ch06<0 

gen grupo_edad= . 
replace grupo_edad=1 if edad>=0 & edad<30
replace grupo_edad=2 if edad>=30 & edad<60
replace grupo_edad=3 if edad >=60 & edad!=.

* calcular la media del ingreso per capita familiar de cada grupo etario
tab grupo_edad [w=pondih], sum(ipcf)

* ingreso equivalente E (escala Amsterdam) 
gen ae=1
replace ae=.98 if sexo==1 & edad==14 & edad<=17
replace ae=.9 if sexo==0 & edad>=14
replace ae=.52 if edad<14
replace ae = 0 if nro_hogar>=51 & nro_hogar<=91

egen aef=sum(ae), by(id)

gen ie_1= itf / (aef)^1
gen ie_2= itf / (aef)^(0.75)
gen ie_3= itf / (aef)^(0.5)

tab grupo_edad [w=pondih], sum(ie_1)
tab grupo_edad [w=pondih], sum(ie_2)
tab grupo_edad [w=pondih], sum(ie_3)
