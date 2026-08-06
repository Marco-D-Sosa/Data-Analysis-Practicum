cd "C:\Users\HP\Downloads\TP4"
use "cell phone sim.dta", clear
eststo clear


/* **********
 * Inciso b *
 * **********/
 
 *Generamos el escenario de efectos heterogéneos (filmina 9-10)
*Sumamos 2 a price_disp de RII en P2: δ_RII pasa de -4.97 a -2.97
gen price_disp_het = price_disp
replace price_disp_het = price_disp + 2 if RII==1 & P2==1

*Filmina 11: "Distinto Efecto en RII"
*Comparación RI (tratada en P1, ya tratada) vs RII en P1-P2
*delta_RII ahora debería dar -2.97 (en vez de -4.97)
eststo modelo_RII_het: reg price_disp_het RII P2 RIIP2 if (P1==1 | P2==1) & RIII==0
*RIP1 debería dar ~ -2.97

*Chequeo: delta_RI (P0-P1) no cambia, sigue en -4.85 porque la modificación fue solo en RII-P2
eststo modelo_RI_het: reg price_disp_het RI P1 RIP1 if (P0==1 | P1==1) & RIII==0
* RIP1 debería dar ~ -4.85

*Filmina 12: "Efecto Promedio con TWFE"
*TWFE con dI, ahora con el outcome heterogéneo
eststo modelo_TWFE_het: reg price_disp_het RII P1 P2 dI if RIII==0 & P3==0
* dI debería dar ~ -3.91

*Verificación: promedio de los dos efectos individuales
display (-4.85 + -2.97)/2
* = -3.91, igual al coeficiente de dI

* Exportamos las regresiones almacenadas
esttab modelo_RII_het modelo_RI_het modelo_TWFE_het using "efectos_heterogeneos.rtf", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    legend label title("Escenario de Efectos Heterogeneos") ///
    mtitle("Delta RII (-2.97)" "Delta RI (-4.85)" "TWFE Promedio") ///
    stats(r2 N, labels("R-cuadrado" "Observaciones"))	



/* **********
 * Inciso c *
 * **********/

* Generamos el escenario de "Efectos Dinámicos" (Filmina 16)
* Suponemos un efecto adicional de -1 para RI (tratada en P1) a medida que madura el tratamiento en P2.
gen price_disp_dyn = price_disp
replace price_disp_dyn = price_disp - 1 if RI == 1 & P2 == 1

* Sub-experimento 1: Estimar delta_{RI} (Comparación P0 vs P1)
* Tratado: RI | Control: RII (aún no tratada)
* Este estimador debe ser insesgado y arrojar -4.85, ya que RII pre-tratamiento provee una tendencia paralela válida.
eststo modelo_RI: reg price_disp_dyn RI P1 RIP1 if (P0 == 1 | P1 == 1) & RIII == 0

* Sub-experimento 2: Estimar delta_{RII} (Comparación P1 vs P2)
* Tratado: RII | Control: RI (ya tratada)
* Aquí ocurre la "comparación prohibida". RI arrastra el efecto dinámico de -1.
* El coeficiente de interacción (efecto DiD) capturará el sesgo, decreciendo de -4.97 a -3.97.
eststo modelo_RII: reg price_disp_dyn RII P2 RIIP2 if (P1 == 1 | P2 == 1) & RIII == 0

* Regresión TWFE completa (Efecto promedio)
* Replicamos la especificación de la filmina 12/17 pero con la variable dependiente dinámica.
* El coeficiente de la dummy de tratamiento (dI) será un promedio ponderado que arrastra el sesgo del sub-experimento 2.
eststo modelo_TWFE: reg price_disp_dyn RII P1 P2 dI if RIII == 0

* Exportación de Resultados
esttab modelo_RI modelo_RII modelo_TWFE using "replicacion_efectos_dinamicos.rtf", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    legend label title("Impacto de los Efectos Dinamicos en el Estimador TWFE") ///
    mtitle("Delta RI (Insesgado)" "Delta RII (Sesgado)" "TWFE (Promedio Contaminado)") ///
    stats(r2 N, labels("R-cuadrado" "Observaciones"))
