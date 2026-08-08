set more off
local path "C:\Users\HP\Downloads\Data-Analysis-Practicum\Finanzas Internacionales"  // Put the path here <----

capture cd "`path'"
import delimited "`path'\ipc_tcn.csv", clear
gen mdate = monthly(date, "YM")
format mdate %tm
tsset mdate
format mdate %tmMon_CCYY



* EXERCISE 1

/*a) Construct Argentina's bilateral real exchange rate with:
the United States
Brazil
for the period 1980:1–2019:12, using consumer price indices*/
gen rerarg_usa = tcnarg * (ipcusa / ipcarg)
sum rerarg_usa
gen rer_index1 = (rerarg_usa / r(mean)) *100
label var rer_index1 "Bilateral Real Exchange Rate Arg-USA (average=100)"

gen rerarg_bra = (tcnarg/tcnbra) * (ipcbra / ipcarg)
sum rerarg_bra
gen rer_index2 = (rerarg_bra / r(mean)) *100
label var rer_index2 "Bilateral Real Exchange Rate Arg-Bra (average=100)"

/*b) For each series, analyze the following sub-periods:
1980:1–1991:3
1991:4–2001:12
2002:1–2019:12*/

/*c) Calculate, for each period:
mean
volatility*/
sum rer_index1, d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index1 if mdate>=tm(1980m1)  & mdate<=tm(1991m3), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index1 if mdate>tm(1991m3)   & mdate<=tm(2001m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index1 if mdate>tm(2001m12)  & mdate<=tm(2019m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)

sum rer_index2, d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index2 if mdate>=tm(1980m1)  & mdate<=tm(1991m3), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index2 if mdate>tm(1991m3)   & mdate<=tm(2001m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum rer_index2 if mdate>tm(2001m12)  & mdate<=tm(2019m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)

*d) Graph the series and briefly comment on their main characteristics
tsline rer_index1, title("Evolution of the Argentina-USA bilateral real exchange rate (RER)") ///
subtitle("Period 1980–2019") ytitle("Index") xtitle("Month")

tsline rer_index1 if mdate>=tm(1980m1) & mdate<=tm(1991m3), title("Evolution of the Argentina-USA bilateral RER") ///
subtitle("Period 1980-1991") ytitle("Index") xtitle("Month")

tsline rer_index1 if mdate>tm(1991m3) & mdate<=tm(2001m12), title("Evolution of the Argentina-USA bilateral RER") ///
subtitle("Period 1991-2001") ytitle("Index") xtitle("Month")

tsline rer_index1 if mdate>tm(2001m12) & mdate<=tm(2019m12), title("Evolution of the Argentina-USA bilateral RER") ///
subtitle("Period 2001-2019") ytitle("Index") xtitle("Month")

tsline rer_index2, title("Evolution of the Argentina-Brazil bilateral RER") ///
subtitle("Period 1980-2019") ytitle("Index") xtitle("Month")

tsline rer_index2 if mdate>=tm(1980m1) & mdate<=tm(1991m3), title("Evolution of the Argentina-Brazil bilateral RER") ///
subtitle("Period 1980-1991") ytitle("Index") xtitle("Month")

tsline rer_index2 if mdate>tm(1991m3) & mdate<=tm(2001m12), title("Evolution of the Argentina-Brazil bilateral RER") ///
subtitle("Period 1991-2001") ytitle("Index") xtitle("Month")

tsline rer_index2 if mdate>tm(2001m12) & mdate<=tm(2019m12), title("Evolution of the Argentina-Brazil bilateral RER") ///
subtitle("Period 2001-2019") ytitle("Index") xtitle("Month")



* EXERCISE 2

/*a) Download annual foreign trade data for Argentina with:
Brazil, Paraguay, Uruguay (Mercosur)
Chile
Note: INDEC does not have country-level disaggregated data prior to 2020; only aggregate-level data is available from 1990 onwards.
The decision was made to use the WITS COMTRADE database.*/

use "DataJobID-3061534_3061534_Mercosur", clear

*b) Construct fixed trade weights based on the average shares of exports and imports for the period 1990–2019
collapse (sum) TradeValuein1000USD, by(PartnerName Year)
bysort Year: egen comercio_total = sum(TradeValuein1000USD)
gen share = TradeValuein1000USD / comercio_total
collapse (mean) share, by(PartnerName)
decode PartnerName, gen(partner)
sum share if partner == "Brazil"
scalar w_bra = r(mean)
sum share if partner == "Chile"
scalar w_chi = r(mean)
sum share if partner == "Paraguay"
scalar w_par = r(mean)
sum share if partner == "Uruguay"
scalar w_uru = r(mean)

