capture cd "D:\usuarios\alumno\escritorio"
capture cd "C:\Users\HP\Documents\ESA\TP6"
use "EPH_2023_S2_cruda.dta", clear

drop if deccfr<1 | deccfr>10
drop if nro_hogar == 51 | nro_hogar==71





/**************************************************************************************************
Ejercicio 1. Dividir a la poblacion de los siguientes aglomerados en percentiles de acuerdo al ingreso per capita familiar y verificar mediante un grafico si existe dominancia de Lorenz entre:
(i) Viedma y Gran La Plata
(ii) Mar del Plata y Gran La Plata
(iii) Mar del Plata y Viedma
(iv) Comentar sobre la robustez de las comparaciones de desigualdad en funcion de los resultados obtenidos.


Para cada uno de esos aglomerados calcular el ratio de ingresos promedio entre:
(v) El percentil 100 y el percentil 1
(vi) El percentil 90 y el percentil 10
(vii) El decil 10 y el decil 1
(viii) El quintil 5 y el quintil 1
**************************************************************************************************/





sort codusu nro_hogar trimestre
egen id = group(codusu nro_hogar trimestre)
sort aglomerado ipcf, stable

* poblacion acumulada por aglomerado
by aglomerado: gen shrpop = sum(pondih)
by aglomerado : gen totshrpop=_N
by aglomerado : gen totshrpop_=shrpop[_N]
by aglomerado: replace shrpop = shrpop/shrpop[_N]

* ingreso acumulado por aglomerado
by aglomerado: gen shrinc = sum(pondih*ipcf)
by aglomerado: replace shrinc = shrinc/shrinc[_N]


* dominancia de Lorenz

*i)
twoway (line shrinc shrpop if aglomerado==02) (line shrinc shrpop if aglomerado==93), legend(label(1 "Gran La Plata") label(2 "Viedma")) title("Curva de Lorenz") xtitle("Poblacion Acumulada") ytitle("Ingreso acumulado")
graph export "CLorenz1.png", replace

*ii)
twoway (line shrinc shrpop if aglomerado==34) (line shrinc shrpop if aglomerado==02), legend(label(1 "Mar del Plata") label(2 "Gran La Plata")) title("Curva de Lorenz")
graph export "CLorenz2.png", replace

*iii)
twoway (line shrinc shrpop if aglomerado==34) (line shrinc shrpop if aglomerado==93), legend(label(1 "Mar del Plata") label(2 "Viedma")) title("Curva de Lorenz")
graph export "CLorenz3.png", replace


* armado de percentiles, deciles y quintiles 
sort aglomerado ipcf, stable
by aglomerado: gen sumpop=sum(pondih)
by aglomerado: gen double ppquintil = sumpop[_N]/5
by aglomerado: gen double pppercentil= sumpop[_N]/100
by aglomerado: gen double ppdecil = sumpop[_N]/10

generate quintil=0 
generate decil=0
generate percentil=0 

