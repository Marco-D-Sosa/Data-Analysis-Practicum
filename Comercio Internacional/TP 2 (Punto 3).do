

*** Abre base de datos EPH 2024 Q3 y computa variables

clear all

capture import excel using "C:\Users\renat\OneDrive\Escritorio\Eco. internacional\TP2\usu_individual_T324.xlsx", firstrow clear
capture cd "C:\Users\HP\Downloads\TP2 - Evidencia empirica"
capture import excel using "C:\Users\HP\Downloads\TP2 - Evidencia empirica\usu_individual_T324.xlsx", firstrow clear

* Me quedo con las variables que voy a usar 
keep P21 PP3E_TOT PP07H CAT_OCUP PP04B_COD ESTADO PONDERA


* Factor de ponderacion
gen pondera = PONDERA
label var pondera "factor de ponderacion"

* Identifico Ocupados
gen ocupado=.
replace ocupado=0 if (ESTADO==2 | ESTADO==3)
replace ocupado=1 if ESTADO==1
label var ocupado "=1 si ocupado"
tab ocupado
more

* Me quedo sólo con empleados (asalariados) en el análisis
keep if CAT_OCUP==3
/* CAT_OCUP     1= Patrón
		2= Cuenta propia
		3= Obrero o empleado,
   		4= Trabajador familiar sin remuneración
		9= Ns/Nr       */
		

* Identifico Sector de actividad a un dígito del CIIU (los que muestra INDEC en CGI -Cuenta de generación del ingreso e insumo de mano de obra-)
gen sector1d=.
replace sector1d=1 if (PP04B_COD>=1 & PP04B_COD<=2) | (PP04B_COD>=101 & PP04B_COD<=200) | (PP04B_COD==8102)
replace sector1d=2 if (PP04B_COD==3 | PP04B_COD==300)
replace sector1d=3 if (PP04B_COD>=5 & PP04B_COD<=9) | (PP04B_COD>=500 & PP04B_COD<=900)
replace sector1d=4 if (PP04B_COD>=10 & PP04B_COD<=33) | (PP04B_COD==58) | (PP04B_COD>=1001 & PP04B_COD<=3300) | (PP04B_COD==5800) | (PP04B_COD==9502)
replace sector1d=5 if (PP04B_COD>=35 & PP04B_COD<=36) | (PP04B_COD>=3501 & PP04B_COD<=3600)
replace sector1d=6 if (PP04B_COD==40) | (PP04B_COD==4000)
replace sector1d=7 if (PP04B_COD>=45 & PP04B_COD<=48) | (PP04B_COD==95) | (PP04B_COD>=4501 & PP04B_COD<=4811) | (PP04B_COD==9503)
replace sector1d=8 if (PP04B_COD>=55 & PP04B_COD<=56) | (PP04B_COD>=5500 & PP04B_COD<=5602)
replace sector1d=9 if (PP04B_COD>=49 & PP04B_COD<=53) | (PP04B_COD==61) | (PP04B_COD==79) | (PP04B_COD>=4901 & PP04B_COD<=5300) | (PP04B_COD==6100) | (PP04B_COD==7900)
replace sector1d=10 if (PP04B_COD>=64 & PP04B_COD<=66) | (PP04B_COD>=6400 & PP04B_COD<=6600)
replace sector1d=11 if (PP04B_COD==62) | (PP04B_COD>=68 & PP04B_COD<=74) | (PP04B_COD>=77 & PP04B_COD<=78) | (PP04B_COD>=80 & PP04B_COD<=82) | (PP04B_COD==6200) | (PP04B_COD>=6800 & PP04B_COD<=7400) | (PP04B_COD>=7701 & PP04B_COD<=7800) | (PP04B_COD>=8000 & PP04B_COD<=8101) | (PP04B_COD==8200) | (PP04B_COD==9501)
replace sector1d=12 if (PP04B_COD>=83 & PP04B_COD<=84) | (PP04B_COD>=8300 & PP04B_COD<=8403)
replace sector1d=13 if (PP04B_COD==85) | (PP04B_COD>=8501 & PP04B_COD<=8509)
replace sector1d=14 if (PP04B_COD==75) | (PP04B_COD>=86 & PP04B_COD<=88) | (PP04B_COD==7500) | (PP04B_COD>=8600 & PP04B_COD<=8800)
replace sector1d=15 if (PP04B_COD>=37 & PP04B_COD<=39) | (PP04B_COD>=59 & PP04B_COD<=60) | (PP04B_COD==63) | (PP04B_COD>=90 & PP04B_COD<=94) | (PP04B_COD==96) | (PP04B_COD>=3700 & PP04B_COD<=3900) | (PP04B_COD>=5900 & PP04B_COD<=6000) | (PP04B_COD==6300) | (PP04B_COD>=9000 & PP04B_COD<=9409) | (PP04B_COD>=9601 & PP04B_COD<=9609)
replace sector1d=16 if (PP04B_COD>=97 & PP04B_COD<=98) | (PP04B_COD>=9700 & PP04B_COD<=9800)
replace sector1d=17 if (PP04B_COD==99) | (PP04B_COD==9900) 
replace sector1d=. if ocupado!=1
label var    sector1d            "Sector de actividad a 1 digito CIIU" 
label define sector1d 1 "Agricultura, Ganadería, Caza y Silvicultura" 2 "Pesca" 3 "Explotación de Minas y Canteras" 4 "Industrias Manufactureras" 5 "Suministro de Electricidad, Gas y Agua" 6 "Construcción" 7 "Comercio" 8 "Hoteles y Restaurantes" 9 "Transporte, Almacenamiento y Comunicaciones" 10 "Intermediación Financiera" 11 "Actividades Inmobiliarias, Empresariales y de Alquiler" 12 "Administración Pública y Defensa" 13 "Enseñanza" 14 "Servicios Sociales y de Salud" 15 "Otras Actividades de Servicios Comunitarios, Sociales y Personales" 16 "Hogares Privados con Servicio Doméstico" 17 "Organizaciones y Órganos Extraterritoriales" 
label values sector1d sector1d
drop if sector1d==17