/*c) Using said weights, calculate the monthly REER for 1980:1–2019:12 using:
arithmetic mean
geometric mean*/
import delimited "`path'\ipc_tcn.csv", clear
gen mdate = monthly(date, "YM")
format mdate %tm
tsset mdate
format mdate %tmMon_CCYY

*Brazil
gen rerarg_bra = (tcnarg/tcnbra) * (ipcbra / ipcarg)
sum rerarg_bra
gen rer_index1 = (rerarg_bra / r(mean)) *100
label var rer_index1 "Bilateral Arg-Bra RER (average=100)"
*Paraguay
gen rerarg_pry = (tcnarg/tcnpry) * (ipcpry / ipcarg)
sum rerarg_pry
gen rer_index2 = (rerarg_pry / r(mean)) *100
label var rer_index2 "Bilateral Arg-Par RER (average=100)"
*Uruguay
gen rerarg_ury = (tcnarg/tcnury) * (ipcury / ipcarg)
sum rerarg_ury
gen rer_index3 = (rerarg_ury / r(mean)) *100
label var rer_index3 "Bilateral Arg-Uru RER (average=100)"
*Chile
gen rerarg_chl = (tcnarg/tcnchl) * (ipcchl / ipcarg)
sum rerarg_chl
gen rer_index4 = (rerarg_chl / r(mean)) *100
label var rer_index4 "Bilateral Arg-Chi RER (average=100)"
*Arithmetic multilateral
gen multi_arit = (rer_index1 * w_bra) + (rer_index2 * w_par) + (rer_index3 * w_uru) + (rer_index4 * w_chi)
label var multi_arit "Arithmetic Multilateral RER (base 100)"
*Multilateral geometric
gen multi_geom = (rer_index1^w_bra) + (rer_index2^w_par) + (rer_index3^w_uru) + (rer_index4^w_chi)
label var multi_geom "Geometric Multilateral RER (base 100)"

*d) Repeat the analysis from Exercise 1 (mean, volatility, and charts)
sum multi_arit, d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_arit if mdate>=tm(1980m1)  & mdate<=tm(1991m3), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_arit if mdate>tm(1991m3)   & mdate<=tm(2001m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_arit if mdate>tm(2001m12)  & mdate<=tm(2019m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_geom, d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_geom if mdate>=tm(1980m1)  & mdate<=tm(1991m3), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_geom if mdate>tm(1991m3)   & mdate<=tm(2001m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)
sum multi_geom if mdate>tm(2001m12)  & mdate<=tm(2019m12), d
display as text "Coefficient of variation:" as result r(sd)/r(mean)

tsline multi_arit, title("Evolution of the Multilateral RER") ///
subtitle("Period 1980-2019") ytitle("Index") xtitle("Month")

tsline multi_arit if mdate>=tm(1980m1) & mdate<=tm(1991m3), title("Evolution of the Multilateral RER") ///
subtitle("Period 1980-1991") ytitle("Index") xtitle("Month")

tsline multi_arit if mdate>tm(1991m3) & mdate<=tm(2001m12), title("Evolution of the Multilateral RER") ///
subtitle("Period 1991-2001") ytitle("Index") xtitle("Month")

tsline multi_arit if mdate>tm(2001m12) & mdate<=tm(2019m12), title("Evolution of the Multilateral RER") ///
subtitle("Period 2001-2019") ytitle("Index") xtitle("Month")

tsline multi_geom, title("Evolution of the Multilateral RER") ///
subtitle("Period 1980-2019") ytitle("Index") xtitle("Month")

tsline multi_geom if mdate>=tm(1980m1) & mdate<=tm(1991m3), title("Evolution of the Multilateral RER") ///
subtitle("Period 1980-1991") ytitle("Index") xtitle("Month")

tsline multi_geom if mdate>tm(1991m3) & mdate<=tm(2001m12), title("Evolution of the Multilateral RER") ///
subtitle("Period 1991-2001") ytitle("Index") xtitle("Month")

tsline multi_geom if mdate>tm(2001m12) & mdate<=tm(2019m12), title("Evolution of the Multilateral RER") ///
subtitle("Period 2001-2019") ytitle("Index") xtitle("Month")

/*e) In a single figure, compare:
REER (both methodologies)
Bilateral REER with Brazil
Bilateral REER with the United States
Briefly comment on the observed differences.*/
gen rerarg_usa = tcnarg * (ipcusa / ipcarg)
sum rerarg_usa
gen rer_index5 = (rerarg_usa / r(mean)) *100
label var rer_index5 "Bilateral RER Arg-USA (average=100)"

tsline multi_arit multi_geom rer_index1 rer_index5, title("Multilateral and Bilateral RER") ///
subtitle("Period 1980-2019") ytitle("Index") xtitle("Month")