foreach num of numlist 02 34 93 {
    
    forvalues i = 0(1)99  {
            replace percentil=`i'+1 if sumpop>pppercentil*`i' & sumpop<=pppercentil*(`i'+1) & aglomerado==`num'
                }
    forvalues i = 0(1)9  {
            replace decil=`i'+1 if sumpop>ppdecil*`i' & sumpop<=ppdecil*(`i'+1) & aglomerado==`num'
                }
         forvalues i = 0(1)4  {
            replace quintil=`i'+1 if sumpop>ppquintil*`i' & sumpop<=ppquintil*(`i'+1) & aglomerado==`num'
}
}
    
sort aglomerado percentil


preserve 
version 13: table percentil if aglomerado==02, c(max shrinc) replace 
export excel using "TP6_Grupo10.xlsx", sheetmodify sheet("Hoja 1") cell(E3)
restore 

preserve
version 13: table percentil if aglomerado==93, c(max shrinc) replace 
export excel using "TP6_Grupo10.xlsx", sheetmodify sheet("Hoja 1") cell(B3)
restore 

preserve 
version 13: table percentil if aglomerado==34, c(max shrinc) replace 
export excel using "TP6_Grupo10.xlsx", sheetmodify sheet("Hoja 1") cell(H3)
restore


* calcular ratio de ingresos promedio entre:

*(v) El percentil 100 y el percentil 1 
*(vi) El percentil 90 y el percentil 10
*(vii) El decil 10 y el decil 1 
*(viii) El quintil 5 y el quintil 1
mat ej1=J(4,3,.)
local cnt = 1

foreach num of numlist 93 02 34 {
    * // Calcula el promedio de ipcf para percentil 100
    sum ipcf [w=pondih] if percentil == 100 & aglomerado == `num'
    local cs = r(mean)


    * // Calcula el promedio de ipcf para percentil 1
    sum ipcf [w=pondih] if percentil == 1 & aglomerado == `num'
    local ci = r(mean)


    * // Calcula el ratio percentil 100 / percentil 1
    local ratio_100_1 = `cs' / `ci'
    display as text "Ratio percentil 100 y percentil 1 para región `num': " as result `ratio_100_1'
        mat ej1[1,`cnt']=`ratio_100_1'
		
        * // Calcula el promedio de ipcf para percentil 90
    sum ipcf [w=pondih] if percentil == 90 & aglomerado == `num'
    local cs = r(mean)


    * // Calcula el promedio de ipcf para percentil 10
    sum ipcf [w=pondih] if percentil == 10 & aglomerado == `num'
    local ci = r(mean)


    * // Calcula el ratio percentil 90 / percentil 10
    local ratio_90_10 = `cs' / `ci'
    display as text "Ratio percentil 90 y percentil 10 para región `num': " as result `ratio_90_10'
         mat ej1[2,`cnt']=`ratio_90_10'
		
        * // Calcula el promedio de ipcf para decil 10
    sum ipcf [w=pondih] if decil == 10 & aglomerado == `num'
    local cs = r(mean)


    * // Calcula el promedio de ipcf para decil 1
    sum ipcf [w=pondih] if decil == 1 & aglomerado == `num'
    local ci = r(mean)


    * // Calcula el ratio decil 10 / decil 1
    local ratio_10_1 = `cs' / `ci'
    display as text "Ratio decil 10 y decil 1 para región `num': " as result `ratio_10_1'
         mat ej1[3,`cnt']=`ratio_10_1'
		
        * // Calcula el promedio de ipcf para quintil 5
    sum ipcf [w=pondih] if quintil == 5 & aglomerado == `num'
    local cs = r(mean)


    * // Calcula el promedio de ipcf para quintil 1
    sum ipcf [w=pondih] if quintil == 1 & aglomerado == `num'
    local ci = r(mean)


    * // Calcula el ratio quintil 5  / quintil 1
    local ratio_5_1 = `cs' / `ci'
    display as text "Ratio quintil 5 y quintil 1 para región `num': " as result `ratio_5_1'
	 mat ej1[4,`cnt']=`ratio_5_1'

local ++cnt
}

*exporto columna a excel
preserve
   drop _all
   svmat ej1
   export excel using "TP6_Grupo10.xlsx", sheetmodify sheet("Hoja 1") cell(M3)
restore





/**************************************************************************************************
Ejercicio 2. Calcular el coeficiente de Gini y el índice de Theil para las siguientes distribuciones: 
(i) Ingreso per cápita familiar en Viedma, Gran La Plata y Mar del Plata.
(ii) Ingreso laboral de trabajadores entre 25 y 55 años por nivel educativo (1.bajo=menos que secundaria completa; 2.medio=secundaria completa y superior incompleta y 3.alto=educación superior completa) 
(iii) Ingreso laboral de hombres y mujeres ocupados entre 25 y 55 años.
**************************************************************************************************/





*(i) Calcular el coeficiente de Gini y el índice de Theil para el Ingreso per cápita familiar en Viedma, Gran La Plata y Mar del Plata.
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



*(ii)  Calcular el coeficiente de Gini y el índice de Theil para el Ingreso laboral de trabajadores entre 25 y 55 años por nivel educativo
replace p47t=. if p47t==-9
replace t_vi=. if t_vi
gen ocupado=0 if (estado==2 | estado==3)
replace ocupado=1 if estado==1
gen ilab= p47t - t_vi
replace ilab=. if ocupado!=1
gen nivel_edu=.
replace nivel_edu=1 if (nivel_ed==1 | nivel_ed==2 | nivel_ed==3 | nivel_ed==7)
replace nivel_edu=2 if (nivel_ed==4 | nivel_ed==5)
replace nivel_edu=3 if nivel_ed==6
gen edad = ch06
replace edad=0 if ch06<0


*Nivel Educativo Bajo:
*Gini*
gini ilab [w=pondih] if (edad>=25 & edad<=55) & nivel_edu==1 & ocupado==1
*Theil*
theil ilab [w=pondih] if (edad>=25 & edad<=55) & nivel_edu==1 & ocupado==1


*Nivel Educativo Medio*
*Gini*
gini ilab [w=pondih] if  (edad>=25 & edad<=55) & nivel_edu==2 & ocupado==1
*Theil*
theil ilab [w=pondih] if (edad>=25 & edad<=55) & nivel_edu==2 & ocupado==1


*Nivel Educativo Alto*
*Gini*
gini ilab [w=pondih] if (edad>=25 & edad<=55) & nivel_edu==3 & ocupado==1
*Theil*
theil ilab [w=pondih] if (edad>=25 & edad<=55) & nivel_edu==3 & ocupado==1



