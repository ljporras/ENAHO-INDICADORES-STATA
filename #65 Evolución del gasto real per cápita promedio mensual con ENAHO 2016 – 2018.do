clear all
cd             "E:\GTO"
global gto   = "E:\GTO"

/* Bajar los archivos sumaria de la pagina del INEI
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/546-Modulo34.zip" 546-Modulo34.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/603-Modulo34.zip" 603-Modulo34.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo34.zip" 634-Modulo34.zip, replace
*/

*Descomprimo manualmente los archivos sumaria, "deflactores_base2018_new.dta" & "despacial_ldnew.dta"  
*y los coloco en la misma carpeta de trabajo

set mem 500m
set more off
use          sumaria-2016, clear
append using sumaria-2017
append using sumaria-2018

destring conglome, replace
tostring conglome, replace format(%06.0f)

recode gru52hd2-gashog2d (.= 0)

rename a*o anio
gen aniorec=real(anio)

gen dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" /*
*/12"Junin" 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" /*
*/23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 

sort aniorec dpto
merge aniorec dpto using "deflactores_base2018_new.dta"
tab _m
drop if _merge==2
drop _m

*Genero las variables de area de residencia, region natural y dominio geografico
replace estrato = 1 if dominio ==8 
gen area = estrato <6
replace area=2 if area==0
label define area 2 rural 1 urbana
label val area area

gen     domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" 4 "Sierra_rural" /* 
*/ 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02

gen     region=1 if dominio>=1 & dominio<=3 
replace region=1 if dominio==8
replace region=2 if dominio>=4 & dominio<=6 
replace region=3 if dominio==7 
label define region 1 "Costa" 2 "Sierra" 3 "Selva"
label values region region

gen     dominioA=1 if dominio==1 & area==1
replace dominioA=2 if dominio==1 & area==2
replace dominioA=3 if dominio==2 & area==1
replace dominioA=4 if dominio==2 & area==2
replace dominioA=5 if dominio==3 & area==1
replace dominioA=6 if dominio==3 & area==2
replace dominioA=7 if dominio==4 & area==1
replace dominioA=8 if dominio==4 & area==2
replace dominioA=9 if dominio==5 & area==1
replace dominioA=10 if dominio==5 & area==2
replace dominioA=11 if dominio==6 & area==1
replace dominioA=12 if dominio==6 & area==2
replace dominioA=13 if dominio==7 & area==1
replace dominioA=14 if dominio==7 & area==2
replace dominioA=15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA=16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==2
replace dominioA=17 if dominio==8 & area==1
replace dominioA=17 if dominio==8 & area==2
label define dominioA 1 "Costa norte urbana" 2 "Costa norte rural" 3 "Costa centro urbana" 4 "Costa centro rural" /*
*/ 5 "Costa sur urbana" 6 "Costa sur rural"	7 "Sierra norte urbana"	8 "Sierra norte rural"	9 "Sierra centro urbana" /* 
*/ 10 "Sierra centro rural"	11 "Sierra sur urbana" 12 "Sierra sur rural" 13 "Selva alta urbana"	14 "Selva alta rural" /*
*/ 15 "Selva baja urbana" 16 "Selva baja rural" 17"Lima Metropolitana"
lab val dominioA dominioA 

drop ld

sort  dominioA

merge dominioA using "despacial_ldnew.dta"
tab _m
drop _m

gen factornd07=round(factor07*mieperho,1)


*GASTOS REALES
*******************************************************************************/
*CREANDO VARIABLES DEL GASTO DEFLACTADO A PRECIOS DE LIMA Y BASE 2018 a nivel total**/
*******************************************************************************/
*Gasto por 8 grupos de la canastas*
gen 	gpcrg3= (gru11hd + gru12hd1 + gru12hd2 + gru13hd1 + gru13hd2 + gru13hd3 )/(12*mieperho*ld*i01)
lab var gpcrg3	"Preparados dentro del hogar"

gen 	gpcrg6 = ((g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 +g05hd6 +ig06hd)/(12*mieperho*ld*i01))
lab var gpcrg6	"Adquiridos Fuera del hogar 559"

gen 	gpcrg8= ((sg23 + sig24)/(12*mieperho*ld*i01))
lab var gpcrg8	"Adquiridos de instituciones beneficas 602a"

gen 	gpcrg9= ((gru14hd + gru14hd1 +  gru14hd2 + gru14hd3 + gru14hd4 + gru14hd5 + sg25 + sig26)/(12*mieperho*ld*i01))
lab var gpcrg9	"Adquiridos fuera del hogar item 47 y 50 y 602"

