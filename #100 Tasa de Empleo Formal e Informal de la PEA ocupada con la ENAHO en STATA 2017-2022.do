clear all
cd             "D:\ENAHO"
/*
use          "enaho01a-2022-500.dta", clear
append using "enaho01a-2021-500.dta"
append using "enaho01a-2020-500.dta"
append using "enaho01a-2019-500.dta"
append using "enaho01a-2018-500.dta"
append using "enaho01a-2017-500.dta"
save "enaho500-2017-2022.dta", replace
*/

use "enaho500-2017-2022.dta", clear
rename a*o year
gen    anio=real(year)
label var year "Year"

tab p500i year
drop if p500i=="00"

*Se establece quienes son residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))
*P204 ¿Es miembro del hogar?	204. ¿Es miembro del hogar familiar? 1. Sí 2. No
*P205 ¿Se encuentra ausente del hogar 30 días o más?	1. Sí 2. No
*P206 ¿Está presente en el hogar 30 días o más? 1. Sí 2. No


********************************************************************************
*GRÁFICO N° 3.2 PERÚ: TASA DE EMPLEO FORMAL E INFORMAL Y VARIACIÓN DE LA PEA OCUPADA CON EMPLEO FORMAL E INFORMAL, 2017-2022

*ocupinf= situacion de informalidad, 1: empleo informal, 2: empleo formal 
table ocupinf year if resi==1 [iw= fac500a],  nformat(%12.0fc)

gen     informal=ocupinf
replace informal=0  if ocupinf==2
gen     formal  =1  if ocupinf==2
replace formal  =0  if ocupinf==1

graph bar informal formal if resi==1 [pw= fac500a], /// 
 over(year) per stack yscale(off) /// 
 legend(cols(2) position(6) label(1 "Tasa de empleo informal") label(2 "Tasa de empleo formal")) ///
 blabel(bar, format(%4.1f) size(small) position(center) color(white)) ///
 bar(1,color(red)) bar(2,color(orange)) ///
 saving(gr3_2a.gph, replace)

bys year: egen double t_informal = total(fac500a * informal) if resi==1
bys year: egen float  t_formal   = total(fac500a * formal)   if resi==1
label var t_informal "Empleos Informales"
label var t_formal "Empleos Formales"

br t_informal t_formal
format t_* %20.0fc

preserve 

keep t_* anio 
duplicates drop

scatter t_informal t_formal anio, /// 
 connect(l l) lcolor(red orange) msymbol(D S) mcolor(red orange)  /// 
 mlabel(t_informal t_formal) mlabcolor(red orange) mlabposition(6 12) ///
 mlabsize(small small) yscale(off) xtitle("") legend(cols(2) position(6)) /// 
 xlabel(, nogrid) ylabel(, nogrid) ///
 saving(gr3_2b.gph, replace)

restore


gr combine gr3_2a.gph gr3_2b.gph, ///
title("GRÁFICO N° 3.2" "PERÚ: TASA DE EMPLEO FORMAL E INFORMAL Y VAR. DE LA PEA OCUPADA" "CON EMPLEO FORMAL E INFORMAL, 2017-2022", size(small) color(red) margin(medsmall)) ///
subtitle("(Porcentaje y absolutos)", size(small)) ///
xcommon commonscheme     
graph export gr3_2.png, replace 


