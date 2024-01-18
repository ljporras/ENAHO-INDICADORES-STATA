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
*PEA ocupada por Rama de Actividad
*CIIU
br p506r4 

gen      ciiu_aux1 =substr("0"+string(p506r4),1,.)

br p506r4 ciiu_aux1
replace  ciiu_aux1 =substr(string(p506r4),1,.) if p506r4>999
br p506r4 ciiu_aux1

gen      ciiu_aux2 =substr(ciiu_aux1 ,1,2)
br p506r4 ciiu_aux1

destring ciiu_aux2, generate(ciiu_2d)
br p506r4 ciiu_aux1 ciiu_2d


gen      ciiu_1d=1 if  ciiu_2d<=2
replace  ciiu_1d=2 if  ciiu_2d==3
replace  ciiu_1d=3 if  ciiu_2d>=5  & ciiu_2d<=9
replace  ciiu_1d=4 if  ciiu_2d>=10 & ciiu_2d<=33
replace  ciiu_1d=5 if  ciiu_2d>=41 & ciiu_2d<=43
replace  ciiu_1d=6 if  ciiu_2d>=45 & ciiu_2d<=47
replace  ciiu_1d=7 if (ciiu_2d>=49 & ciiu_2d<=53) | (ciiu_2d>=58 & ciiu_2d<=63)
replace  ciiu_1d=8 if  ciiu_2d==84
replace  ciiu_1d=9 if  ciiu_2d>=55 & ciiu_2d<=56
replace  ciiu_1d=10 if ciiu_2d==68 | (ciiu_2d>=69 & ciiu_2d<=82)
replace  ciiu_1d=11 if ciiu_2d==85 					 
replace  ciiu_1d=12 if (ciiu_2d>=35 & ciiu_2d<=39) | (ciiu_2d>=64 & ciiu_2d<=66)  | ///
  (ciiu_2d>=86 & ciiu_2d<=88) |  (ciiu_2d>=90 & ciiu_2d<=93)| (ciiu_2d>=94 & ciiu_2d<=98) |  ciiu_2d==99
label var ciiu_1d "Division CIIU"
la de ciiu_1d 1 "Agricultura" 2 "Pesca"  3 "Mineria" 4 "Manufactura" 5 "Construccion" ///
 6 "Comercio" 7 "Transportes y Comunicaciones"  8 "Gobierno" 9 "Hoteles y Restaurantes" ///
 10 "Inmobiliarias y alquileres" 11 "Ensehnanza" 12 "Otros Servicios 1/"
 label values ciiu_1d ciiu_1d
br p506r4 ciiu_aux1 ciiu_2d ciiu_1d


gen       ciiu_5=1 if ciiu_1d<4
replace   ciiu_5=2 if ciiu_1d==4
replace   ciiu_5=3 if ciiu_1d==5
replace   ciiu_5=4 if ciiu_1d==6
replace   ciiu_5=5 if ciiu_1d>6
label var ciiu_5 "Division CIIU-5 categorias"
la de ciiu_5 1 "Extractiva 1/" 2 "Industria" 3 "Construccion" ///
 4 "Comercio" 5 "Servicios 2/"
label values ciiu_5 ciiu_5
br p506r4 ciiu_aux1 ciiu_2d ciiu_1d ciiu_5


table ciiu_5 year if resi==1 & ocu500==1 [iw= fac500a],  nformat(%12.0fc)









gen extr=ciiu_5==1
gen indu=ciiu_5==2
gen cons=ciiu_5==3
gen come=ciiu_5==4
gen serv=ciiu_5==5
gen tot =ciiu_5<6

bys year: egen float t_extr = total(fac500a * extr) if resi==1 & ocu500==1
bys year: egen float t_indu = total(fac500a * indu) if resi==1 & ocu500==1
bys year: egen long  t_cons = total(fac500a * cons) if resi==1 & ocu500==1
bys year: egen float t_come = total(fac500a * come) if resi==1 & ocu500==1
bys year: egen float t_serv = total(fac500a * serv) if resi==1 & ocu500==1
bys year: egen float t_tot  = total(fac500a * tot)  if resi==1 & ocu500==1
label var t_extr "Extractiva 1/"
label var t_indu "Industria"
label var t_cons "Construccion"
label var t_come "Comercio"
label var t_serv "Servicios 2/"

gen p_extr=t_extr*100/t_tot
gen p_indu=t_indu*100/t_tot
gen p_cons=t_cons*100/t_tot
gen p_come=t_come*100/t_tot
gen p_serv=t_serv*100/t_tot

format t_* %20.0fc
format p_extr p_indu p_cons p_come p_serv %4.1f

keep t_* p_* anio 
duplicates drop
 twoway ///
 (scatter p_extr p_indu p_cons p_come p_serv anio, /// 
 mcolor(none none none none none)                  ///
 mlabel(p_extr p_indu p_cons p_come p_serv)        ///
 mlabsize(vsmall vsmall vsmall vsmall vsmall)      ///
 mlabcolor(orange gold gray navy red)  ///
 mlabposition(3 12 5 5 10)             ///
 yaxis(2) ylabel(,nogrid) yscale(off)  yscale(lpattern(blank) ) ///
 xtitle("") xlabel(, nogrid)        )  ///
 (scatter t_extr t_indu t_cons t_come t_serv anio,          ///
 connect(l l l l l) lcolor(orange gold gray navy red)       ///
 msymbol(Dh Dh Dh Dh Dh) mcolor(orange gold gray navy red)  /// 
 mlabel(t_extr t_indu t_cons t_come t_serv)    /// 
 mlabsize(vsmall vsmall vsmall vsmall vsmall)  ///
 mlabcolor(orange gold gray navy red)          ///
 mlabposition(6 11 7 8 8)                      ///
 yaxis(1) ylabel(, nogrid) yscale(off)  yscale(lpattern(blank))   ///
 xtitle("") xlabel(, nogrid)            ),              ///
 legend(on) legend(order(6 7 8 9 10) size(vsmall) cols(5) position(6)) /// 
 yscale(off)  yscale(lpattern(blank))  ///
 title("GRÁFICO N° 2.12" "PERÚ: PEA OCUPADA, SEGÚN RAMA DE ACTIVIDAD ECONÓMICA, 2017-2022", size(small) color(red) margin(vsmall)) /// 
 subtitle("(Absoluto y porcentaje)", size(vsmall) margin(small)) /// 
 note("Nota: Clasificación de ramas de actividad basada en el CIIU Rev. 4." "Fuente: INEI-ENAHO, 2017-2022.", size(vsmall))
 