gen    	gpcrg10= ((gru21hd + gru22hd1 + gru22hd2 + gru23hd1 + gru23hd2 + gru23hd3 + gru24hd)/(12*mieperho*ld*i02))
lab var gpcrg10	"Vestido y calzado"

gen     gpcrg12= ((gru31hd + gru32hd1 + gru32hd2 + gru33hd1 + gru33hd2 + gru33hd3 + gru34hd)/(12*mieperho*ld*i03))
lab var gpcrg12	"Gasto Alquiler de vivienda y combustible"

gen     gpcrg14= ((gru41hd + gru42hd1 + gru42hd2 + gru43hd1 + gru43hd2 + gru43hd3 + gru44hd + sg421 + sg42d1 + sg423 + sg42d3)/(12*mieperho*ld*i04))
lab var gpcrg14	"Muebles y enseres"

gen    	gpcrg16= ((gru51hd + gru52hd1 + gru52hd2 + gru53hd1 + gru53hd2 + gru53hd3 + gru54hd)/(12*mieperho*ld*i05))
lab var gpcrg16	"Cuidados de la salud"

gen     gpcrg18= ((gru61hd + gru62hd1 + gru62hd2 + gru63hd1 + gru63hd2 + gru63hd3 + gru64hd + g07hd + ig08hd + sg422 + sg42d2)/(12*mieperho*ld*i06))
lab var gpcrg18	"Transporte y comunicaciones"

gen     gpcrg19= ((gru71hd + gru72hd1 + gru72hd2 + gru73hd1 + gru73hd2 + gru73hd3 + gru74hd + sg42 + sg42d)/(12*mieperho*ld*i07))
lab var gpcrg19	"Esparcimiento diversión y cultura"

gen     gpcrg21= ((gru81hd + gru82hd1 + gru82hd2 + gru83hd1 + gru83hd2 + gru83hd3 + gru84hd)/(12*mieperho*ld*i08))
lab var gpcrg21	"Otros gastos de bienes y servicios"


*RECODIFICANDO POR grupo de gastos
gen 	gpgru2= gpcrg3
lab var gpgru2 "G011.Alimentos dentro del hogar real"
gen		gpgru3= gpcrg6 + gpcrg8 + gpcrg9
lab var gpgru3 "G012.Alimentos fuera del hogar real"
gen 	gpgru1 = gpgru2 + gpgru3
lab var gpgru1 "G01.Total en Alimentos real"

gen		gpgru4 = gpcrg10
lab var gpgru4 "G02.Vestido y calzado real"

gen		gpgru5 = gpcrg12
lab var gpgru5 "G03.Alquiler de Vivienda y combustible real"

gen		gpgru6 = gpcrg14
lab var gpgru6 "G04.Muebles y enseres real"

gen		gpgru7= gpcrg16
lab var gpgru7 "G05.Cuidados de la salud real"

gen		gpgru8 = gpcrg18
lab var gpgru8 "G06.Transportes y comunicaciones real"

gen		gpgru9 = gpcrg19
lab var gpgru9 "G07.Esparcimiento diversion y cultura real"

gen		gpgru10 = gpcrg21 
lab var gpgru10 "G08.otros gastos en bienes y servicios real"

gen  	gpgru0 = gpgru1 + gpgru4 + gpgru5 + gpgru6 + gpgru7 + gpgru8 + gpgru9 + gpgru10 
lab var gpgru0 "Gto real promedio pc mensual"

*** Salidas ***
svyset [pweight = factornd07], psu(conglome)strata(estrato)

*** Gasto real promedio percapita mensual ***
svy:mean gpgru0, over(aniorec)

svy:mean gpgru0 if area==1, over(aniorec)
svy:mean gpgru0 if area==2, over(aniorec)

preserve
collapse  (mean) gpgru0 [aw=factornd07], by(aniorec)
export excel using "$gto/year", firstrow(variables) sheet("all") replace
restore

preserve
collapse  (mean) gpgru0 [aw=factornd07], by(aniorec area)
export excel using "$gto/year", firstrow(variables) sheet("area") 
restore


*** Grafico de barras 2017/2018
gen temp2017=gpgru0 if aniorec==2017
gen temp2018=gpgru0 if aniorec==2018
lab var temp2017 "2017"
lab var temp2018 "2018"

graph bar temp2017 temp2018 [pweight = factornd07], over(region, label)  blabel(bar, format(%9.0f)) ///
   legend(label(1 "2017") label(2 "2018")) ///
   bar(2,color(ltblue)) ///
   title("Perú: Gasto real promedio per cápita mensual, según regiones naturales, 2017 - 2018",size(small)) ///
   subtitle("(Soles constantes base=2018 a precios de Lima Metropolitana)",size(vsmall))
  
graph export "Graph1.png", as(png) replace

