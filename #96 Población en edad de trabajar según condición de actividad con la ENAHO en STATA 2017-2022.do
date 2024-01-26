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
label var year "Year"

tab p500i year
drop if p500i=="00"

*Se establece quienes son residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))
*P204 ¿Es miembro del hogar?	204. ¿Es miembro del hogar familiar? 1. Sí 2. No
*P205 ¿Se encuentra ausente del hogar 30 días o más?	1. Sí 2. No
*P206 ¿Está presente en el hogar 30 días o más? 1. Sí 2. No



********************************************************************************
*CUADRO N° 2.1 PERÚ: DISTRIBUCIÓN DE LA POBLACIÓN EN EDAD DE TRABAJAR, 
*SEGÚN CONDICIÓN DE ACTIVIDAD, 2017-2022

collect clear

tabulate ocu500 year if resi==1 [iw= fac500a]
table ocu500 year if resi==1 [iw= fac500a],  nformat(%12.0fc)


*collect style header edits the content of the table headers
collect style header, title(hide)
collect style header var, level(value)
collect style header result, level(hide)
collect preview

putexcel set cuadros.xlsx, sheet(2_1, replace) replace
putexcel A1= "CUADRO N° 2.1 PERÚ: DISTRIBUCIÓN DE LA POBLACIÓN EN EDAD DE TRABAJAR, SEGÚN CONDICIÓN DE ACTIVIDAD, 2017-2022", bold font("Calibri",11,"red")
putexcel A2= "(Absoluto y porcentaje)", font("",10,"")
putexcel A4 = collect
putexcel A4 = "Condición de actividad"
putexcel A5= "PEA Ocupada"
putexcel A6= "PEA Desempleada"
putexcel A7= "Desempleo oculto"
putexcel A8= "Inactivo pleno"
putexcel A9= "Pob. en Edad de Trabajar (PET)"

putexcel A10= "Pob. Eco. Activa (PEA)"
putexcel B10=formula(B5 + B6), nformat(#,###)
putexcel C10=formula(C5 + C6), nformat(#,###)
putexcel D10=formula(D5 + D6), nformat(#,###)
putexcel E10=formula(E5 + E6), nformat(#,###)
putexcel F10=formula(F5 + F6), nformat(#,###)
putexcel G10=formula(G5 + G6), nformat(#,###)
putexcel H10=formula(H5 + H6), nformat(#,###)

putexcel A11= "Pob. Eco. Inactiva (PEI)"
putexcel B11=formula(B7 + B8), nformat(#,###)
putexcel C11=formula(C7 + C8), nformat(#,###)
putexcel D11=formula(D7 + D8), nformat(#,###)
putexcel E11=formula(E7 + E8), nformat(#,###)
putexcel F11=formula(F7 + F8), nformat(#,###)
putexcel G11=formula(G7 + G8), nformat(#,###)
putexcel H11=formula(H7 + H8), nformat(#,###)

forvalues i=5/11 {
putexcel J`i'=formula(G`i'- D`i'), nformat(#,###)
putexcel K`i'=formula((G`i'- D`i')*100/D`i' ), nformat(#.0)
}
putexcel J4= "Var. Abs. 2022/2019"
putexcel K4= "Var. Por. 2022/2019"

putexcel A12= "Nota: La suma de las partes puede no coincidir con el total debido al redondeo de las cifras."
putexcel A13= "Fuente: INEI-Encuesta Nacional de Hogares, 2017-2022."
putexcel A14= "Elaboración: MTPE-DGPE-Dirección de Investigación Socio Económico Laboral (DISEL)." 

putexcel A4:K4 A9:K11, bold font("",9,"")
putexcel A5:K8 A12:A14, font("",9,"")
putexcel A1:K14, border(all,none) 