* Identificamos trabajadores formales por: Derecho a percibir una jubilación 

/* PP07H: ¿Por ese trabajo tiene descuento jubilatorio?
             1=si
	     2=no   */
gen djubila=.
replace djubila=1 if PP07H==1
replace djubila=0 if PP07H==2
label var djubila "Derecho a jubilacion"
tab djubila 


* Ingreso en la ocupación principal - monetario
replace P21=. if P21<0  
gen ip_m=P21 
label var ip_m "ing oc. ppal.-mon."

* Horas trabajadas en el trabajo principal (semanal)

/* PP3E_TOT: total de horas que trabajó en la semana en la ocupación principal */

gen hstrp=PP3E_TOT
replace hstrp=. if hstrp<0
replace hstrp=. if hstrp>150
more
label var hstrp "horas trabajadas ocup. ppal."

* Ingresos laborales horarios en la ocupación principal - monetario
gen wage_m=ip_m/(hstrp*4)
label var wage_m "ing. hora oc. ppal-monetario"




*----------------------------------------------------------------------

/* Remuneración media de cada sector y formalidad */
egen wage_sector_formal = mean(wage_m) if djubila==1, by(sector1d)
egen wage_sector_informal = mean(wage_m) if djubila==0, by(sector1d)

/* (Desagregado) Generamos la penalidad */
ta wage_sector_formal
ta wage_sector_informal

forvalues i = 1/16 {
	local nombre_sector : label sector1d `i'
	quietly sum wage_sector_formal if sector1d==`i'
	scalar mean_formal= r(mean)
	quietly sum wage_sector_informal if sector1d==`i'
	scalar mean_informal= r(mean)
	scalar indice = (mean_formal - mean_informal) / mean_formal
	di "Índice de penalidad de informalidad para el sector `i' (`nombre_sector'):" indice
}

