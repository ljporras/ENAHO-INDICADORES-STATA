cd "D:\ENAHO 2017" 

*Bajamos los archivos zipeados del modulo 100 y sumaria de la pagina del INEI
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/603-Modulo01.zip" 603-Modulo01.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/603-Modulo34.zip" 603-Modulo34.zip, replace

*Descomprimir los archivos del modulo 100 y sumaria "Manualmente"

use enaho01-2017-100.dta, clear
/* result: resultado final de la encuesta 
1: completa 
2: incompleta 
3: rechazo 
4: ausente 
5: vivienda desocupada 
6: otro */

*Se trabaja solo con las encuestas completas e incompletas 
drop if result>2

*NECESIDADES BASICAS INSATISFECHAS (ya se encuentran en el modulo 100)
sum nbi*

collapse (mean) nbi1 nbi2 nbi3 nbi4 nbi5, by(conglome vivienda hogar) cw

*Juntamos el modulo 100 con el modulo sumaria 
*(ambas bases presentan informacion a nivel del hogar)
merge 1:1  conglome vivienda hogar using  sumaria-2017.dta, nogenerate

*Creamos la variable factor de expansion de la poblacion
gen    facpob=factor07*mieperho

*Establecemos las caracteristicas de la encuesta 
*usando las variable factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


gen          nbihog=nbi1 + nbi2 + nbi3 + nbi4 + nbi5

gen    		 NBI1_POBRE=.
replace 	 NBI1_POBRE=1 if nbihog>0
replace		 NBI1_POBRE=0 if nbihog==0

label define NBI1_POBRE 0 "ninguna NBI" 1 "al menos un NBI"
label value  NBI1_POBRE NBI1_POBRE
label var    NBI1_POBRE "Con al menos una NBI"
tab          NBI1_POBRE

gen    		 NBI2_POBRE=.
replace		 NBI2_POBRE=1 if nbihog>1
replace		 NBI2_POBRE=0 if nbihog<2

label define NBI2_POBRE 0 "menos de dos NBI" 1 "al menos dos NBI"
label value  NBI2_POBRE NBI2_POBRE
label var    NBI2_POBRE "Con al menos dos NBI"
tab          NBI2_POBRE


*VARIABLES GEOGRAFICAS (area, regnat, dpto)
gen            area=estrato
recode         area (1/5=1) (6/8=2)
label define   area 1 "urbano" 2 "rural"
label values   area area

gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7

lab var regnat "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat

destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "Departamento"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
label define dpto 7 "Callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto


*Cambiamos el nombre de la variable ahno y le damos 
*nombre a los nbi para eliminar los caracteres que no reconoce STATA
rename a*o anio
label var nbi1 "Poblacion en viviendas con caracteristicas fisicas inadecuadas"
label var nbi2 "Poblacion en viviendas con hacinamiento"
label var nbi3 "Poblacion en viviendas sin desague de ningun tipo"
label var nbi4 "Poblacion en hogares con ninos (6 a 12) que no asisten a la escuela"
label var nbi5 "Poblacion en hogares con alta dependencia economica"
label var NBI1_POBRE "Con al menos una NBI"
label var NBI2_POBRE "De 2 a 5 NBI"

svy: mean nbi1 nbi2 nbi3 nbi4 nbi5
outreg using nbi.doc, replace stat(b se ci) nosubstat bdec(4) varlabels ///
ctitle("","Pobreza","Error Estandar","Intervalo de confianza al 95%") /// 
title("Indicadores de NBI - 2017") ///
note(""\"Ejecutado el $S_TIME, $S_DATE"\"Fuente: ENAHO 2017")

svy: mean NBI1_POBRE 
outreg using nbi.doc, addtable stat(b se ci) nosubstat bdec(4) varlabels /// 
ctitle("","Pobreza","Error Estandar","Intervalo de confianza al 95%") /// 
title("Porcentaje de la poblacion con al menos 1 NBI (a) - 2017")

svy: mean NBI1_POBRE , over(area)
outreg using nbi.doc, addtable stat(b se ci) nosubstat bdec(4) varlabels /// 
ctitle("Ambito","Pobreza","Error Estandar","Intervalo de confianza al 95%") ///
title("Porcentaje de la poblacion con al menos 1 NBI (b) - 2017")

svy: mean NBI1_POBRE , over(regnat)
outreg using nbi.doc, addtable stat(b se ci) nosubstat bdec(4) varlabels ///
ctitle("Ambito","Pobreza","Error Estandar","Intervalo de confianza al 95%") /// 
title("Porcentaje de la poblacion con al menos 1 NBI (c) - 2017")