*(iii) Calcular el coeficiente de Gini y el índice de Theil para el Ingreso laboral de hombres y mujeres ocupados entre 25 y 55 años
mat ej2iii= J(2,2,.)


*Hombres*
*Gini*
gini ilab [w=pondih] if ocupado==1 & (edad>=25 & edad<=55) & ch04==1
*Theil*
theil ilab [w=pondih] if ocupado==1 & (edad>=25 & edad<=55) & ch04==1


*Mujeres*
*Gini*
gini ilab [w=pondih] if  ocupado==1 & (edad>=25 & edad<=55) & ch04==2
*Theil*
theil ilab [w=pondih] if ocupado==1 & (edad>=25 & edad<=55) & ch04==2





/**************************************************************************************************
Ejercicio 3. Suponer que un shock económico negativo (ej. la cuarentena) reduce el ingreso laboral de todos los trabajadores cuentapropistas no profesionales de y1 a y2 de forma proporcional; es decir, y2=y1*(1-x). Calcular la distribución del ingreso per cápita familiar antes y después del shock para un x=0.5.

(i) Verificar mediante un gráfico si existe dominancia de Lorenz (en base a percentiles) entre las distribuciones antes y después del shock.
(ii) Calcular los siguientes indicadores antes y después del shock
a. Ratio de ingresos decil 10/decil 1
b. Participación del decil 10 en el ingreso total
c. Coeficiente de Gini
d. Índice de Theil
(iii) Comentar
**************************************************************************************************/





local x=0.5

**(i) Verificar mediante un gráfico si existe dominancia de Lorenz (en base a percentiles) entre las distribuciones antes y después del shock

*genero una variable de ingreso laboral
gen ocupa = (estado==1)
replace p47t=. if p47t==-9
replace t_vi=. if t_vi==-9
gen ila=p47t-t_vi
replace ila=. if ocupa!=1

*Generar ingreso laboral familiar 
egen ila_tot= sum(ila), by (id)

*generar ingreso laboral ficticio (y2)
gen ila_sim=ila

*hago la restriccion
replace ila_sim=ila*(1-`x') if cat_ocup==2 & (nivel_ed<=5 | nivel_ed==7)
egen ila_tot_sim= sum(ila_sim), by (id)
gen itf_sim=(itf-ila_tot + ila_tot_sim)
replace itf_sim= 0 if itf_sim<0

*nuevo ingreso per capita familiar
gen ipcf_sim= itf_sim/ix_tot
generate pipcf=0
generate pipcf_sim=0
gen dipcf=0
gen dipcf_sim=0


mat ej3=J(4,2,.)
local cny = 1
foreach var of varlist ipcf ipcf_sim {
	
capture drop sumpop
capture drop pppercentil
sort `var', stable
gen double sumpop=sum(pondih)
gen double pppercentil=sumpop[_N]/100
forvalues i =0(1)99 {
replace p`var'=`i'+1 if sumpop>pppercentil*`i' & sumpop<=pppercentil*(`i'+1)
}

*Generar Ingreso acumulado
capture drop shrinc
gen shrinc=sum(pondih*`var')
replace shrinc=shrinc/shrinc[_N]

*exportp
preserve
version 13: table p`var', c(max shrinc) replace
export excel using "TP6_grupo10.xlsx", sheet("3_ `var'", modify) cell(B3)
restore



*(ii)


*a) Ratio de ingresos decil 10/decil 1
capture drop pxdecil
sort `var', stable
gen double pxdecil=sumpop[_N]/10
forvalues i =0(1)9 {
replace d`var'=`i'+1 if sumpop>pxdecil*`i' & sumpop<=pxdecil*(`i'+1)
}
sum `var' [w=pondih] if  d`var' == 10
local cs =r(mean)
sum `var' [w=pondih] if  d`var' == 1 
local ci = r(mean)
mat ej3[1,`cny']= `cs'/`ci'

*b) Participación del decil 10 en el ingreso total
gen shrdecdiez=sum(pondih*`var') if d`var'==10
gen shrdec=sum(pondih*`var')
mat ej3[2,`cny']=shrdecdiez[_N]/shrdec[_N]

*c) Coeficiente de Gini
gini `var' [w=pondih] if `var'>0 & `var'!=.
mat ej3[3,`cny']=r(gini)

*d) Índice de Theil
theil `var' [w=pondih] if `var'>0 & `var'!=.
mat ej3[4,`cny']=r(theil)

drop sumpop shrinc shrdecdiez shrdec
local ++cny
}


preserve
drop _all 
svmat ej3
export excel "TP6_grupo10.xlsx", sheet ("Hoja 3") cell ("B3") sheetmodify
restore 