forvalues i = 1/16 {
	local nombre_sector : label sector1d `i'
	quietly sum wage_sector_formal if sector1d==`i'
	scalar mean_formal= r(mean)
	quietly sum wage_sector_informal if sector1d==`i'
	scalar mean_informal= r(mean)
	scalar indice = mean_informal / mean_formal
	di "Ratio salario medio informal/salario medio formal de sector `i' (`nombre_sector'):" indice
}



/*(Desagregado) Calculo de dotación factorial: total de horas asalariados y no asalariados, se toman horas laborales para computar el ratio de dotaciones informales/formales */

forvalues i = 1/16 {
    di "-----"
    local nombre_sector : label sector1d `i'
	di "Sector: `i' (`nombre_sector')"

    qui sum hstrp if djubila == 0 & sector1d == `i'
    local informal = r(sum)*4
    di "Horas mensuales (informales): `informal'"

    qui sum hstrp if djubila == 1 & sector1d == `i'
    local formal = r(sum)*4
    di "Horas mensuales (formales): `formal'"
	
	di "Ratio dotación laboral informal/dotación laboral formal:" `informal'/`formal'

    di "-----"
}

/* Para ajustar el ratio de dotación por la productividad, en este caso el ratio de salarios medios, lo multiplicamos por el ratio de salarios medios */
forvalues i = 1/16 {
	di "-----"
    di "Sector: `i' (`nombre_sector')"
	local nombre_sector : label sector1d `i'
	
	quietly sum wage_sector_formal if sector1d==`i'
	local mean_formal= r(mean)
	quietly sum wage_sector_informal if sector1d==`i'
	local mean_informal= r(mean)
	di "Ratio salario medio informal/salario medio formal de sector `i' (`nombre_sector'):" `mean_informal'/`mean_formal'

    qui sum hstrp if djubila == 0 & sector1d == `i'
    local informal = r(sum)*4
    di "Horas mensuales (informales): `informal'"
    qui sum hstrp if djubila == 1 & sector1d == `i'
    local formal = r(sum)*4
    di "Horas mensuales (formales): `formal'"
	di "Ratio dotación laboral informal/dotación laboral formal:" `informal'/`formal'

	di "Dotación ajustada por productividad (salarios) del sector `nombre_sector' : " (`mean_informal'/`mean_formal')*(`informal'/`formal')
	
    di "-----"
}

mat D = J(16,1,.)

/* Para ajustar el ratio de dotación por la productividad, en este caso el ratio de salarios medios, lo multiplicamos por el índice de penalidad de informalidad */
forvalues i = 1/16 {
	di "-----"
    di "Sector: `i' (`nombre_sector')"
	local nombre_sector : label sector1d `i'
	
	qui sum wage_sector_formal if sector1d==`i'
	local mean_formal= r(mean)
	qui sum wage_sector_informal if sector1d==`i'
	local mean_informal= r(mean)
	di "Índice de penalidad de informalidad para el sector `i' (`nombre_sector'):" (`mean_formal'-`mean_informal')/`mean_formal'
	

    qui sum hstrp if djubila == 0 & sector1d == `i'
    local informal = r(sum)*4
    di "Horas mensuales (informales): `informal'"
    qui sum hstrp if djubila == 1 & sector1d == `i'
    local formal = r(sum)*4
    di "Horas mensuales (formales): `formal'"
	di "Ratio dotación laboral informal/dotación laboral formal:" `informal'/`formal'

	di "Dotación ajustada por productividad (salarios) del sector `nombre_sector' : " (`mean_formal'-`mean_informal')/`mean_formal'*(`informal'/`formal')
	mat D[`i',1] = (`mean_formal'-`mean_informal')/`mean_formal'*(`informal'/`formal')
    di "-----"
}


preserve
   drop _all
   svmat D
   export excel using "TP 2 punto 3", sheetmodify sheet("Punto D") cell(B2)
restore
